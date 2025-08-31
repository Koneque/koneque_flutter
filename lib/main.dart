import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/reown_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const InitializationWrapper(),
    );
  }
}

/// Widget wrapper que inicializa Reown Service con BuildContext
class InitializationWrapper extends StatefulWidget {
  const InitializationWrapper({super.key});

  @override
  State<InitializationWrapper> createState() => _InitializationWrapperState();
}

class _InitializationWrapperState extends State<InitializationWrapper> {
  bool _isInitializing = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      // Inicializar Reown AppKit con BuildContext
      await ReownService.init(context);
      print('✅ Reown AppKit initialized successfully');
    } catch (e) {
      print('❌ Error initializing Reown AppKit: $e');
      setState(() {
        _errorMessage = e.toString();
      });
    }
    
    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Inicializando Koneque...'),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Project ID requerido',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pasos para configurar:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text('1. Ve a dashboard.reown.com'),
                const Text('2. Crea una cuenta gratuita'),
                const Text('3. Crea un proyecto nuevo'),
                const Text('4. Copia tu Project ID'),
                const SizedBox(height: 16),
                const Text(
                  'Luego ejecuta:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'flutter run --dart-define=PROJECT_ID=tu_project_id',
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Continuar sin wallet por ahora
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text('Continuar sin Wallet (por ahora)'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const LoginScreen();
  }
}
