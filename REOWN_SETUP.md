# Integración de Reown AppKit en Koneque

Esta guía explica cómo integrar Reown AppKit como wallet provider en la aplicación Koneque Flutter.

## ✅ Estado Actual

### Lo que ya está configurado:

1. **Dependencias instaladas**: `reown_appkit: ^1.6.0` agregado al `pubspec.yaml`
2. **Configuración iOS**: 
   - Podfile creado con `platform :ios, '13.0'`
   - Info.plist configurado con schemes de wallets populares
3. **Configuración Android**: 
   - AndroidManifest.xml configurado para detección de wallets
4. **Estructura de servicios**: Archivo base `reown_service.dart` creado
5. **Deep Link Handler**: Configurado para soporte de Phantom y Solflare wallets
6. **UI preparada**: Login screen con botón de conectar wallet

## 🔧 Pasos Pendientes

### 1. Obtener Project ID de Reown

1. Ve a [Reown Cloud](https://cloud.reown.com/)
2. Crea una cuenta y un nuevo proyecto
3. Copia tu Project ID
4. Edita `lib/services/reown_service.dart` y reemplaza:
   ```dart
   static const String _projectId = 'YOUR_PROJECT_ID_HERE';
   ```
   por:
   ```dart
   static const String _projectId = 'tu_project_id_aqui';
   ```

### 2. Configurar la API correcta (en progreso)

La implementación actual en `reown_service.dart` necesita ajustes para usar la API correcta de Reown AppKit v1.6.0. Los ejemplos oficiales muestran:

```dart
_appKitModal = ReownAppKitModal(
  context: context,  // Required parameter
  projectId: 'your_project_id',
  metadata: metadata,
);
```

### 3. Finalizar configuración nativa

#### iOS:
- Instalar pods: `cd ios && pod install`
- Configurar AppDelegate.swift para deep links (opcional para Phantom/Solflare)

#### Android:
- Configurar MainActivity.kt para deep links (opcional para Phantom/Solflare)

### 4. Habilitar integración en la UI

Una vez que el servicio esté funcionando, descomentar las líneas en:
- `lib/main.dart`: Inicialización del servicio
- `lib/screens/login_screen.dart`: Funcionalidad del botón de conectar wallet

## 📚 Recursos

- [Documentación oficial de Reown AppKit Flutter](https://docs.reown.com/appkit/flutter/core/installation)
- [Ejemplos en GitHub](https://github.com/reown-com/reown_flutter/tree/master/packages/reown_appkit/example)
- [Reown Cloud](https://cloud.reown.com/) - Para obtener Project ID

## 🎯 Características Soportadas

### Wallets Compatible (una vez configurado):
- **EVM**: MetaMask, Trust Wallet, Coinbase Wallet, Rainbow, Safe, Zerion, Ledger Live
- **Solana**: Phantom Wallet, Solflare Wallet (requiere configuración adicional de deep links)

### Redes Soportadas por Defecto:
- Ethereum Mainnet
- Polygon 
- Arbitrum
- Optimism
- Base
- Y muchas más...

### Funcionalidades:
- ✅ Conexión de wallets
- ✅ Cambio de redes
- ✅ Firma de transacciones
- ✅ Firma de mensajes
- ✅ Detección de wallets instaladas
- ✅ Soporte para wallets embebidas
- ✅ Login con email (opcional)

## 🔍 Testing

Para probar la integración:

1. Descarga las apps de prueba oficiales:
   - [iOS (TestFlight)](https://testflight.apple.com/join/6aRJSllc)
   - [Android (Firebase)](https://appdistribution.firebase.dev/i/52c9b87bbf5fbe01)

2. Ejecuta tu app con:
   ```bash
   flutter run --dart-define=PROJECT_ID=tu_project_id
   ```

## ⚠️ Notas Importantes

1. **Project ID**: Es obligatorio para que funcione
2. **Contexto**: Reown AppKit requiere un BuildContext válido para inicializarse
3. **Permisos**: Asegúrate de que los permisos de internet estén configurados
4. **Deep Links**: Solo necesarios para Phantom y Solflare wallets

## 🐛 Troubleshooting

Si encuentras errores:

1. Verifica que tengas la versión correcta de Flutter (3.35.2+)
2. Asegúrate de que el Project ID sea válido
3. Revisa que todas las dependencias estén instaladas (`flutter pub get`)
4. Para iOS, ejecuta `pod install` en la carpeta `ios/`

## 📞 Soporte

- [Discord de Reown](https://discord.gg/reown)
- [GitHub Issues](https://github.com/reown-com/reown_flutter/issues)
- [Documentación](https://docs.reown.com/)
