import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/koneque_provider.dart';
import '../models/contract_config.dart';

/// Pantalla principal del marketplace con funcionalidades Web3
class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Koneque Marketplace'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<KonequeProvider>(
            builder: (context, provider, child) {
              return provider.isConnected
                  ? _buildConnectedWidget(provider)
                  : _buildConnectButton();
            },
          ),
        ],
      ),
      body: Consumer<KonequeProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: CustomScrollView(
              slivers: [
                // Estado de conexión y balance
                SliverToBoxAdapter(
                  child: _buildStatusCard(provider),
                ),
                
                // Acciones principales
                SliverToBoxAdapter(
                  child: _buildActionButtons(provider),
                ),
                
                // Lista de productos
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Productos Disponibles',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                
                _buildProductsList(provider),
                
                // Transacciones del usuario
                if (provider.isConnected) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Mis Transacciones',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  _buildTransactionsList(provider),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: Consumer<KonequeProvider>(
        builder: (context, provider, child) {
          return provider.isConnected
              ? FloatingActionButton(
                  onPressed: () => _showListProductDialog(context, provider),
                  child: const Icon(Icons.add),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildConnectedWidget(KonequeProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Conectado',
            style: const TextStyle(fontSize: 12, color: Colors.green),
          ),
          Text(
            '${provider.connectedAddress?.substring(0, 6)}...${provider.connectedAddress?.substring(38)}',
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectButton() {
    return Consumer<KonequeProvider>(
      builder: (context, provider, child) {
        return PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'connect') {
              await _connectWallet(provider);
            } else if (value == 'retry') {
              await _retryConnection(provider);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'connect',
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet),
                  SizedBox(width: 8),
                  Text('Conectar Wallet'),
                ],
              ),
            ),
            if (provider.errorMessage != null)
              const PopupMenuItem(
                value: 'retry',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Reintentar'),
                  ],
                ),
              ),
          ],
          child: TextButton.icon(
            onPressed: () => _connectWallet(provider),
            icon: Icon(
              provider.errorMessage != null ? Icons.error : Icons.account_balance_wallet,
              color: provider.errorMessage != null ? Colors.red : null,
            ),
            label: Text(
              provider.errorMessage != null ? 'Error' : 'Conectar',
              style: TextStyle(
                color: provider.errorMessage != null ? Colors.red : null,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Conecta la wallet con manejo de errores
  Future<void> _connectWallet(KonequeProvider provider) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Conectando wallet...'),
            ],
          ),
        ),
      );

      await provider.connectWallet(context);
      
      if (mounted) {
        Navigator.of(context).pop(); // Cerrar diálogo de carga
      }
      
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Cerrar diálogo de carga
        
        // Mostrar error específico
        await _showConnectionError(e.toString());
      }
    }
  }

  /// Reintenta la conexión
  Future<void> _retryConnection(KonequeProvider provider) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Reintentando conexión...'),
            ],
          ),
        ),
      );

      await provider.retryConnection();
      
      if (mounted) {
        Navigator.of(context).pop(); // Cerrar diálogo de carga
      }
      
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Cerrar diálogo de carga
        await _showConnectionError(e.toString());
      }
    }
  }

  /// Muestra un diálogo de error de conexión
  Future<void> _showConnectionError(String error) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Error de Conexión'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(error),
            const SizedBox(height: 16),
            const Text(
              'Posibles soluciones:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Asegúrate de que MetaMask esté instalado'),
            const Text('• Verifica tu conexión a internet'),
            const Text('• Intenta cerrar y abrir MetaMask'),
            const Text('• Reinicia la aplicación si persiste el problema'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(KonequeProvider provider) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  provider.isConnected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: provider.isConnected ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  provider.isConnected ? 'Wallet Conectada' : 'Wallet No Conectada',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            
            // Mostrar mensaje de error si existe
            if (provider.errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.errorMessage!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (provider.isConnected) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Balance ETH'),
                        Text(
                          '${(provider.ethBalance.toDouble() / 1e18).toStringAsFixed(4)} ETH',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Balance KNQ'),
                        Text(
                          '${(provider.tokenBalance.toDouble() / 1e18).toStringAsFixed(2)} KNQ',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Red: ${ContractConfig.networkName}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (provider.errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.errorMessage!,
                        style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                      ),
                    ),
                    IconButton(
                      onPressed: provider.clearError,
                      icon: const Icon(Icons.close, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(KonequeProvider provider) {
    if (!provider.isConnected) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showCreateReferralDialog(context, provider),
              icon: const Icon(Icons.share),
              label: const Text('Crear Código Referido'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showUseReferralDialog(context, provider),
              icon: const Icon(Icons.redeem),
              label: const Text('Usar Código'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(KonequeProvider provider) {
    if (provider.isLoadingProducts) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (provider.products.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No hay productos disponibles',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.isConnected 
                      ? 'Sé el primero en listar un producto'
                      : 'Conecta tu wallet para ver más opciones',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = provider.products[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.shopping_bag),
              ),
              title: Text('Producto #${product.id}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Precio: ${(product.price.toDouble() / 1e18).toStringAsFixed(4)} ETH'),
                  Text('Categoría: ${product.category}'),
                  Text('Vendedor: ${product.seller.substring(0, 6)}...${product.seller.substring(38)}'),
                ],
              ),
              trailing: provider.isConnected && 
                       provider.connectedAddress?.toLowerCase() != product.seller.toLowerCase()
                  ? ElevatedButton(
                      onPressed: () => _buyProduct(provider, product.id),
                      child: const Text('Comprar'),
                    )
                  : null,
              onTap: () => _showProductDetails(context, product),
            ),
          );
        },
        childCount: provider.products.length,
      ),
    );
  }

  Widget _buildTransactionsList(KonequeProvider provider) {
    if (provider.isLoadingTransactions) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (provider.userTransactions.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              'No tienes transacciones aún',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final transaction = provider.userTransactions[index];
          final isUserBuyer = transaction.buyer.toLowerCase() == 
                              provider.connectedAddress?.toLowerCase();
          
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(transaction.status),
                child: Icon(
                  isUserBuyer ? Icons.shopping_cart : Icons.sell,
                  color: Colors.white,
                ),
              ),
              title: Text('${isUserBuyer ? 'Compra' : 'Venta'} #${transaction.id}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Estado: ${transaction.statusText}'),
                  Text('Monto: ${(transaction.amount.toDouble() / 1e18).toStringAsFixed(4)} ETH'),
                  Text('Fecha: ${transaction.createdAt.toString().substring(0, 16)}'),
                ],
              ),
              trailing: _buildTransactionActions(provider, transaction, isUserBuyer),
              onTap: () => _showTransactionDetails(context, transaction),
            ),
          );
        },
        childCount: provider.userTransactions.length,
      ),
    );
  }

  Widget? _buildTransactionActions(KonequeProvider provider, transaction, bool isUserBuyer) {
    switch (transaction.status) {
      case TransactionStatus.paymentCompleted:
        if (isUserBuyer) {
          return ElevatedButton(
            onPressed: () => provider.confirmDelivery(transaction.id),
            child: const Text('Confirmar'),
          );
        }
        break;
      case TransactionStatus.productDelivered:
        if (isUserBuyer) {
          return ElevatedButton(
            onPressed: () => provider.finalizeTransaction(transaction.id),
            child: const Text('Finalizar'),
          );
        }
        break;
      default:
        break;
    }
    return null;
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.paymentCompleted:
        return Colors.orange;
      case TransactionStatus.productDelivered:
        return Colors.blue;
      case TransactionStatus.finalized:
        return Colors.green;
      case TransactionStatus.inDispute:
        return Colors.red;
      case TransactionStatus.refunded:
        return Colors.grey;
    }
  }

  void _buyProduct(KonequeProvider provider, BigInt productId) async {
    // Mostrar confirmación
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Compra'),
        content: Text('¿Estás seguro de que quieres comprar el producto #$productId?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Comprar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await provider.buyProduct(productId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Producto comprado exitosamente!')),
        );
      }
    }
  }

  void _showProductDetails(BuildContext context, product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Producto #${product.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Precio: ${(product.price.toDouble() / 1e18).toStringAsFixed(4)} ETH'),
            Text('Categoría: ${product.category}'),
            Text('Vendedor: ${product.seller}'),
            Text('URI: ${product.metadataURI}'),
            Text('Listado: ${product.listedAt}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Transacción #${transaction.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Producto: #${transaction.itemId}'),
            Text('Comprador: ${transaction.buyer}'),
            Text('Vendedor: ${transaction.seller}'),
            Text('Monto: ${(transaction.amount.toDouble() / 1e18).toStringAsFixed(4)} ETH'),
            Text('Estado: ${transaction.statusText}'),
            Text('Creado: ${transaction.createdAt}'),
            if (transaction.updatedAt != null)
              Text('Actualizado: ${transaction.updatedAt}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showListProductDialog(BuildContext context, KonequeProvider provider) {
    // TODO: Implementar formulario completo para listar productos
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Listar Producto'),
        content: const Text('Función de listado de productos próximamente...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showCreateReferralDialog(BuildContext context, KonequeProvider provider) {
    final codeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear Código de Referido'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Código',
                hintText: 'Ej: AMIGO2024',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (codeController.text.isNotEmpty) {
                Navigator.of(context).pop();
                final success = await provider.createReferralCode(
                  code: codeController.text,
                  validity: const Duration(days: 30),
                  maxUsage: 10,
                );
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Código de referido creado!')),
                  );
                }
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  void _showUseReferralDialog(BuildContext context, KonequeProvider provider) {
    final codeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usar Código de Referido'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Código de Referido',
                hintText: 'Ingresa el código',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (codeController.text.isNotEmpty) {
                Navigator.of(context).pop();
                final success = await provider.registerWithReferralCode(codeController.text);
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Registrado con código de referido!')),
                  );
                }
              }
            },
            child: const Text('Usar'),
          ),
        ],
      ),
    );
  }
}
