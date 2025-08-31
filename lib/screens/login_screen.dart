import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import '/theme/colors.dart';
import '../services/reown_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _setupWalletListeners();
  }

  void _setupWalletListeners() {
    // Escuchar cuando se conecte una wallet
    ReownService.onSessionConnect((session) {
      if (session != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wallet conectada'),
            backgroundColor: Colors.green,
          ),
        );
        // Navegar automáticamente al home cuando se conecte la wallet
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  Future<void> _connectWallet() async {
    setState(() {
      _isConnecting = true;
    });

    try {
      // Abrir el modal de conexión de Reown
      await ReownService.openModal(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al conectar wallet: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner superior con gradiente y logo
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: const Center(
                    child:
                        Icon(Icons.storefront, size: 60, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Título
            const Text(
              "Bienvenido a Koneque",
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 30),

            // Formulario
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Botón de conectar wallet (Web3)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: _isConnecting ? null : _connectWallet,
                      icon: _isConnecting 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.account_balance_wallet),
                      label: Text(_isConnecting ? "Conectando..." : "Conectar Wallet"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shadowColor: accentColor.withOpacity(0.5),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade400)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "O continúa con email",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade400)),
                    ],
                  ),
                  
                  const SizedBox(height: 30),

                  // Email
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Correo electrónico",
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password
                  TextFormField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Contraseña",
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Login Button con sombra y gradiente
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white, // Texto blanco
                        elevation: 5,
                        shadowColor: primaryColor.withOpacity(0.5),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child: const Text("Iniciar sesión"),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Opción de registro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("¿No tienes cuenta? "),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterScreen()),
                          );
                        },
                        child: Text(
                          "Regístrate",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Mostrar información de wallet si está conectada (TODO: implementar con Reown)
                  // if (ReownService.isConnected) ...[
                  //   Container(
                  //     padding: const EdgeInsets.all(16),
                  //     decoration: BoxDecoration(
                  //       color: Colors.green.shade50,
                  //       borderRadius: BorderRadius.circular(12),
                  //       border: Border.all(color: Colors.green.shade200),
                  //     ),
                  //     child: Column(
                  //       children: [
                  //         const Icon(Icons.check_circle, color: Colors.green, size: 32),
                  //         const SizedBox(height: 8),
                  //         const Text(
                  //           "Wallet Conectada",
                  //           style: TextStyle(fontWeight: FontWeight.bold),
                  //         ),
                  //         const SizedBox(height: 4),
                  //         Text(
                  //           'Dirección de wallet',
                  //           style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   const SizedBox(height: 20),
                  // ],

                  // Botones sociales (opcional)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _socialButton(Icons.facebook, Colors.blue.shade800),
                      _socialButton(Icons.g_mobiledata, Colors.red),
                      _socialButton(Icons.apple, Colors.black),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      padding: const EdgeInsets.all(14),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
}
