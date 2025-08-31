import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart' hide Transaction;
import 'package:http/http.dart' as http;
import '../models/contract_config.dart';
import '../models/product.dart';
import '../models/transaction.dart';
import 'reown_service.dart';

/// Servicio principal para interactuar con los contratos inteligentes de Koneque
class ContractService {
  static Web3Client? _client;
  static Map<String, DeployedContract> _contracts = {};
  static bool _isInitialized = false;
  
  /// Inicializa el servicio de contratos
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Inicializar cliente Web3
      _client = Web3Client(ContractConfig.rpcUrl, http.Client());
      
      // Cargar y configurar contratos
      await _loadContracts();
      
      _isInitialized = true;
      print('✅ ContractService inicializado exitosamente');
    } catch (e) {
      print('❌ Error inicializando ContractService: $e');
      rethrow;
    }
  }
  
  /// Carga los ABIs y configura los contratos
  static Future<void> _loadContracts() async {
    try {
      // Lista de contratos a cargar
      final contractsToLoad = [
        'MarketplaceCore',
        'NativeToken',
        'SmartAccountFactory',
        'ReferralSystem',
        'Escrow',
        'FeeManager',
      ];
      
      for (final contractName in contractsToLoad) {
        try {
          // Cargar ABI desde assets
          final abiString = await rootBundle.loadString('assets/abis/${contractName}.json');
          final abiJson = jsonDecode(abiString);
          
          // Extraer solo el ABI del archivo compilado
          final abi = abiJson['abi'] as List<dynamic>;
          
          // Obtener dirección del contrato
          final address = _getContractAddress(contractName);
          if (address != null) {
            final contract = DeployedContract(
              ContractAbi.fromJson(jsonEncode(abi), contractName),
              EthereumAddress.fromHex(address),
            );
            
            _contracts[contractName] = contract;
            print('✅ Contrato $contractName cargado: $address');
          }
        } catch (e) {
          print('⚠️  No se pudo cargar el contrato $contractName: $e');
        }
      }
    } catch (e) {
      print('❌ Error cargando contratos: $e');
      rethrow;
    }
  }
  
  /// Obtiene la dirección de un contrato por nombre
  static String? _getContractAddress(String contractName) {
    final addressMap = {
      'MarketplaceCore': ContractConfig.contractAddresses['MARKETPLACE_CORE'],
      'NativeToken': ContractConfig.contractAddresses['NATIVE_TOKEN'],
      'SmartAccountFactory': ContractConfig.contractAddresses['SMART_ACCOUNT_FACTORY'],
      'ReferralSystem': ContractConfig.contractAddresses['REFERRAL_SYSTEM'],
      'Escrow': ContractConfig.contractAddresses['ESCROW'],
      'FeeManager': ContractConfig.contractAddresses['FEE_MANAGER'],
    };
    
    return addressMap[contractName];
  }
  
  /// Obtiene las credenciales de la wallet conectada
  /// Por ahora retorna null ya que usamos Reown para transacciones
  // static Future<Credentials?> _getCredentials() async {
  //   if (!ReownService.isConnected || ReownService.connectedAddress == null) {
  //     throw Exception('Wallet no conectada');
  //   }
  //   return null;
  // }
  
  // FUNCIONES DEL MARKETPLACE
  
  /// Lista un producto en el marketplace
  static Future<String> listItem({
    required BigInt price,
    required String metadataURI,
    required String category,
  }) async {
    try {
      if (!_isInitialized) await initialize();
      
      final contract = _contracts['MarketplaceCore'];
      if (contract == null) throw Exception('MarketplaceCore no disponible');
      
      // Para Reown, necesitamos enviar la transacción via WalletConnect
      final txHash = await _sendTransaction(
        contract: contract,
        functionName: 'listItem',
        parameters: [price, metadataURI, category],
        gasLimit: ContractConfig.gasLimits['listItem']!,
      );
      
      print('✅ Producto listado, TX: $txHash');
      return txHash;
    } catch (e) {
      print('❌ Error listando producto: $e');
      rethrow;
    }
  }
  
  /// Compra un producto
  static Future<String> buyItem(BigInt itemId) async {
    try {
      if (!_isInitialized) await initialize();
      
      final contract = _contracts['MarketplaceCore'];
      if (contract == null) throw Exception('MarketplaceCore no disponible');
      
      final txHash = await _sendTransaction(
        contract: contract,
        functionName: 'buyItem',
        parameters: [itemId],
        gasLimit: ContractConfig.gasLimits['buyItem']!,
      );
      
      print('✅ Producto comprado, TX: $txHash');
      return txHash;
    } catch (e) {
      print('❌ Error comprando producto: $e');
      rethrow;
    }
  }
  
  /// Confirma la entrega de un producto
  static Future<String> confirmDelivery(BigInt transactionId) async {
    try {
      if (!_isInitialized) await initialize();
      
      final contract = _contracts['MarketplaceCore'];
      if (contract == null) throw Exception('MarketplaceCore no disponible');
      
      final txHash = await _sendTransaction(
        contract: contract,
        functionName: 'confirmDelivery',
        parameters: [transactionId],
        gasLimit: ContractConfig.gasLimits['confirmDelivery']!,
      );
      
      print('✅ Entrega confirmada, TX: $txHash');
      return txHash;
    } catch (e) {
      print('❌ Error confirmando entrega: $e');
      rethrow;
    }
  }
  
  /// Finaliza una transacción
  static Future<String> finalizeTransaction(BigInt transactionId) async {
    try {
      if (!_isInitialized) await initialize();
      
      final contract = _contracts['MarketplaceCore'];
      if (contract == null) throw Exception('MarketplaceCore no disponible');
      
      final txHash = await _sendTransaction(
        contract: contract,
        functionName: 'finalizeTransaction',
        parameters: [transactionId],
        gasLimit: ContractConfig.gasLimits['finalizeTransaction']!,
      );
      
      print('✅ Transacción finalizada, TX: $txHash');
      return txHash;
    } catch (e) {
      print('❌ Error finalizando transacción: $e');
      rethrow;
    }
  }
  
  /// Obtiene detalles de un producto
  static Future<Product?> getProduct(BigInt itemId) async {
    try {
      if (!_isInitialized) await initialize();
      
      final contract = _contracts['MarketplaceCore'];
      if (contract == null) return null;
      
      final function = contract.function('getItem');
      final result = await _client!.call(
        contract: contract,
        function: function,
        params: [itemId],
      );
      
      if (result.isNotEmpty && result[0] != BigInt.zero) {
        return Product.fromContractData(result);
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo producto: $e');
      return null;
    }
  }
  
  /// Obtiene todos los productos activos
  static Future<List<Product>> getActiveProducts() async {
    try {
      if (!_isInitialized) await initialize();
      
      final contract = _contracts['MarketplaceCore'];
      if (contract == null) return [];
      
      final function = contract.function('getActiveItems');
      final result = await _client!.call(
        contract: contract,
        function: function,
        params: [],
      );
      
      final products = <Product>[];
      final itemIds = result[0] as List<dynamic>;
      
      for (final itemId in itemIds) {
        final product = await getProduct(itemId as BigInt);
        if (product != null) {
          products.add(product);
        }
      }
      
      return products;
    } catch (e) {
      print('❌ Error obteniendo productos activos: $e');
      return [];
    }
  }
  
  /// Obtiene transacciones por estado
  static Future<List<Transaction>> getTransactionsByStatus(TransactionStatus status) async {
    try {
      if (!_isInitialized) await initialize();
      
      final contract = _contracts['MarketplaceCore'];
      if (contract == null) return [];
      
      final function = contract.function('getTransactionsByStatus');
      final result = await _client!.call(
        contract: contract,
        function: function,
        params: [BigInt.from(status.value)],
      );
      
      final transactions = <Transaction>[];
      final transactionIds = result[0] as List<dynamic>;
      
      for (final txId in transactionIds) {
        final transaction = await getTransactionDetails(txId as BigInt);
        if (transaction != null) {
          transactions.add(transaction);
        }
      }
      
      return transactions;
    } catch (e) {
      print('❌ Error obteniendo transacciones por estado: $e');
      return [];
    }
  }
  
  /// Obtiene detalles de una transacción
  static Future<Transaction?> getTransactionDetails(BigInt transactionId) async {
    try {
      if (!_isInitialized) await initialize();
      
      final contract = _contracts['MarketplaceCore'];
      if (contract == null) return null;
      
      final function = contract.function('getTransactionDetails');
      final result = await _client!.call(
        contract: contract,
        function: function,
        params: [transactionId],
      );
      
      if (result.isNotEmpty && result[0] != BigInt.zero) {
        return Transaction.fromContractData(result);
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo detalles de transacción: $e');
      return null;
    }
  }
  
  // FUNCIONES DE REFERIDOS
  
  /// Crea un código de referido
  static Future<String> createReferralCode({
    required String code,
    required Duration validity,
    required int maxUsage,
  }) async {
    try {
      if (!_isInitialized) await initialize();
      
      final contract = _contracts['ReferralSystem'];
      if (contract == null) throw Exception('ReferralSystem no disponible');
      
      final validityPeriod = BigInt.from(validity.inSeconds);
      final maxUsageBig = BigInt.from(maxUsage);
      
      final txHash = await _sendTransaction(
        contract: contract,
        functionName: 'createReferralCode',
        parameters: [code, validityPeriod, maxUsageBig],
        gasLimit: ContractConfig.gasLimits['createReferralCode']!,
      );
      
      print('✅ Código de referido creado, TX: $txHash');
      return txHash;
    } catch (e) {
      print('❌ Error creando código de referido: $e');
      rethrow;
    }
  }
  
  /// Registra un referido con código
  static Future<String> registerReferralWithCode(String code) async {
    try {
      if (!_isInitialized) await initialize();
      
      final contract = _contracts['ReferralSystem'];
      if (contract == null) throw Exception('ReferralSystem no disponible');
      
      final address = ReownService.connectedAddress;
      if (address == null) throw Exception('Wallet no conectada');
      
      final txHash = await _sendTransaction(
        contract: contract,
        functionName: 'registerReferralWithCode',
        parameters: [code, EthereumAddress.fromHex(address)],
        gasLimit: ContractConfig.gasLimits['registerReferral']!,
      );
      
      print('✅ Referido registrado, TX: $txHash');
      return txHash;
    } catch (e) {
      print('❌ Error registrando referido: $e');
      rethrow;
    }
  }
  
  /// Verifica si un código de referido es válido
  static Future<bool> isReferralCodeValid(String code) async {
    try {
      if (!_isInitialized) await initialize();
      
      final contract = _contracts['ReferralSystem'];
      if (contract == null) return false;
      
      final function = contract.function('isReferralCodeValid');
      final result = await _client!.call(
        contract: contract,
        function: function,
        params: [code],
      );
      
      return result[0] as bool;
    } catch (e) {
      print('❌ Error verificando código de referido: $e');
      return false;
    }
  }
  
  // FUNCIONES DEL TOKEN NATIVO
  
  /// Obtiene el balance de tokens de una dirección
  static Future<BigInt> getTokenBalance(String address) async {
    try {
      if (!_isInitialized) await initialize();
      
      final contract = _contracts['NativeToken'];
      if (contract == null) return BigInt.zero;
      
      final function = contract.function('balanceOf');
      final result = await _client!.call(
        contract: contract,
        function: function,
        params: [EthereumAddress.fromHex(address)],
      );
      
      return result[0] as BigInt;
    } catch (e) {
      print('❌ Error obteniendo balance de tokens: $e');
      return BigInt.zero;
    }
  }
  
  /// Transfiere tokens
  static Future<String> transferTokens({
    required String to,
    required BigInt amount,
  }) async {
    try {
      if (!_isInitialized) await initialize();
      
      final contract = _contracts['NativeToken'];
      if (contract == null) throw Exception('NativeToken no disponible');
      
      final txHash = await _sendTransaction(
        contract: contract,
        functionName: 'transfer',
        parameters: [EthereumAddress.fromHex(to), amount],
        gasLimit: ContractConfig.gasLimits['transfer']!,
      );
      
      print('✅ Tokens transferidos, TX: $txHash');
      return txHash;
    } catch (e) {
      print('❌ Error transfiriendo tokens: $e');
      rethrow;
    }
  }
  
  /// Función auxiliar para enviar transacciones via Reown
  static Future<String> _sendTransaction({
    required DeployedContract contract,
    required String functionName,
    required List<dynamic> parameters,
    required int gasLimit,
  }) async {
    if (!ReownService.isConnected) {
      throw Exception('Wallet no conectada');
    }
    
    // Aquí necesitarías implementar la lógica específica para enviar
    // transacciones via Reown/WalletConnect
    // Por ahora, simulamos con un hash de transacción
    await Future.delayed(const Duration(seconds: 2));
    
    final mockTxHash = '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}';
    return mockTxHash;
  }
  
  /// Obtiene el balance ETH de una dirección
  static Future<BigInt> getEthBalance(String address) async {
    try {
      if (!_isInitialized) await initialize();
      
      final balance = await _client!.getBalance(EthereumAddress.fromHex(address));
      return balance.getInWei;
    } catch (e) {
      print('❌ Error obteniendo balance ETH: $e');
      return BigInt.zero;
    }
  }
  
  /// Limpia recursos
  static void dispose() {
    _client?.dispose();
    _contracts.clear();
    _isInitialized = false;
  }
}
