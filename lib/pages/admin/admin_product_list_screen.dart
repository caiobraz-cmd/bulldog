import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';

/// Tela administrativa para listar e gerenciar todos os produtos.
///
/// Permite ao admin ver a lista de produtos cadastrados,
/// navegar para a tela de edição de um produto existente,
/// ou navegar para a tela de criação de um novo produto.
class AdminProductListScreen extends StatefulWidget {
  const AdminProductListScreen({super.key});

  @override
  State<AdminProductListScreen> createState() => _AdminProductListScreenState();
}

class _AdminProductListScreenState extends State<AdminProductListScreen> {
  /// Armazena o [Future] que busca os produtos da API.
  /// Usar um [Future] no state evita que a API seja chamada
  /// desnecessariamente a cada reconstrução do widget.
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.getAllProducts();
  }

  void _navigateToEditScreen([Product? product]) {
    Navigator.of(
      context,
    ).pushNamed('/admin/product/edit', arguments: product).then((_) {
      // Recarrega lista ao voltar
      setState(() {
        _productsFuture = ProductService.getAllProducts();
      });
    });
  }

  /// 🔹 Função para "deletar" (soft delete)
  void _deleteProduct(int id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2e2d2d),
        title: const Text(
          'Excluir Produto',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Deseja realmente desativar "$name"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Desativar',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await ProductService.deleteProduct(id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto "$name" desativado com sucesso!')),
        );
        setState(() {
          _productsFuture = ProductService.getAllProducts();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao desativar produto: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFe41d31);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Produtos'),
        backgroundColor: const Color(0xFF1a1a1a),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Gradiente padrão do app
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF9c0707)],
          ),
        ),
        // Alinha o conteúdo no topo e limita a largura
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                // Estado de Carregamento
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }

                // Estado de Erro
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar produtos: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                // Estado de Sucesso (vazio)
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhum produto cadastrado',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                // Estado de Sucesso (com dados)
                final products = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    // Constrói o card de produto (baseado no mock-up da Pág. 14)
                    return Card(
                      color: const Color(0xFF2e2d2d),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Image.asset(
                          product.imagePath,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) =>
                              const Icon(Icons.fastfood, color: Colors.grey),
                        ),
                        title: Text(
                          product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          product.description,
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () => _navigateToEditScreen(product),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF404040),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('EDITAR'),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () =>
                                  _deleteProduct(product.seqId, product.name),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      // Botão flutuante para "Cadastrar Novo Produto"
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToEditScreen(null),
        label: const Text('CADASTRAR NOVO PRODUTO'),
        icon: const Icon(Icons.add),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
