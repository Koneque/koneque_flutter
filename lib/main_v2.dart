import 'package:flutter/material.dart';
import 'screens/login_screen_v2.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KonequeAppV2());
}

class KonequeAppV2 extends StatelessWidget {
  const KonequeAppV2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koneque Marketplace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreenV2(),
    );
  }
}
