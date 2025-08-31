import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';

class ReownService {
  static ReownAppKitModal? _appKitModal;
  static bool _isInitialized = false;

  // IMPORTANTE: Obtén tu Project ID real de Reown Dashboard
  // Obtén uno gratis en: https://dashboard.reown.com/
  static const String _projectId = String.fromEnvironment(
    'PROJECT_ID',
    defaultValue: '28998a7c84b37840a2ecf7cce33da228', // ✅ Tu Project ID real
  );
  
  // Configuración de metadata para tu aplicación
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

  /// Inicializa el servicio de Reown AppKit
  static Future<void> init(BuildContext context) async {
    if (_isInitialized) return;

    // Validar que tengamos un Project ID válido
    if (_projectId == 'YOUR_PROJECT_ID_HERE' || _projectId.isEmpty) {
      if (kDebugMode) {
        print('❌ [ReownService] Project ID no configurado.');
        print('📋 Pasos para obtener un Project ID:');
        print('   1. Ve a https://dashboard.reown.com/');
        print('   2. Crea una cuenta gratuita');
        print('   3. Crea un nuevo proyecto');
        print('   4. Copia tu Project ID');
        print('   5. Ejecuta: flutter run --dart-define=PROJECT_ID=tu_project_id_aqui');
      }
      throw Exception(
        'Project ID requerido. Ve a https://dashboard.reown.com/ para obtener uno gratuito.\n'
        'Luego ejecuta: flutter run --dart-define=PROJECT_ID=tu_project_id'
      );
    }

    try {
      // IMPORTANTE: BuildContext es requerido para ReownAppKitModal
      _appKitModal = ReownAppKitModal(
        context: context, // ✅ Añadido context requerido
        projectId: _projectId,
        metadata: _metadata,
        logLevel: kDebugMode ? LogLevel.all : LogLevel.error,
      );

      await _appKitModal!.init();
      _isInitialized = true;
      
      if (kDebugMode) {
        print('✅ Reown AppKit initialized successfully with Project ID: ${_projectId.substring(0, 8)}...');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error initializing Reown AppKit: $e');
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
    
    await _appKitModal?.openModalView();
  }

  /// Obtiene la información de la sesión conectada
  static ReownAppKitModalSession? get currentSession => _appKitModal?.session;

  /// Verifica si hay una wallet conectada
  static bool get isConnected => _appKitModal?.isConnected ?? false;

  /// Obtiene la dirección de la wallet conectada
  static String? get connectedAddress {
    if (!isConnected || _appKitModal?.session == null) return null;
    
    try {
      // Obtener la dirección según el namespace de la chain seleccionada
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

  /// Obtiene la red actual
  static ReownAppKitModalNetworkInfo? get currentNetwork => _appKitModal?.selectedChain;

  /// Desconecta la wallet
  static Future<void> disconnect() async {
    if (_appKitModal != null) {
      await _appKitModal!.disconnect();
    }
  }

  /// Suscribirse a eventos de conexión
  static void onSessionConnect(Function(ModalConnect?) callback) {
    _appKitModal?.onModalConnect.subscribe(callback);
  }

  /// Suscribirse a eventos de desconexión
  static void onSessionDisconnect(Function(ModalDisconnect?) callback) {
    _appKitModal?.onModalDisconnect.subscribe(callback);
  }

  /// Suscribirse a cambios de red
  static void onNetworkChanged(Function(ModalNetworkChange?) callback) {
    _appKitModal?.onModalNetworkChange.subscribe(callback);
  }

  /// Limpiar suscripciones
  static void dispose() {
    _appKitModal?.onModalConnect.unsubscribeAll();
    _appKitModal?.onModalDisconnect.unsubscribeAll();
    _appKitModal?.onModalNetworkChange.unsubscribeAll();
  }
}
