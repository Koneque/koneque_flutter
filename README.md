# 🚀 Koneque Flutter - Marketplace Descentralizado

Aplicación móvil de marketplace descentralizado construida con Flutter, integrada con contratos inteligentes de Koneque desplegados en Base Sepolia.

## 📋 Características Implementadas

### 🔐 Integración Web3
- **Reown (WalletConnect)**: Conexión de wallets descentralizadas
- **Base Sepolia**: Red de pruebas compatible con Ethereum
- **Smart Contracts**: Integración completa con el ecosistema Koneque

### 🏪 Funcionalidades del Marketplace
- **Listado de Productos**: Crear y gestionar productos con metadatos IPFS
- **Compra Segura**: Sistema de escrow para transacciones seguras
- **Estados de Transacción**: Seguimiento completo del flujo de compra
- **Sistema de Referidos**: Códigos de referido con recompensas

### 📱 Funcionalidades de la App
- **Gestión de Estado**: Provider pattern para manejo de estado
- **Interfaz Intuitiva**: UI/UX optimizada para dispositivos móviles
- **Carga de Imágenes**: Integración con Pinata para almacenamiento IPFS
- **Notificaciones**: Feedback en tiempo real de transacciones

## 🛠️ Configuración del Proyecto

### Prerrequisitos
- Flutter SDK (>=3.9.0)
- Dart SDK
- Android Studio / VS Code
- Wallet compatible (MetaMask, Trust Wallet, etc.)

### Instalación

1. **Clonar el repositorio**
```bash
git clone <repository-url>
cd koneque_flutter
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar Project ID de Reown**

Obtén un Project ID gratuito en [dashboard.reown.com](https://dashboard.reown.com/):

```bash
# Ejecutar con Project ID
flutter run --dart-define=PROJECT_ID=tu_project_id_aqui
```

O configura en tu IDE:
- **VS Code**: Agregar en `.vscode/launch.json`
- **Android Studio**: Run Configuration → Additional args

4. **Ejecutar la aplicación**
```bash
flutter run
```

## 🔧 Configuración de Contratos

### Direcciones en Base Sepolia

La aplicación está preconfigurada con las siguientes direcciones de contratos:

```dart
// lib/models/contract_config.dart
static const Map<String, String> contractAddresses = {
  'MARKETPLACE_CORE': '0x7fe5708061E76C271a1A9466f73D7667ed0C7Ddd',
  'NATIVE_TOKEN': '0x697943EF354BFc7c12169D5303cbbB23b133dc53',
  'REFERRAL_SYSTEM': '0x747EEC46f064763726603c9C5fC928f99926a209',
  'ESCROW': '0x8bbDDc3fcb74CdDB7050552b4DE01415C9966133',
  // ... más contratos
};
```

### Configuración de Pinata IPFS

Los metadatos se almacenan en IPFS usando Pinata:

```dart
// Configuración incluida en contract_config.dart
static const Map<String, String> pinataConfig = {
  'API_KEY': '435b6bf038c1fc6dded9',
  'JWT': 'eyJhbGciOiJIUzI1NiIs...',
  // Configuración completa incluida
};
```

## 📱 Uso de la Aplicación

### 1. Conexión de Wallet

1. **Abrir la aplicación**
2. **Tocar "Conectar Wallet Web3"**
3. **Seleccionar tu wallet preferida** (MetaMask, Trust Wallet, etc.)
4. **Aprobar la conexión** en tu wallet

### 2. Explorar el Marketplace

- **Ver productos disponibles** en la lista principal
- **Filtrar por categorías** y estados
- **Ver detalles** tocando cualquier producto

### 3. Comprar Productos

1. **Seleccionar un producto**
2. **Tocar "Comprar"**
3. **Confirmar la transacción** en tu wallet
4. **Seguir el estado** en "Mis Transacciones"

### 4. Vender Productos

1. **Tocar el botón "+"** (FAB)
2. **Llenar información del producto**
3. **Subir imágenes** (se almacenan en IPFS)
4. **Confirmar listado** en tu wallet

### 5. Sistema de Referidos

1. **Crear código de referido**: Botón "Crear Código Referido"
2. **Compartir tu código** con amigos
3. **Usar código de otro**: Botón "Usar Código"
4. **Ganar recompensas** por referidos exitosos

## 🏗️ Arquitectura del Proyecto

```
lib/
├── models/                 # Modelos de datos
│   ├── contract_config.dart    # Configuración de contratos
│   ├── product.dart           # Modelo de productos
│   └── transaction.dart       # Modelo de transacciones
├── services/              # Servicios y lógica de negocio
│   ├── reown_service.dart     # Integración con Reown/WalletConnect
│   ├── contract_service.dart  # Interacción con smart contracts
│   ├── pinata_service.dart    # Almacenamiento IPFS
│   └── koneque_provider.dart  # Gestión de estado global
├── screens/               # Pantallas de la aplicación
│   ├── login_screen.dart      # Pantalla de inicio/conexión
│   └── marketplace_screen.dart # Pantalla principal del marketplace
├── widgets/               # Componentes reutilizables
├── theme/                 # Configuración de temas
└── main.dart             # Punto de entrada de la aplicación
```

## 🔗 Integración con Smart Contracts

### Funciones Principales Implementadas

#### MarketplaceCore
- `listItem()`: Listar nuevo producto
- `buyItem()`: Comprar producto
- `confirmDelivery()`: Confirmar entrega
- `finalizeTransaction()`: Finalizar transacción
- `getActiveProducts()`: Obtener productos activos

#### ReferralSystem
- `createReferralCode()`: Crear código de referido
- `registerReferralWithCode()`: Registrar con código
- `isReferralCodeValid()`: Validar código

#### NativeToken (KNQ)
- `balanceOf()`: Consultar balance
- `transfer()`: Transferir tokens

### Estados de Transacciones

```dart
enum TransactionStatus {
  paymentCompleted(0),    // Pago completado
  productDelivered(1),    // Producto entregado
  finalized(2),          // Finalizado
  inDispute(3),          // En disputa
  refunded(4),           // Reembolsado
}
```

## 🧪 Testing y Desarrollo

### Red de Pruebas
- **Red**: Base Sepolia (Chain ID: 84532)
- **RPC**: https://sepolia.base.org
- **Explorer**: https://sepolia.basescan.org
- **Faucet**: [Base Sepolia Faucet](https://portal.cdp.coinbase.com/products/faucet)

### Obtener Tokens de Prueba
1. **ETH para gas**: Usar el faucet de Base Sepolia
2. **Tokens KNQ**: Interactuar con el contrato NativeToken

### Debug y Logs
```bash
# Ejecutar con logs detallados
flutter run --verbose

# Logs específicos de Web3
flutter logs | grep -E "(Web3|Contract|Reown)"
```

## 🚀 Despliegue

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build para iOS
flutter build ios --release
```

## 📚 Recursos Adicionales

### Documentación
- [Documentación de Contratos](../koneque-contracts/README.md)
- [Guía de Smart Accounts](../koneque-contracts/SMART_ACCOUNT_GUIDE.md)
- [Integración Frontend](../koneque-contracts/FRONTEND_INTEGRATION_GUIDE.md)

### Enlaces Útiles
- [Reown Documentation](https://docs.reown.com/appkit/flutter/)
- [Base Network](https://base.org/)
- [Pinata IPFS](https://pinata.cloud/)
- [Flutter Web3](https://pub.dev/packages/web3dart)

## 🤝 Contribución

1. Fork el proyecto
2. Crear rama de feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -m 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abrir Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 🆘 Soporte

Si tienes problemas:

1. **Revisa los logs** de la aplicación
2. **Verifica la conexión** a internet y wallet
3. **Confirma que tengas ETH** para gas en Base Sepolia
4. **Consulta la documentación** de contratos
5. **Abre un issue** en el repositorio

---

**Estado del Proyecto**: ✅ Funcional con todas las características implementadas
**Última Actualización**: 31 de agosto de 2025
**Versión**: 1.0.0
