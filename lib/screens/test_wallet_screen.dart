import 'package:flutter/material.dart';
import '../services/reown_service_v2.dart';

/// Pantalla de prueba para ReownServiceV2
class TestWalletScreen extends StatefulWidget {
  const TestWalletScreen({super.key});

  @override
  State<TestWalletScreen> createState() => _TestWalletScreenState();
}

class _TestWalletScreenState extends State<TestWalletScreen> {
  bool _isInitialized = false;
  bool _isConnecting = false;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _initializeService();
  }
  
  Future<void> _initializeService() async {
    try {
      await ReownServiceV2.initWithContext(context);
      setState(() {
        _isInitialized = true;
        _errorMessage = null;
      });
      
      // Configurar listeners
      ReownServiceV2.onSessionConnect((connect) {
        if (mounted) {
          setState(() {
            _errorMessage = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Wallet conectada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      });
      
      ReownServiceV2.onSessionDisconnect((disconnect) {
        if (mounted) {
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🔌 Wallet desconectada'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      });
      
    } catch (e) {
      setState(() {
        _errorMessage = 'Error inicializando servicio: $e';
      });
    }
  }
  
  Future<void> _connectWallet() async {
    if (_isConnecting) return;
    
    setState(() {
      _isConnecting = true;
      _errorMessage = null;
    });
    
    try {
      await ReownServiceV2.connectWallet();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error conectando wallet: $e';
      });
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }
  
  Future<void> _disconnectWallet() async {
    try {
      await ReownServiceV2.disconnect();
      setState(() {
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error desconectando wallet: $e';
      });
    }
  }
  
  Future<void> _resetAndConnect() async {
    try {
      await ReownServiceV2.resetAndConnect();
      setState(() {
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error reseteando conexión: $e';
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Wallet Connection'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Estado del servicio
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estado del Servicio',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _isInitialized ? Icons.check_circle : Icons.error,
                          color: _isInitialized ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isInitialized ? 'Inicializado' : 'No inicializado',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          ReownServiceV2.isConnected ? Icons.link : Icons.link_off,
                          color: ReownServiceV2.isConnected ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          ReownServiceV2.isConnected ? 'Conectado' : 'Desconectado',
                        ),
                      ],
                    ),
                    if (ReownServiceV2.connectedAddress != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Dirección: ${ReownServiceV2.connectedAddress}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botones de acción
            ElevatedButton.icon(
              onPressed: _isInitialized && !_isConnecting && !ReownServiceV2.isConnected
                  ? _connectWallet
                  : null,
              icon: _isConnecting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.account_balance_wallet),
              label: Text(_isConnecting ? 'Conectando...' : 'Conectar Wallet'),
            ),
            
            const SizedBox(height: 8),
            
            ElevatedButton.icon(
              onPressed: ReownServiceV2.isConnected ? _disconnectWallet : null,
              icon: const Icon(Icons.link_off),
              label: const Text('Desconectar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
            ),
            
            const SizedBox(height: 8),
            
            ElevatedButton.icon(
              onPressed: _isInitialized ? _resetAndConnect : null,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset y Conectar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Información de debug
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Debug Info',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Service Initialized: ${ReownServiceV2.isInitialized}'),
                    Text('Is Connected: ${ReownServiceV2.isConnected}'),
                    Text('Connected Address: ${ReownServiceV2.connectedAddress ?? "None"}'),
                    if (ReownServiceV2.appKitModal != null)
                      Text('AppKit Modal: Available')
                    else
                      const Text('AppKit Modal: Not Available'),
                  ],
                ),
              ),
            ),
            
            // Error message
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            'Error',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _errorMessage = null;
                          });
                        },
                        child: const Text('Cerrar Error'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    ReownServiceV2.dispose();
    super.dispose();
  }
}
