import 'contract_config.dart';

/// Modelo para representar una transacción en el marketplace
class Transaction {
  final BigInt id;
  final BigInt itemId;
  final String buyer;
  final String seller;
  final BigInt amount;
  final TransactionStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  Transaction({
    required this.id,
    required this.itemId,
    required this.buyer,
    required this.seller,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });
  
  factory Transaction.fromContractData(List<dynamic> data) {
    return Transaction(
      id: data[0] as BigInt,
      itemId: data[1] as BigInt,
      buyer: data[2] as String,
      seller: data[3] as String,
      amount: data[4] as BigInt,
      status: TransactionStatus.values
          .firstWhere((s) => s.value == (data[5] as BigInt).toInt()),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (data[6] as BigInt).toInt() * 1000,
      ),
      updatedAt: data.length > 7 && data[7] != BigInt.zero
          ? DateTime.fromMillisecondsSinceEpoch(
              (data[7] as BigInt).toInt() * 1000,
            )
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'itemId': itemId.toString(),
      'buyer': buyer,
      'seller': seller,
      'amount': amount.toString(),
      'status': status.value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: BigInt.parse(json['id']),
      itemId: BigInt.parse(json['itemId']),
      buyer: json['buyer'],
      seller: json['seller'],
      amount: BigInt.parse(json['amount']),
      status: TransactionStatus.values
          .firstWhere((s) => s.value == json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }
  
  String get statusText {
    switch (status) {
      case TransactionStatus.paymentCompleted:
        return 'Pago Completado';
      case TransactionStatus.productDelivered:
        return 'Producto Entregado';
      case TransactionStatus.finalized:
        return 'Finalizado';
      case TransactionStatus.inDispute:
        return 'En Disputa';
      case TransactionStatus.refunded:
        return 'Reembolsado';
    }
  }
}

/// Modelo para representar un código de referido
class ReferralCode {
  final String code;
  final String creator;
  final BigInt validityPeriod;
  final BigInt maxUsage;
  final BigInt currentUsage;
  final DateTime createdAt;
  final bool isActive;
  
  ReferralCode({
    required this.code,
    required this.creator,
    required this.validityPeriod,
    required this.maxUsage,
    required this.currentUsage,
    required this.createdAt,
    required this.isActive,
  });
  
  factory ReferralCode.fromContractData(List<dynamic> data) {
    return ReferralCode(
      code: data[0] as String,
      creator: data[1] as String,
      validityPeriod: data[2] as BigInt,
      maxUsage: data[3] as BigInt,
      currentUsage: data[4] as BigInt,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (data[5] as BigInt).toInt() * 1000,
      ),
      isActive: data[6] as bool,
    );
  }
  
  bool get isExpired {
    final expiryDate = createdAt.add(Duration(seconds: validityPeriod.toInt()));
    return DateTime.now().isAfter(expiryDate);
  }
  
  bool get isUsageLimitReached {
    return currentUsage >= maxUsage;
  }
  
  bool get isValid {
    return isActive && !isExpired && !isUsageLimitReached;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'creator': creator,
      'validityPeriod': validityPeriod.toString(),
      'maxUsage': maxUsage.toString(),
      'currentUsage': currentUsage.toString(),
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}

/// Modelo para información de usuario y sus cuentas inteligentes
class UserAccount {
  final String address;
  final String? smartAccountAddress;
  final BigInt balance;
  final BigInt tokenBalance;
  final List<String> smartAccounts;
  
  UserAccount({
    required this.address,
    this.smartAccountAddress,
    required this.balance,
    required this.tokenBalance,
    required this.smartAccounts,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'smartAccountAddress': smartAccountAddress,
      'balance': balance.toString(),
      'tokenBalance': tokenBalance.toString(),
      'smartAccounts': smartAccounts,
    };
  }
  
  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      address: json['address'],
      smartAccountAddress: json['smartAccountAddress'],
      balance: BigInt.parse(json['balance']),
      tokenBalance: BigInt.parse(json['tokenBalance']),
      smartAccounts: List<String>.from(json['smartAccounts'] ?? []),
    );
  }
}
