import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/contract_config.dart';
import '../models/product.dart';
import '../models/transaction.dart';
import '../services/contract_service.dart';
import '../services/reown_service_v2.dart';
import '../services/pinata_service.dart';

/// Provider para gestionar el estado de la aplicación Koneque
class KonequeProvider extends ChangeNotifier {
  // Estados de conexión
  bool _isConnected = false;
  String? _connectedAddress;
  BigInt _ethBalance = BigInt.zero;
  BigInt _tokenBalance = BigInt.zero;
  String? _smartAccountAddress;
  
  // Instancia del nuevo servicio (disponible globalmente)
  
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
  String? get errorMessage => _errorMessage;
  
  /// Inicializa el provider
  Future<void> initialize() async {
    _isInitializing = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Inicializar servicios
      await ContractService.initialize();
      
      // Verificar conexión de wallet
      await _checkWalletConnection();
      
      // Cargar productos iniciales
      await loadProducts();
      
      // Si hay wallet conectada, cargar datos del usuario
      if (_isConnected) {
        await _loadUserData();
      }
      
      // Configurar listeners de Reown
      _setupReownListeners();
      
      // Verificar conexión con Pinata
      await _testPinataConnection();
      
    } catch (e) {
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('❌ Error inicializando KonequeProvider: $e');
      }
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }
  
  /// Inicializa el servicio de Reown con contexto
  Future<void> initializeReownService(BuildContext context) async {
    await ReownServiceV2.initWithContext(context);
    _setupReownListeners();
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
      await _checkWalletConnection();
      if (_isConnected) {
        await _loadUserData();
      }
    });
  }
  
  /// Conecta la wallet con manejo de errores mejorado
  Future<void> connectWallet([BuildContext? context]) async {
    try {
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
      
      // Dar tiempo para que la conexión se establezca
      await Future.delayed(const Duration(seconds: 2));
      
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
      notifyListeners();
      rethrow;
    }
  }
  
  /// Reintenta la conexión con la wallet
  Future<void> retryConnection() async {
    try {
      _errorMessage = null;
      notifyListeners();
      
      // Desconectar cualquier sesión anterior
      await disconnectWallet();
      
      // Esperar un momento antes de reconectar
      await Future.delayed(const Duration(seconds: 1));
      
      // Intentar reconectar
      await connectWallet();
      
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      if (kDebugMode) {
        print('❌ Error en reintento de conexión: $e');
      }
      notifyListeners();
      rethrow;
    }
  }
  
  /// Obtiene un mensaje de error más amigable
  String _getErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    
    if (errorStr.contains('timeout')) {
      return 'Conexión agotada. Verifica que MetaMask esté instalado y activo.';
    } else if (errorStr.contains('user rejected')) {
      return 'Conexión cancelada por el usuario.';
    } else if (errorStr.contains('session')) {
      return 'Error de sesión. Intenta desconectar y conectar nuevamente.';
    } else if (errorStr.contains('network')) {
      return 'Error de red. Verifica tu conexión a internet.';
    } else {
      return 'Error de conexión. Intenta nuevamente en unos segundos.';
    }
  }
  
  /// Desconecta la wallet
  Future<void> disconnectWallet() async {
    try {
      await ReownServiceV2.disconnect();
      // El listener se encargará de limpiar el estado
    } catch (e) {
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('❌ Error desconectando wallet: $e');
      }
      notifyListeners();
    }
  }
  
  /// Carga datos específicos del usuario
  Future<void> _loadUserData() async {
    if (!_isConnected || _connectedAddress == null) return;
    
    try {
      // Cargar balances
      final ethBalance = await ContractService.getEthBalance(_connectedAddress!);
      final tokenBalance = await ContractService.getTokenBalance(_connectedAddress!);
      
      _ethBalance = ethBalance;
      _tokenBalance = tokenBalance;
      
      // Cargar transacciones del usuario
      await loadUserTransactions();
      
      // TODO: Verificar si tiene Smart Account
      // TODO: Verificar estado de referidos
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cargando datos del usuario: $e');
      }
    }
  }
  
  /// Carga la lista de productos del marketplace
  Future<void> loadProducts() async {
    _isLoadingProducts = true;
    notifyListeners();
    
    try {
      final products = await ContractService.getActiveProducts();
      _products = products;
    } catch (e) {
      _errorMessage = e.toString();
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
    
    _isLoadingTransactions = true;
    notifyListeners();
    
    try {
      // TODO: Implementar filtro por usuario en el contrato
      // Por ahora cargamos todas las transacciones y filtramos localmente
      final allTransactions = <Transaction>[];
      
      // Cargar transacciones por estado
      for (final status in TransactionStatus.values) {
        final transactions = await ContractService.getTransactionsByStatus(status);
        allTransactions.addAll(transactions);
      }
      
      // Filtrar transacciones del usuario
      _userTransactions = allTransactions.where((tx) => 
        tx.buyer.toLowerCase() == _connectedAddress!.toLowerCase() ||
        tx.seller.toLowerCase() == _connectedAddress!.toLowerCase()
      ).toList();
      
    } catch (e) {
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('❌ Error cargando transacciones del usuario: $e');
      }
    } finally {
      _isLoadingTransactions = false;
      notifyListeners();
    }
  }
  
  /// Lista un nuevo producto
  Future<bool> listProduct({
    required String name,
    required String description,
    required String category,
    required String condition,
    required String location,
    required BigInt price,
    required List<String> imageUrls,
    Map<String, dynamic>? attributes,
  }) async {
    if (!_isConnected) {
      _errorMessage = 'Wallet no conectada';
      notifyListeners();
      return false;
    }
    
    try {
      _errorMessage = null;
      
      // Crear metadatos del producto
      final metadata = ProductMetadata(
        name: name,
        description: description,
        images: imageUrls,
        condition: condition,
        location: location,
        attributes: attributes ?? {},
      );
      
      // Subir metadatos a IPFS
      final metadataURI = await PinataService.uploadProductMetadata(metadata);
      
      // Listar producto en el contrato
      final txHash = await ContractService.listItem(
        price: price,
        metadataURI: metadataURI,
        category: category,
      );
      
      // Recargar productos
      await loadProducts();
      
      if (kDebugMode) {
        print('✅ Producto listado exitosamente: $txHash');
      }
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('❌ Error listando producto: $e');
      }
      notifyListeners();
      return false;
    }
  }
  
  /// Compra un producto
  Future<bool> buyProduct(BigInt itemId) async {
    if (!_isConnected) {
      _errorMessage = 'Wallet no conectada';
      notifyListeners();
      return false;
    }
    
    try {
      _errorMessage = null;
      
      final txHash = await ContractService.buyItem(itemId);
      
      // Recargar datos
      await loadProducts();
      await _loadUserData();
      
      if (kDebugMode) {
        print('✅ Producto comprado exitosamente: $txHash');
      }
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('❌ Error comprando producto: $e');
      }
      notifyListeners();
      return false;
    }
  }
  
  /// Confirma la entrega de un producto
  Future<bool> confirmDelivery(BigInt transactionId) async {
    if (!_isConnected) {
      _errorMessage = 'Wallet no conectada';
      notifyListeners();
      return false;
    }
    
    try {
      _errorMessage = null;
      
      final txHash = await ContractService.confirmDelivery(transactionId);
      
      // Recargar transacciones
      await loadUserTransactions();
      
      if (kDebugMode) {
        print('✅ Entrega confirmada exitosamente: $txHash');
      }
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('❌ Error confirmando entrega: $e');
      }
      notifyListeners();
      return false;
    }
  }
  
  /// Finaliza una transacción
  Future<bool> finalizeTransaction(BigInt transactionId) async {
    if (!_isConnected) {
      _errorMessage = 'Wallet no conectada';
      notifyListeners();
      return false;
    }
    
    try {
      _errorMessage = null;
      
      final txHash = await ContractService.finalizeTransaction(transactionId);
      
      // Recargar datos
      await loadUserTransactions();
      await _loadUserData();
      
      if (kDebugMode) {
        print('✅ Transacción finalizada exitosamente: $txHash');
      }
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('❌ Error finalizando transacción: $e');
      }
      notifyListeners();
      return false;
    }
  }
  
  /// Crea un código de referido
  Future<bool> createReferralCode({
    required String code,
    required Duration validity,
    required int maxUsage,
  }) async {
    if (!_isConnected) {
      _errorMessage = 'Wallet no conectada';
      notifyListeners();
      return false;
    }
    
    try {
      _errorMessage = null;
      
      final txHash = await ContractService.createReferralCode(
        code: code,
        validity: validity,
        maxUsage: maxUsage,
      );
      
      _activeReferralCode = code;
      
      if (kDebugMode) {
        print('✅ Código de referido creado exitosamente: $txHash');
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('❌ Error creando código de referido: $e');
      }
      notifyListeners();
      return false;
    }
  }
  
  /// Registra con un código de referido
  Future<bool> registerWithReferralCode(String code) async {
    if (!_isConnected) {
      _errorMessage = 'Wallet no conectada';
      notifyListeners();
      return false;
    }
    
    try {
      _errorMessage = null;
      
      // Verificar que el código sea válido
      final isValid = await ContractService.isReferralCodeValid(code);
      if (!isValid) {
        _errorMessage = 'Código de referido inválido o expirado';
        notifyListeners();
        return false;
      }
      
      final txHash = await ContractService.registerReferralWithCode(code);
      
      _hasReferralRegistered = true;
      
      if (kDebugMode) {
        print('✅ Registrado con código de referido exitosamente: $txHash');
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('❌ Error registrando código de referido: $e');
      }
      notifyListeners();
      return false;
    }
  }
  
  /// Verifica conexión con Pinata
  Future<void> _testPinataConnection() async {
    try {
      final isConnected = await PinataService.testConnection();
      if (!isConnected) {
        if (kDebugMode) {
          print('⚠️ No se pudo conectar con Pinata');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error verificando conexión con Pinata: $e');
      }
    }
  }
  
  /// Limpia el mensaje de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  /// Recarga todos los datos
  Future<void> refresh() async {
    await loadProducts();
    if (_isConnected) {
      await _loadUserData();
    }
  }
  
  @override
  void dispose() {
    ReownServiceV2.dispose();
    ContractService.dispose();
    super.dispose();
  }
}
