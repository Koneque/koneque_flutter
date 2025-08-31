import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';

class ReownServiceV2 {
  static ReownAppKitModal? _appKitModal;
  static bool _isInitialized = false;
  static BuildContext? _context;

    // Project ID actualizado de Reown
  static const String _projectId = '28998a7c84b37840a2ecf7cce33da228';
  
  // Configuración de metadata
  static const PairingMetadata _metadata = PairingMetadata(
    name: 'Koneque Marketplace',
    description: 'Decentralized marketplace for buying and selling products',
    url: 'https://koneque.com',
    icons: ['https://koneque.com/icon.png'],
    redirect: Redirect(
      native: 'koneque://',
      universal: 'https://koneque.com/app',
    ),
  );

  /// Inicializa el servicio con context
  static Future<void> initWithContext(BuildContext context) async {
    if (_isInitialized) return;

    _context = context;

    try {
      // Configurar featured wallet IDs
      final featuredWalletIds = {
        'c57ca95b47569778a828d19178114f4db188b89b763c899ba0be274e97267d96', // MetaMask
        '4622a2b2d6af1c9844944291e5e7351a6aa24cd7b23099efac1b2fd875da31a0', // Trust Wallet
        'fd20dc426fb37566d803205b19bbc1d4096b248ac04548e3cfb6b3a38bd033aa', // Coinbase Wallet
      };

      _appKitModal = ReownAppKitModal(
        context: context,
        projectId: _projectId,
        metadata: _metadata,
        logLevel: kDebugMode ? LogLevel.all : LogLevel.error,
        featuredWalletIds: featuredWalletIds,
      );

      await _appKitModal!.init();
      _isInitialized = true;
      
      if (kDebugMode) {
        print('✅ ReownServiceV2 inicializado exitosamente con context');
        print('📱 Project ID: ${_projectId.substring(0, 8)}...');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error inicializando ReownServiceV2: $e');
      }
      rethrow;
    }
  }

  /// Conecta directamente usando el modal
  static Future<void> connectWallet() async {
    if (!_isInitialized || _appKitModal == null) {
      throw Exception('ReownServiceV2 not initialized. Call initWithContext() first.');
    }

    try {
      if (kDebugMode) {
        print('🔗 Abriendo modal de conexión...');
      }
      
      // Usar el método correcto con context
      await _appKitModal!.openModalView();
      
      // Esperar un poco para que se procese
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (kDebugMode) {
        print('✅ Modal de conexión abierto');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error abriendo modal: $e');
      }
      rethrow;
    }
  }

  /// Reinicia la conexión limpiando el estado anterior
  static Future<void> resetAndConnect() async {
    try {
      if (kDebugMode) {
        print('🔄 Reiniciando conexión...');
      }

      // Desconectar sesión anterior si existe
      if (_appKitModal != null && _appKitModal!.isConnected) {
        await _appKitModal!.disconnect();
        await Future.delayed(const Duration(milliseconds: 1000));
      }

      // Limpiar estado
      _isInitialized = false;
      _appKitModal = null;

      if (_context != null) {
        // Reinicializar con context
        await initWithContext(_context!);
        
        // Conectar nuevamente
        await connectWallet();
      } else {
        throw Exception('Context perdido, necesita reinicializar desde la UI');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en resetAndConnect: $e');
      }
      rethrow;
    }
  }

  /// Getters de estado
  static ReownAppKitModal? get appKitModal => _appKitModal;
  static bool get isInitialized => _isInitialized;
  static bool get isConnected => _appKitModal?.isConnected ?? false;
  static ReownAppKitModalSession? get currentSession => _appKitModal?.session;

  /// Obtiene la dirección de la wallet conectada
  static String? get connectedAddress {
    if (!isConnected || _appKitModal?.session == null) return null;
    
    try {
      final chainId = _appKitModal?.selectedChain?.chainId ?? '';
      if (chainId.isEmpty) return null;
      
      final namespace = NamespaceUtils.getNamespaceFromChain(chainId);
      return _appKitModal!.session!.getAddress(namespace);
    } catch (e) {
      if (kDebugMode) {
        print('Error obteniendo dirección: $e');
      }
      return null;
    }
  }

  /// Desconecta la wallet
  static Future<void> disconnect() async {
    if (_appKitModal != null) {
      await _appKitModal!.disconnect();
    }
  }

  /// Eventos
  static void onSessionConnect(Function(ModalConnect?) callback) {
    _appKitModal?.onModalConnect.subscribe(callback);
  }

  static void onSessionDisconnect(Function(ModalDisconnect?) callback) {
    _appKitModal?.onModalDisconnect.subscribe(callback);
  }

  static void onNetworkChanged(Function(ModalNetworkChange?) callback) {
    _appKitModal?.onModalNetworkChange.subscribe(callback);
  }

  /// Limpiar recursos
  static void dispose() {
    _appKitModal?.onModalConnect.unsubscribeAll();
    _appKitModal?.onModalDisconnect.unsubscribeAll();
    _appKitModal?.onModalNetworkChange.unsubscribeAll();
    _context = null;
    _isInitialized = false;
    _appKitModal = null;
  }
}
