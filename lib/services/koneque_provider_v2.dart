import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/contract_config.dart';
import '../models/product.dart';
import '../models/transaction.dart';
import '../services/contract_service.dart';
import '../services/reown_service_v2.dart';
import '../services/pinata_service.dart';

/// Provider para gestionar el estado de la aplicación Koneque con ReownServiceV2
class KonequeProviderV2 extends ChangeNotifier {
  // Estados de conexión
  bool _isConnected = false;
  String? _connectedAddress;
  BigInt _ethBalance = BigInt.zero;
  BigInt _tokenBalance = BigInt.zero;
  String? _smartAccountAddress;
  bool _isConnecting = false;
  String? _currentChainId;
  
  // Estados de productos
  List<Product> _products = [];
  bool _isLoadingProducts = false;
  
  // Estados de transacciones
  List<Transaction> _userTransactions = [];
  bool _isLoadingTransactions = false;
  
  // Estados de referidos
  String? _activeReferralCode;
  bool _hasReferralRegistered = false;
  
  // Estados de carga general
  bool _isInitializing = false;
  String? _errorMessage;
  
  // Getters
  bool get isConnected => _isConnected;
  String? get connectedAddress => _connectedAddress;
  BigInt get ethBalance => _ethBalance;
  BigInt get tokenBalance => _tokenBalance;
  String? get smartAccountAddress => _smartAccountAddress;
  List<Product> get products => _products;
  bool get isLoadingProducts => _isLoadingProducts;
  List<Transaction> get userTransactions => _userTransactions;
  bool get isLoadingTransactions => _isLoadingTransactions;
  String? get activeReferralCode => _activeReferralCode;
  bool get hasReferralRegistered => _hasReferralRegistered;
  bool get isInitializing => _isInitializing;
  bool get isConnecting => _isConnecting;
  String? get errorMessage => _errorMessage;
  
  /// Inicializa los servicios con contexto
  Future<void> initializeWithContext(BuildContext context) async {
    try {
      _isInitializing = true;
      notifyListeners();
      
      // Inicializar ReownServiceV2 con contexto
      await ReownServiceV2.initWithContext(context);
      
      // Configurar listeners
      _setupReownListeners();
      
      // Verificar conexión existente
      await _checkWalletConnection();
      
      // Cargar productos
      await loadProducts();
      
      if (kDebugMode) {
        print('✅ Servicios inicializados correctamente');
      }
      
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      if (kDebugMode) {
        print('❌ Error inicializando servicios: $e');
      }
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }
  
  /// Verifica el estado de conexión de la wallet
  Future<void> _checkWalletConnection() async {
    try {
      _isConnected = ReownServiceV2.isConnected;
      _connectedAddress = ReownServiceV2.connectedAddress;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error verificando conexión de wallet: $e');
      }
    }
  }
  
  /// Configura los listeners de eventos de Reown
  void _setupReownListeners() {
    // Listener para conexión
    ReownServiceV2.onSessionConnect((connect) async {
      if (connect != null) {
        _isConnected = true;
        _connectedAddress = ReownServiceV2.connectedAddress;
        await _loadUserData();
        notifyListeners();
      }
    });
    
    // Listener para desconexión
    ReownServiceV2.onSessionDisconnect((disconnect) {
      _isConnected = false;
      _connectedAddress = null;
      _smartAccountAddress = null;
      _ethBalance = BigInt.zero;
      _tokenBalance = BigInt.zero;
      notifyListeners();
    });
    
    // Listener para cambio de red
    ReownServiceV2.onNetworkChanged((networkChange) async {
      if (networkChange != null) {
        await _loadUserData();
      }
    });
  }
  
  /// Conecta la wallet
  Future<void> connectWallet({BuildContext? context}) async {
    if (_isConnecting) return;
    
    try {
      _isConnecting = true;
      _errorMessage = null;
      notifyListeners();
      
      if (kDebugMode) {
        print('🔗 Iniciando conexión de wallet...');
      }
      
      // Verificar si Reown está inicializado
      if (!ReownServiceV2.isInitialized) {
        throw Exception('Reown service no está inicializado');
      }
      
      // Conectar wallet usando el nuevo servicio
      await ReownServiceV2.connectWallet();
      
      // Verificar si la conexión fue exitosa
      await _checkWalletConnection();
      
      if (_isConnected) {
        await _loadUserData();
        if (kDebugMode) {
          print('✅ Wallet conectada exitosamente: $_connectedAddress');
        }
      } else {
        if (kDebugMode) {
          print('⚠️ Conexión de wallet cancelada o falló');
        }
      }
      
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      if (kDebugMode) {
        print('❌ Error conectando wallet: $e');
      }
      rethrow;
    } finally {
      _isConnecting = false;
      notifyListeners();
    }
  }
  
  /// Reintenta la conexión con la wallet
  Future<void> retryConnection() async {
    try {
      _errorMessage = null;
      notifyListeners();
      
      await disconnectWallet();
      await Future.delayed(const Duration(seconds: 1));
      await connectWallet();
      
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      if (kDebugMode) {
        print('❌ Error reintentando conexión: $e');
      }
      notifyListeners();
    }
  }
  
  /// Desconecta la wallet
  Future<void> disconnectWallet() async {
    try {
      if (kDebugMode) {
        print('🔌 Desconectando wallet...');
      }
      
      await ReownServiceV2.disconnect();
      
      _isConnected = false;
      _connectedAddress = null;
      _smartAccountAddress = null;
      _ethBalance = BigInt.zero;
      _tokenBalance = BigInt.zero;
      _errorMessage = null;
      
      notifyListeners();
      
      if (kDebugMode) {
        print('✅ Wallet desconectada');
      }
      
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      if (kDebugMode) {
        print('❌ Error desconectando wallet: $e');
      }
      notifyListeners();
    }
  }
  
  /// Carga los datos del usuario
  Future<void> _loadUserData() async {
    if (!_isConnected || _connectedAddress == null) return;
    
    try {
      await loadUserTransactions();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cargando datos del usuario: $e');
      }
    }
  }
  
  /// Carga los productos disponibles
  Future<void> loadProducts() async {
    try {
      _isLoadingProducts = true;
      notifyListeners();
      
      final contracts = ContractConfig.baseSepolia;
      final productData = await ContractService.getProductsFromContract(
        contracts.marketplaceContract,
        contracts.rpcUrl,
      );
      
      _products = productData;
      
      if (kDebugMode) {
        print('✅ ${_products.length} productos cargados');
      }
      
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cargando productos: $e');
      }
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }
  
  /// Carga las transacciones del usuario
  Future<void> loadUserTransactions() async {
    if (!_isConnected || _connectedAddress == null) return;
    
    try {
      _isLoadingTransactions = true;
      notifyListeners();
      
      final contracts = ContractConfig.baseSepolia;
      final transactionData = await ContractService.getUserTransactions(
        contracts.marketplaceContract,
        contracts.rpcUrl,
        _connectedAddress!,
      );
      
      _userTransactions = transactionData;
      
      if (kDebugMode) {
        print('✅ ${_userTransactions.length} transacciones cargadas');
      }
      
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cargando transacciones: $e');
      }
    } finally {
      _isLoadingTransactions = false;
      notifyListeners();
    }
  }
  
  /// Lista un producto
  Future<bool> listProduct({
    required String name,
    required String description,
    required BigInt price,
    required String imageUrl,
  }) async {
    if (!_isConnected || _connectedAddress == null) {
      throw Exception('Wallet no conectada');
    }
    
    try {
      final contracts = ContractConfig.baseSepolia;
      final success = await ContractService.listProduct(
        contracts.marketplaceContract,
        contracts.rpcUrl,
        _connectedAddress!,
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl,
      );
      
      if (success) {
        await loadProducts();
        if (kDebugMode) {
          print('✅ Producto listado exitosamente');
        }
      }
      
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error listando producto: $e');
      }
      return false;
    }
  }
  
  /// Compra un producto
  Future<bool> buyProduct(BigInt itemId) async {
    if (!_isConnected || _connectedAddress == null) {
      throw Exception('Wallet no conectada');
    }
    
    try {
      final contracts = ContractConfig.baseSepolia;
      final success = await ContractService.buyProduct(
        contracts.marketplaceContract,
        contracts.rpcUrl,
        _connectedAddress!,
        itemId,
      );
      
      if (success) {
        await loadUserTransactions();
        await loadProducts();
        if (kDebugMode) {
          print('✅ Producto comprado exitosamente');
        }
      }
      
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error comprando producto: $e');
      }
      return false;
    }
  }
  
  /// Confirma la entrega de un producto
  Future<bool> confirmDelivery(BigInt transactionId) async {
    if (!_isConnected || _connectedAddress == null) {
      throw Exception('Wallet no conectada');
    }
    
    try {
      final contracts = ContractConfig.baseSepolia;
      final success = await ContractService.confirmDelivery(
        contracts.marketplaceContract,
        contracts.rpcUrl,
        _connectedAddress!,
        transactionId,
      );
      
      if (success) {
        await loadUserTransactions();
        if (kDebugMode) {
          print('✅ Entrega confirmada exitosamente');
        }
      }
      
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error confirmando entrega: $e');
      }
      return false;
    }
  }
  
  /// Finaliza una transacción
  Future<bool> finalizeTransaction(BigInt transactionId) async {
    if (!_isConnected || _connectedAddress == null) {
      throw Exception('Wallet no conectada');
    }
    
    try {
      final contracts = ContractConfig.baseSepolia;
      final success = await ContractService.finalizeTransaction(
        contracts.marketplaceContract,
        contracts.rpcUrl,
        _connectedAddress!,
        transactionId,
      );
      
      if (success) {
        await loadUserTransactions();
        if (kDebugMode) {
          print('✅ Transacción finalizada exitosamente');
        }
      }
      
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error finalizando transacción: $e');
      }
      return false;
    }
  }
  
  /// Obtiene un mensaje de error amigable
  String _getErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    
    if (errorStr.contains('user rejected') || errorStr.contains('cancelled')) {
      return 'Conexión cancelada por el usuario';
    } else if (errorStr.contains('timeout')) {
      return 'Tiempo de espera agotado. Intenta nuevamente';
    } else if (errorStr.contains('network')) {
      return 'Error de red. Verifica tu conexión';
    } else if (errorStr.contains('insufficient')) {
      return 'Fondos insuficientes';
    } else {
      return 'Error inesperado. Intenta nuevamente';
    }
  }
  
  /// Limpia el mensaje de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  /// Refresca todos los datos
  Future<void> refresh() async {
    await loadProducts();
    if (_isConnected) {
      await _loadUserData();
    }
  }
  
  @override
  void dispose() {
    ReownServiceV2.dispose();
    super.dispose();
  }
}
