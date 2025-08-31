import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../models/cart.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  const PaymentScreen({super.key, required this.total});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedMethod;

  void _pay() {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona un método de pago")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Pago de \$${widget.total.toStringAsFixed(2)} realizado con $_selectedMethod",
        ),
      ),
    );
    cart.clear();
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pagar"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Selecciona método de pago",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: const Text("Wallet XYZ"),
              value: "Wallet XYZ",
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val),
            ),
            RadioListTile<String>(
              title: const Text("Tarjeta de crédito"),
              value: "Tarjeta de crédito",
              groupValue: _selectedMethod,
              onChanged: (val) => setState(() => _selectedMethod = val),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _pay,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Pagar ahora"),
            ),
          ],
        ),
      ),
    );
  }
}
