/// Modelo para representar un producto en el marketplace
class Product {
  final BigInt id;
  final String seller;
  final BigInt price;
  final String metadataURI;
  final String category;
  final bool isActive;
  final DateTime listedAt;
  
  Product({
    required this.id,
    required this.seller,
    required this.price,
    required this.metadataURI,
    required this.category,
    required this.isActive,
    required this.listedAt,
  });
  
  factory Product.fromContractData(List<dynamic> data) {
    return Product(
      id: data[0] as BigInt,
      seller: data[1] as String,
      price: data[2] as BigInt,
      metadataURI: data[3] as String,
      category: data[4] as String,
      isActive: data[5] as bool,
      listedAt: DateTime.fromMillisecondsSinceEpoch(
        (data[6] as BigInt).toInt() * 1000,
      ),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'seller': seller,
      'price': price.toString(),
      'metadataURI': metadataURI,
      'category': category,
      'isActive': isActive,
      'listedAt': listedAt.toIso8601String(),
    };
  }
  
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: BigInt.parse(json['id']),
      seller: json['seller'],
      price: BigInt.parse(json['price']),
      metadataURI: json['metadataURI'],
      category: json['category'],
      isActive: json['isActive'],
      listedAt: DateTime.parse(json['listedAt']),
    );
  }
}

/// Modelo para metadatos del producto almacenados en IPFS
class ProductMetadata {
  final String name;
  final String description;
  final List<String> images;
  final String condition;
  final String location;
  final Map<String, dynamic> attributes;
  
  ProductMetadata({
    required this.name,
    required this.description,
    required this.images,
    required this.condition,
    required this.location,
    required this.attributes,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'images': images,
      'condition': condition,
      'location': location,
      'attributes': attributes,
    };
  }
  
  factory ProductMetadata.fromJson(Map<String, dynamic> json) {
    return ProductMetadata(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      condition: json['condition'] ?? 'new',
      location: json['location'] ?? '',
      attributes: Map<String, dynamic>.from(json['attributes'] ?? {}),
    );
  }
}
