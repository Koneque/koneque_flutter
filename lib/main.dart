import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/test_wallet_screen.dart';
import 'services/reown_service.dart';
import 'services/reown_service_v2.dart';
import 'services/koneque_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KonequeApp());
}

class KonequeApp extends StatelessWidget {
  const KonequeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => KonequeProvider(),
      child: MaterialApp(
        title: 'Koneque Marketplace',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const InitializationWrapper(),
      ),
    );
  }
}

/// Widget wrapper que inicializa todos los servicios
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
      // Inicializar Reown AppKit
      await ReownService.init(context);
      print('✅ Reown AppKit inicializado exitosamente');
      
      // Inicializar el provider de Koneque
      final provider = Provider.of<KonequeProvider>(context, listen: false);
      await provider.initialize();
      print('✅ KonequeProvider inicializado exitosamente');
      
    } catch (e) {
      print('❌ Error inicializando servicios: $e');
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
    return Consumer<KonequeProvider>(
      builder: (context, provider, child) {
        // Mostrar pantalla de carga durante inicialización
        if (_isInitializing || provider.isInitializing) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Inicializando Koneque...'),
                  SizedBox(height: 8),
                  Text(
                    'Conectando con blockchain y servicios',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        // Mostrar error si hay algún problema con la configuración
        if (_errorMessage != null && _errorMessage!.contains('Project ID')) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_outlined,
                      size: 64,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Configuración Requerida',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Para conectar wallets necesitas un Project ID de Reown:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    const Text('1. Ve a dashboard.reown.com'),
                    const Text('2. Crea una cuenta gratuita'),
                    const Text('3. Crea un proyecto nuevo'),
                    const Text('4. Copia tu Project ID'),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'flutter run --dart-define=PROJECT_ID=tu_project_id',
                        style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: const Text('Continuar sin Wallet'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Mostrar error general si hay algún problema
        if (provider.errorMessage != null) {
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
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Error de Inicialización',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            provider.clearError();
                            _initializeServices();
                          },
                          child: const Text('Reintentar'),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          child: const Text('Continuar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Todo está bien, ir a la pantalla principal
        return const LoginScreen();
      },
    );
  }
}
