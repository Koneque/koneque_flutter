import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';

class ReownService {
  static ReownAppKitModal? _appKitModal;
  static bool _isInitialized = false;

  // Project ID actualizado de Reown
  static const String _projectId = '28998a7c84b37840a2ecf7cce33da228';
  
  // Configuración de metadata para la aplicación
  static const PairingMetadata _metadata = PairingMetadata(
    name: 'Koneque Marketplace',
    description: 'Decentralized marketplace for buying and selling products',
    url: 'https://koneque.com',
    icons: [
      'https://koneque.com/icon.png'
    ],
    redirect: Redirect(
      native: 'koneque://',
      universal: 'https://koneque.com/app',
    ),
  );

  // Wallets que queremos destacar
  static const Set<String> _featuredWallets = {
    'c57ca95b47569778a828d19178114f4db188b89b763c899ba0be274e97267d96', // MetaMask
    '4622a2b2d6af1c9844944291e5e7351a6aa24cd7b23099efac1b2fd875da31a0', // Trust Wallet
    'fd20dc426fb37566d803205b19bbc1d4096b248ac04548e3cfb6b3a38bd033aa', // Coinbase Wallet
  };

  /// Inicializa el servicio ReownAppKit
  static Future<void> init(BuildContext context) async {
    if (_isInitialized) {
      if (kDebugMode) {
        print('⚠️ ReownService ya está inicializado');
      }
      return;
    }

    try {
      if (kDebugMode) {
        print('🚀 Inicializando ReownService...');
        print('📱 Project ID: ${_projectId.substring(0, 8)}...');
      }

      _appKitModal = ReownAppKitModal(
        context: context,
        projectId: _projectId,
        metadata: _metadata,
        logLevel: kDebugMode ? LogLevel.all : LogLevel.error,
        featuredWalletIds: _featuredWallets,
      );

      await _appKitModal!.init();
      _isInitialized = true;
      
      if (kDebugMode) {
        print('✅ ReownService inicializado exitosamente');
        print('🔗 Modal listo: ${_appKitModal != null}');
        print('📦 Sesión existente: ${_appKitModal?.session != null}');
      }
      
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error inicializando ReownService: $e');
        print('🔍 Project ID: $_projectId');
        print('🔍 Context disponible: ${context.mounted}');
      }
      rethrow;
    }
  }

  /// Obtiene la instancia del modal
  static ReownAppKitModal? get appKitModal => _appKitModal;

  /// Verifica si el servicio está inicializado
  static bool get isInitialized => _isInitialized;

  /// Abre el modal de conexión de wallet
  static Future<void> openModal(BuildContext context) async {
    if (!_isInitialized) {
      throw Exception('ReownService not initialized. Call init() first.');
    }
    
    try {
      if (kDebugMode) {
        print('🔗 Abriendo modal de conexión...');
        print('📱 Modal disponible: ${_appKitModal != null}');
        print('🔌 Ya conectado: ${isConnected}');
        if (isConnected) {
          print('📍 Dirección actual: $connectedAddress');
        }
      }

      // Abrir el modal con timeout
      await _appKitModal?.openModalView().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          if (kDebugMode) {
            print('⏰ Timeout al abrir modal de wallet');
          }
          throw Exception('Timeout al conectar con la wallet. Intenta nuevamente.');
        },
      );

      if (kDebugMode) {
        print('✅ Modal de conexión abierto exitosamente');
      }

    } catch (e) {
      if (kDebugMode) {
        print('❌ Error abriendo modal: $e');
      }
      rethrow;
    }
  }

  /// Obtiene la sesión actual
  static ReownAppKitModalSession? get currentSession => _appKitModal?.session;

  /// Verifica si la wallet está conectada
  static bool get isConnected => _appKitModal?.isConnected ?? false;

  /// Obtiene la dirección de la wallet conectada
  static String? get connectedAddress {
    if (!isConnected || _appKitModal?.session == null) return null;
    
    try {
      // Obtener el namespace correcto para EVM
      final chainId = _appKitModal?.selectedChain?.chainId ?? '';
      final namespace = 'eip155:$chainId';
      
      // Obtener la dirección del namespace
      return _appKitModal!.session!.getAddress(namespace);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error obteniendo dirección: $e');
      }
      return null;
    }
  }

  /// Obtiene la red actual
  static ReownAppKitModalNetworkInfo? get currentNetwork => _appKitModal?.selectedChain;

  /// Desconecta la wallet
  static Future<void> disconnect() async {
    try {
      if (kDebugMode) {
        print('🔌 Desconectando wallet...');
      }
      await _appKitModal?.disconnect();
      if (kDebugMode) {
        print('✅ Wallet desconectada exitosamente');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error desconectando wallet: $e');
      }
      rethrow;
    }
  }

  /// Configura listener para conexión de sesión
  static void onSessionConnect(Function(ModalConnect?) callback) {
    _appKitModal?.onModalConnect.subscribe(callback);
  }

  /// Configura listener para desconexión de sesión
  static void onSessionDisconnect(Function(ModalDisconnect?) callback) {
    _appKitModal?.onModalDisconnect.subscribe(callback);
  }

  /// Configura listener para cambio de red
  static void onNetworkChanged(Function(ModalNetworkChange?) callback) {
    _appKitModal?.onModalNetworkChange.subscribe(callback);
  }

  /// Limpia recursos
  static void dispose() {
    _appKitModal?.dispose();
    _appKitModal = null;
    _isInitialized = false;
    if (kDebugMode) {
      print('🧹 ReownService disposed');
    }
  }
}
