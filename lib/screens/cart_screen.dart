import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../models/cart.dart';
import '../services/reown_service.dart'; // Your wallet service

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double getTotal() {
    double total = 0;
    for (var p in cart) {
      total += p.price;
    }
    return total;
  }

  void _removeFromCart(int index) {
    setState(() {
      cart.removeAt(index);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Product removed from cart")));
  }

  Future<void> _simulatePayment() async {
    try {
      // Initialize wallet if not already initialized
      if (!ReownService.isInitialized) {
        await ReownService.init(context);
      }

      // Open wallet connection modal
      await ReownService.openModal(context);

      // If connected, simulate payment
      if (ReownService.isConnected) {
        final address = ReownService.connectedAddress ?? 'Unknown';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "✅ Simulated payment completed with wallet: $address\nAmount: \$${getTotal().toStringAsFixed(2)}",
            ),
            duration: const Duration(seconds: 3),
          ),
        );

        // Clear cart after simulated payment
        setState(() {
          cart.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("❌ Wallet not connected. Payment canceled."),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Error simulating payment: $e"),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: cart.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final product = cart[index];
                      return ListTile(
                        leading: Image.asset(product.imageUrl, width: 50),
                        title: Text(product.title),
                        subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeFromCart(index),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Total: \$${getTotal().toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _simulatePayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text("Proceed to Payment"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
