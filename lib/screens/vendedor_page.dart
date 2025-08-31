import 'package:flutter/material.dart';
import '../theme/colors.dart'; // Import your color palette
import 'vendedor_disputa.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SellerPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: textColor),
          bodyMedium: TextStyle(color: subtitleTextColor),
        ),
      ),
    );
  }
}

class SellerPage extends StatefulWidget {
  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  String selectedProduct = '📱 Phone 3';
  String selectedPrice = '\$700 USD';

  final List<Map<String, String>> products = [
    {'name': '📱 Phone 3', 'price': '\$700 USD'},
    {'name': '🎒 Backpack', 'price': '\$50 USD'},
    {'name': '⌚ Watch', 'price': '\$120 USD'},
    {'name': '💻 Tablet', 'price': '\$450 USD'},
  ];

  // Timeline steps
  final List<String> timelineSteps = [
    'Payment made',
    'Product delivered',
    'Completed',
  ];

  int currentStep = 1; // Example: the order has been delivered

  void selectProduct(Map<String, String> product) {
    setState(() {
      selectedProduct = product['name']!;
      selectedPrice = product['price']!;
    });
  }

  Widget buildTimeline() {
    List<Widget> children = [];
    for (int i = 0; i < timelineSteps.length; i++) {
      bool isCompleted = i <= currentStep;
      children.add(
        Column(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: isCompleted ? primaryColor : secondaryColor,
              child: Icon(
                isCompleted ? Icons.check : Icons.circle_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
            SizedBox(height: 6),
            Text(
              timelineSteps[i],
              style: TextStyle(
                color: textColor,
                fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
      if (i != timelineSteps.length - 1) {
        children.add(
          Expanded(
            child: Container(
              height: 4,
              color: i < currentStep
                  ? primaryColor
                  : secondaryColor.withOpacity(0.5),
            ),
          ),
        );
      }
    }
    return Row(
      children: children,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🛍️ Seller Store'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Horizontal product list
            Container(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                separatorBuilder: (_, __) => SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => selectProduct(product),
                    child: Text(
                      product['name']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Product image placeholder
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '📸 Image of $selectedProduct',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Product details
            Text(
              selectedProduct,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              selectedPrice,
              style: TextStyle(
                fontSize: 20,
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            // Timeline
            buildTimeline(),
            SizedBox(height: 16),
            // Buttons
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              icon: Icon(Icons.check),
              label: Text('Mark as Completed', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SellerDisputeScreen(),
                  ),
                );
              },
              icon: Icon(Icons.report_problem),
              label: Text(
                'Review Dispute',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
