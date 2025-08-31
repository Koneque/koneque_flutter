import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'chat_inbox_screen.dart';
import 'AddProductScreen.dart';
import 'vendedor_page.dart';
import '/theme/colors.dart';
import 'miscompras.dart';
import 'disputa_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<ProductModel> dummyProducts = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          "Koneque Marketplace",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatInboxScreen()),
              );
            },
            icon: const Icon(Icons.chat, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              // TODO: search action
            },
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("My Purchases"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MisComprasScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Add Product"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddProductScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text("Seller"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SellerPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Reviews"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DisputaPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories as chips
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              children: [
                _buildCategoryChip("Technology"),
                _buildCategoryChip("Sports"),
                _buildCategoryChip("Fashion"),
                _buildCategoryChip("Accessories"),
              ],
            ),
          ),

          // Product list
          Expanded(
            child: ListView.builder(
              itemCount: dummyProducts.length,
              itemBuilder: (_, index) {
                final product = dummyProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: ProductCard(product: product),
                );
              },
            ),
          ),

          // Banner/quick entry to Seller
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SellerPage()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: secondaryColor.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.storefront, size: 28, color: primaryColor),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Seller — manage your products',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddProductScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SellerPage()),
            );
            return;
          }
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Seller"),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        backgroundColor: secondaryColor.withAlpha((0.2 * 255).round()),
        label: Text(text, style: const TextStyle(color: textColor)),
      ),
    );
  }
}
