````markdown
# 🚀 Koneque Flutter - Decentralized Marketplace

Decentralized marketplace mobile application built with Flutter, integrated with Koneque smart contracts deployed on Base Sepolia.

## 📋 Implemented Features

### 🔐 Web3 Integration
- **Reown (WalletConnect)**: Decentralized wallet connections
- **Base Sepolia**: Ethereum-compatible test network
- **Smart Contracts**: Complete integration with Koneque ecosystem

### 🏪 Marketplace Functionalities
- **Product Listing**: Create and manage products with IPFS metadata
- **Secure Purchase**: Escrow system for secure transactions
- **Transaction States**: Complete tracking of purchase flow
- **Referral System**: Referral codes with rewards

### 📱 App Functionalities
- **State Management**: Provider pattern for state handling
- **Intuitive Interface**: UI/UX optimized for mobile devices
- **Image Upload**: Pinata integration for IPFS storage
- **Notifications**: Real-time transaction feedback

## 🛠️ Project Setup

### Prerequisites
- Flutter SDK (>=3.9.0)
- Dart SDK
- Android Studio / VS Code
- Compatible wallet (MetaMask, Trust Wallet, etc.)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd koneque_flutter
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Reown Project ID**

Get a free Project ID at [dashboard.reown.com](https://dashboard.reown.com/):

```bash
# Run with Project ID
flutter run --dart-define=PROJECT_ID=your_project_id_here
```

Or configure in your IDE:
- **VS Code**: Add to `.vscode/launch.json`
- **Android Studio**: Run Configuration → Additional args

4. **Run the application**
```bash
flutter run
```

## 🔧 Contract Configuration

### Base Sepolia Addresses

The application is preconfigured with the following contract addresses:

```dart
// lib/models/contract_config.dart
static const Map<String, String> contractAddresses = {
  'MARKETPLACE_CORE': '0x7fe5708061E76C271a1A9466f73D7667ed0C7Ddd',
  'NATIVE_TOKEN': '0x697943EF354BFc7c12169D5303cbbB23b133dc53',
  'REFERRAL_SYSTEM': '0x747EEC46f064763726603c9C5fC928f99926a209',
  'ESCROW': '0x8bbDDc3fcb74CdDB7050552b4DE01415C9966133',
  // ... more contracts
};
```

### Pinata IPFS Configuration

Metadata is stored on IPFS using Pinata:

```dart
// Configuration included in contract_config.dart
static const Map<String, String> pinataConfig = {
  'API_KEY': '435b6bf038c1fc6dded9',
  'JWT': 'eyJhbGciOiJIUzI1NiIs...',
  // Complete configuration included
};
```

## 📱 Application Usage

### 1. Wallet Connection

1. **Open the application**
2. **Tap "Connect Web3 Wallet"**
3. **Select your preferred wallet** (MetaMask, Trust Wallet, etc.)
4. **Approve the connection** in your wallet

### 2. Explore the Marketplace

- **View available products** in the main list
- **Filter by categories** and states
- **View details** by tapping any product

### 3. Buy Products

1. **Select a product**
2. **Tap "Buy"**
3. **Confirm the transaction** in your wallet
4. **Track the status** in "My Transactions"

### 4. Sell Products

1. **Tap the "+" button** (FAB)
2. **Fill product information**
3. **Upload images** (stored on IPFS)
4. **Confirm listing** in your wallet

### 5. Referral System

1. **Create referral code**: "Create Referral Code" button
2. **Share your code** with friends
3. **Use someone's code**: "Use Code" button
4. **Earn rewards** for successful referrals

## 🏗️ Project Architecture

```
lib/
├── models/                 # Data models
│   ├── contract_config.dart    # Contract configuration
│   ├── product.dart           # Product models
│   └── transaction.dart       # Transaction models
├── services/              # Services and business logic
│   ├── reown_service.dart     # Reown/WalletConnect integration
│   ├── contract_service.dart  # Smart contract interaction
│   ├── pinata_service.dart    # IPFS storage
│   └── koneque_provider.dart  # Global state management
├── screens/               # Application screens
│   ├── login_screen.dart      # Login/connection screen
│   └── marketplace_screen.dart # Main marketplace screen
├── widgets/               # Reusable components
├── theme/                 # Theme configuration
└── main.dart             # Application entry point
```

## 🔗 Smart Contract Integration

### Main Implemented Functions

#### MarketplaceCore
- `listItem()`: List new product
- `buyItem()`: Buy product
- `confirmDelivery()`: Confirm delivery
- `finalizeTransaction()`: Finalize transaction
- `getActiveProducts()`: Get active products

#### ReferralSystem
- `createReferralCode()`: Create referral code
- `registerReferralWithCode()`: Register with code
- `isReferralCodeValid()`: Validate code

#### NativeToken (KNQ)
- `balanceOf()`: Check balance
- `transfer()`: Transfer tokens

### Transaction States

```dart
enum TransactionStatus {
  paymentCompleted(0),    // Payment completed
  productDelivered(1),    // Product delivered
  finalized(2),          // Finalized
  inDispute(3),          // In dispute
  refunded(4),           // Refunded
}
```

## 🧪 Testing and Development

### Test Network
- **Network**: Base Sepolia (Chain ID: 84532)
- **RPC**: https://sepolia.base.org
- **Explorer**: https://sepolia.basescan.org
- **Faucet**: [Base Sepolia Faucet](https://portal.cdp.coinbase.com/products/faucet)

### Get Test Tokens
1. **ETH for gas**: Use Base Sepolia faucet
2. **KNQ tokens**: Interact with NativeToken contract

### Debug and Logs
```bash
# Run with detailed logs
flutter run --verbose

# Web3-specific logs
flutter logs | grep -E "(Web3|Contract|Reown)"
```

## 🚀 Deployment

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build for iOS
flutter build ios --release
```

## 📚 Additional Resources

### Documentation
- [Contract Documentation](../koneque-contracts/README.md)
- [Smart Account Guide](../koneque-contracts/SMART_ACCOUNT_GUIDE.md)
- [Frontend Integration](../koneque-contracts/FRONTEND_INTEGRATION_GUIDE.md)

### Useful Links
- [Reown Documentation](https://docs.reown.com/appkit/flutter/)
- [Base Network](https://base.org/)
- [Pinata IPFS](https://pinata.cloud/)
- [Flutter Web3](https://pub.dev/packages/web3dart)

## 🤝 Contributing

1. Fork the project
2. Create feature branch (`git checkout -b feature/new-functionality`)
3. Commit changes (`git commit -m 'Add new functionality'`)
4. Push to branch (`git push origin feature/new-functionality`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

If you have issues:

1. **Check application logs**
2. **Verify internet connection** and wallet
3. **Confirm you have ETH** for gas on Base Sepolia
4. **Consult contract documentation**
5. **Open an issue** in the repository

---

**Project Status**: ✅ Functional with all features implemented
**Last Update**: August 31, 2025
**Version**: 1.0.0

````
