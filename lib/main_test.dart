import 'package:flutter/material.dart';
import 'screens/test_wallet_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TestWalletApp());
}

class TestWalletApp extends StatelessWidget {
  const TestWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Wallet Connection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TestWalletScreen(),
    );
  }
}
