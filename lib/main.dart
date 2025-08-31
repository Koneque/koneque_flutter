import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/privy_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Privy antes de arrancar la UI. Reemplaza credenciales en
  // `lib/services/privy_service.dart` si es necesario.
  await PrivyService.init();

  runApp(const KonequeApp());
}

class KonequeApp extends StatelessWidget {
  const KonequeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koneque Marketplace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}
