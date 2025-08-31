import 'package:flutter/material.dart';
import '../theme/colors.dart'; // Your color palette

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SellerAppealScreen(),
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

class SellerAppealScreen extends StatefulWidget {
  @override
  State<SellerAppealScreen> createState() => _SellerAppealScreenState();
}

class _SellerAppealScreenState extends State<SellerAppealScreen> {
  String selectedProduct = '📱 Phone 3';
  String selectedPrice = '\$700 USD';

  final TextEditingController reasonController = TextEditingController();
  final TextEditingController imageDescController = TextEditingController();

  final List<Map<String, String>> products = [];

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
            // Appeal fields
            SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: 'Reason',
                hintText: 'Enter the reason for the appeal',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: imageDescController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Image description',
                hintText: 'Description of the image (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 4, 255),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final reason = reasonController.text.trim();
                final desc = imageDescController.text.trim();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Appeal - reason: ${reason.isEmpty ? '<empty>' : reason}, image desc: ${desc.isEmpty ? '<empty>' : desc}',
                    ),
                  ),
                );
              },
              icon: Icon(Icons.report_problem),
              label: Text(
                'Submit Appeal',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    reasonController.dispose();
    imageDescController.dispose();
    super.dispose();
  }
}
