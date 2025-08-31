# 🛒 Koneque Marketplace - Flutter E-Commerce App

## 📱 Project Overview

**Koneque Marketplace** is a Flutter-based e-commerce application that provides a complete shopping experience with:

- Integrated wallet functionality
- Dispute resolution system
- Seller management tools

---

## 🚀 Features

### 🔑 Core Functionality

- **User Authentication** – Email and wallet-based login
- **Product Management** – Add, view, and manage products
- **Shopping Cart** – Add items and proceed to checkout
- **Wallet Integration** – Connect and pay using Reown wallet service
- **Chat System** – Real-time messaging between buyers and sellers
- **Order Management** – Track purchases and order status

### ⚡ Advanced Features

- **Dispute Resolution System** – Built-in jury system for product disputes
- **Seller Portal** – Complete seller management interface
- **Multi-currency Support** – USD, EUR, MXN, GBP
- **Coupon System** – Discount code functionality
- **Product Reviews** – User rating and review system

---

## 🛠️ Technical Architecture

### State Management

- `ChangeNotifier` for cart state management
- `Provider` pattern for app-wide state
- Session management for user authentication

### Data Models

```dart
// Core data structures
ProductModel - Product information
CartModel    - Shopping cart management
UserModel    - User account data
```

```
lib/
├── models/          # Data models
├── screens/         # UI screens
├── services/        # External services
├── theme/           # App styling
└── widgets/         # Reusable components
```

## 📋 Key Screens

### 🔐 Authentication Flow

- `login_screen.dart` – User login with wallet/email
- `register_screen.dart` – New user registration

### 🏠 Main Application

- `home_screen.dart` – Main product listing and navigation
- `product_detail_screen.dart` – Product details and purchasing
- `cart_screen.dart` – Shopping cart management
- `payment_screen.dart` – Checkout and payment processing

### 🛍️ Seller Management

- `vendedor_page.dart` – Seller dashboard
- `AddProductScreen.dart` – Product registration form
- `vendedor_disputa.dart` – Dispute management
- `vendedor_apelar.dart` – Appeal submission
- `vendedor_revisardisputa.dart` – Dispute review

### 💬 Communication

- `chat_inbox_screen.dart` – Message inbox
- `ChatDetailScreen.dart` – Individual chat conversations

### ⚖️ Dispute System

- `disputa_page.dart` – Jury dispute resolution interface
- `miscompras.dart` – Purchase history and dispute initiation

---

## 🎨 UI/UX Design

### 🎨 Color Scheme

- **Primary Color:** Brand primary (blue)
- **Secondary Color:** Accent color
- **Background Color:** App background
- **Text Colors:** Primary and secondary text variants

### 📐 Design Principles

- Material Design 3 guidelines
- Responsive layout design
- Consistent spacing and typography
- Intuitive navigation patterns

---

## 🔧 Installation & Setup

### 📌 Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio or VS Code
- Reown wallet service credentials

### ⚙️ Installation Steps

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure environment variables for wallet service

4. Run the application:

````bash
flutter run

# 🌍 Environment Setup

Create a `.env` file with:

```env
REOWN_API_KEY=your_api_key
REOWN_SECRET=your_secret

# 📱 Platform Support

- ✅ **Android**: Fully supported
- ✅ **iOS**: Fully supported
- ⚠️ **Web**: Partially supported
- 🧪 **Desktop**: Experimental support

---

# 🚀 Getting Started

## 👤 For Users
- Launch the application
- Connect wallet or create account
- Browse products and add to cart
- Proceed to checkout and payment

## 🛍️ For Sellers
- Access seller portal from main menu
- Register new products
- Manage inventory and orders
- Handle customer disputes

## 🛡️ For Administrators
- Access dispute resolution system
- Review jury decisions
- Monitor platform transactions

---

# 🔒 Security Features
- Wallet-based authentication
- Secure payment processing
- Encrypted chat communications
- Dispute resolution escrow system

---

# 📊 Performance Optimization
- Efficient state management
- Image optimization and caching
- Lazy loading for product lists
- Minimal rebuilds with selective notifications

---

# 🤝 Contributing

1. Fork the repository
2. Create feature branch:
   ```bash
   git checkout -b feature/amazing-feature

# 📝 License
This project is licensed under the **MIT License** – see the [LICENSE](./LICENSE) file for details.

---

# 🆘 Support
- Create an issue in GitHub repository
- Contact development team at [email protected]
- Join our Discord community

---

# 🔄 Version History
- **v1.0.0** – Initial release with core functionality
- **v1.1.0** – Added dispute resolution system
- **v1.2.0** – Wallet integration and payment processing
- **v1.3.0** – Enhanced seller management tools

---

# 📱 Screenshots
*(Add application screenshots here)*

---

# 🎯 Future Enhancements
- Advanced search and filtering
- Wishlist functionality
- Push notifications
- Multi-language support
- Advanced analytics dashboard
- Social media integration
- AR product preview
- Blockchain-based escrow system
````
