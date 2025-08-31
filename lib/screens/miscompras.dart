import 'package:flutter/material.dart';
import '../theme/colors.dart'; // Your color palette
import '../models/product_model.dart';
import 'product_detail_screen.dart';
import 'vendedor_disputa.dart'; // To open dispute

class MisComprasScreen extends StatelessWidget {
  MisComprasScreen({super.key});

  // Simulated purchased products
  final List<ProductModel> purchasedProducts = [
    ProductModel(
      id: '1',
      title: 'Gaming Laptop X',
      description: 'Intel i7, 16GB RAM, RTX 3060',
      price: 1200,
      imageUrl: 'assets/images/laptop.jpg',
    ),
    ProductModel(
      id: '2',
      title: 'MTB Bicycle',
      description: '29" Wheels, Disc Brakes',
      price: 450,
      imageUrl: 'assets/images/bicicleta.jpg',
    ),
    ProductModel(
      id: '3',
      title: 'Bluetooth Headphones',
      description: 'Noise Cancelling, 30h Battery',
      price: 80,
      imageUrl: 'assets/images/auriculares.jpg',
    ),
    ProductModel(
      id: '4',
      title: 'Smartwatch Series 5',
      description: 'Health monitor, smart notifications',
      price: 200,
      imageUrl: 'assets/images/reloj.jpg',
    ),
    ProductModel(
      id: '5',
      title: 'Tablet 10”',
      description: 'Android, 64GB, full HD screen',
      price: 350,
      imageUrl: 'assets/images/tablet.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Purchases"),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: purchasedProducts.length,
        itemBuilder: (context, index) {
          final product = purchasedProducts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(product.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Title and description
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: subtitleTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: const Text("View Product"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SellerDisputeScreen(),
                            ),
                          );
                        },
                        child: const Text("Open Dispute"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
