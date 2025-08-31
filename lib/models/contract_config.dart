/// Configuración de contratos inteligentes para Koneque
/// Basado en la documentación de smart contracts deployados en Base Sepolia

// Estados de transacciones según la documentación
enum TransactionStatus {
  paymentCompleted(0),
  productDelivered(1),
  finalized(2),
  inDispute(3),
  refunded(4);
  
  const TransactionStatus(this.value);
  final int value;
}

class ContractConfig {
  // Red de Base Sepolia
  static const int chainId = 84532;
  static const String networkName = 'Base Sepolia';
  static const String rpcUrl = 'https://sepolia.base.org';
  static const String blockExplorer = 'https://sepolia.basescan.org';
  
  // Direcciones de contratos deployados (Base Sepolia)
  static const Map<String, String> contractAddresses = {
    'NATIVE_TOKEN': '0x697943EF354BFc7c12169D5303cbbB23b133dc53',
    'SMART_ACCOUNT_IMPL': '0xf24e12Ef8aAcB99FC5843Fc56BEA0BFA5B039BFF',
    'ACCOUNT_FACTORY': '0x422478a088ce4d9D9418d4D2C9D99c78fC23393f',
    'SMART_ACCOUNT_FACTORY': '0x030850c3DEa419bB1c76777F0C2A65c34FB60392',
    'PAYMASTER': '0x44b89ba09a381F3b598a184A90F039948913dC72',
    'ESCROW': '0x8bbDDc3fcb74CdDB7050552b4DE01415C9966133',
    'FEE_MANAGER': '0x2212FBb6C244267c23a5710E7e6c4769Ea423beE',
    'MARKETPLACE_CORE': '0x7fe5708061E76C271a1A9466f73D7667ed0C7Ddd',
    'DISPUTE_RESOLUTION': '0xD53df29C516D08e1F244Cb5912F0224Ea22B60E1',
    'ORACLE_REGISTRY': '0x3Dd8A23983b94bC208D614C4325D937b710B6E4B',
    'REFERRAL_SYSTEM': '0x747EEC46f064763726603c9C5fC928f99926a209',
  };
  
  // Configuración de Pinata para metadatos IPFS
  static const Map<String, String> pinataConfig = {
    'API_KEY': '435b6bf038c1fc6dded9',
    'API_SECRET': '9387d79cb5841d59782cf6e0adff96c6b503a0c3acf6cae957235b713661be07',
    'JWT': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySW5mb3JtYXRpb24iOnsiaWQiOiJhNDg0ZDQ2MC1iOWJmLTQ0MzMtODUxYS0zNWRiNWFiZWMyNjIiLCJlbWFpbCI6InNhdWxjaG9xdWUxMjNAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInBpbl9wb2xpY3kiOnsicmVnaW9ucyI6W3siZGVzaXJlZFJlcGxpY2F0aW9uQ291bnQiOjEsImlkIjoiRlJBMSJ9LHsiZGVzaXJlZFJlcGxpY2F0aW9uQ291bnQiOjEsImlkIjoiTllDMSJ9XSwidmVyc2lvbiI6MX0sIm1mYV9lbmFibGVkIjpmYWxzZSwic3RhdHVzIjoiQUNUSVZFIn0sImF1dGhlbnRpY2F0aW9uVHlwZSI6InNjb3BlZEtleSIsInNjb3BlZEtleUtleSI6IjQzNWI2YmYwMzhjMWZjNmRkZWQ5Iiwic2NvcGVkS2V5U2VjcmV0IjoiOTM4N2Q3OWNiNTg0MWQ1OTc4MmNmNmUwYWRmZjk2YzZiNTAzYTBjM2FjZjZjYWU5NTcyMzViNzEzNjYxYmUwNyIsImV4cCI6MTc4ODE2OTUwNH0.PUjjzPyr2j35ryT-gtqgIBd0yM6F77ui80vp4J4U84o',
    'GATEWAY_URL': 'https://gateway.pinata.cloud',
    'API_URL': 'https://api.pinata.cloud',
  };
  
  // Categorías de productos
  static const List<String> productCategories = [
    'Electronics',
    'Fashion',
    'Home & Garden',
    'Sports',
    'Books',
    'Automotive',
    'Health & Beauty',
    'Toys & Games',
    'Art & Crafts',
    'Other'
  ];
  
  // Gas limits para diferentes operaciones
  static const Map<String, int> gasLimits = {
    'listItem': 200000,
    'buyItem': 300000,
    'confirmDelivery': 150000,
    'finalizeTransaction': 200000,
    'createReferralCode': 100000,
    'registerReferral': 120000,
    'mint': 100000,
    'transfer': 80000,
  };
  
  // Configuración de fees (en basis points - 100 = 1%)
  static const Map<String, int> feeConfig = {
    'platformFee': 250, // 2.5%
    'referralReward': 100, // 1%
    'listingFee': 50, // 0.5%
  };
}
