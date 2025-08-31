import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart.dart';
import '../theme/colors.dart'; // tu archivo de colores
import 'cart_screen.dart';
import 'ChatDetailScreen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController _couponController = TextEditingController();
  double? _discountedPrice;
  String? _appliedCoupon;

  void _applyCoupon() {
    final code = _couponController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor ingresa un código de cupón")),
      );
      return;
    }

    if (code.toUpperCase() == "DESCUENTO10") {
      setState(() {
        _appliedCoupon = code;
        _discountedPrice = widget.product.price * 0.9;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cupón aplicado: 10% de descuento")),
      );
    } else {
      setState(() {
        _appliedCoupon = null;
        _discountedPrice = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cupón inválido")));
    }
  }

  void _addToCart() {
    cart.add(
      ProductModel(
        id: widget.product.id,
        title: widget.product.title,
        description: widget.product.description,
        imageUrl: widget.product.imageUrl,
        price: _discountedPrice ?? widget.product.price,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${widget.product.title} agregado al carrito")),
    );
  }

  void _goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  Widget _buildReview(String user, String comment, int stars) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: secondaryColor,
          child: Text(user[0]),
        ),
        title: Text(user),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(comment),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _goToCart,
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: product.id,
              child: Image.asset(
                product.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Text(
              "\$${(_discountedPrice ?? product.price).toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    decoration: InputDecoration(
                      hintText: "Código de cupón",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _applyCoupon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Aplicar"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _addToCart,
              icon: const Icon(Icons.shopping_cart),
              label: const Text("Agregar al carrito"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 32),

            // Simulación de reseñas de usuarios
            const Text(
              "Reseñas de usuarios (simulado)",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            _buildReview("Juan", "Excelente calidad, muy recomendado!", 5),
            _buildReview("María", "Buena relación calidad-precio.", 4),
            _buildReview("Carlos", "El envío fue rápido.", 5),
          ],
        ),
      ),
    );
  }
}
