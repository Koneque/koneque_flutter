import 'package:flutter/material.dart';
import '../theme/colors.dart'; // Importa tu archivo de colores
import 'vendedor_disputa.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Vendedor_revisardisputa(),
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

class Vendedor_revisardisputa extends StatefulWidget {
  @override
  State<Vendedor_revisardisputa> createState() =>
      _Vendedor_revisardisputaState();
}

class _Vendedor_revisardisputaState extends State<Vendedor_revisardisputa> {
  String selectedProduct = '📱 celu3';
  String selectedPrice = '\$700 USD';

  final List<Map<String, String>> products = [
    {'name': '📱 celu3', 'price': '\$700 USD'},
    {'name': '🎒 mochila', 'price': '\$50 USD'},
    {'name': '⌚ reloj', 'price': '\$120 USD'},
    {'name': '💻 tablet', 'price': '\$450 USD'},
  ];

  // Estados de la línea de tiempo
  final List<String> timelineSteps = [
    'Pago realizado',
    'Producto entregado',
    'en revision',
  ];

  int currentStep = 1; // ejemplo: el pedido ya fue entregado

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
        title: Text('🛍️ Tienda Vendedor'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Lista de productos horizontal
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
            // Imagen del producto
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
                    '📸 Imagen de $selectedProduct',
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
            // Detalles del producto
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
            // Línea de tiempo
            buildTimeline(),
            SizedBox(height: 16),

            // Botones
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
                  MaterialPageRoute(builder: (context) => vendedor_disputa()),
                );
              },
              icon: Icon(Icons.report_problem),
              label: Text(
                'Revisar disputa',
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
