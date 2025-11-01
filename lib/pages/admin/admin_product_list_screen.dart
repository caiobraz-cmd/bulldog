import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';

class AdminProductListScreen extends StatefulWidget {
  const AdminProductListScreen({super.key});

  @override
  State<AdminProductListScreen> createState() => _AdminProductListScreenState();
}

class _AdminProductListScreenState extends State<AdminProductListScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.getAllProducts();
  }

  // 1. FUNÇÃO DE NAVEGAÇÃO ATUALIZADA
  void _navigateToEditScreen([Product? product]) {
    Navigator.of(context)
        .pushNamed(
          '/admin/product/edit',
          arguments: product, // Envia o produto (ou null) para a nova tela
        )
        .then((_) {
          // 2. ATUALIZA A LISTA QUANDO VOLTAR
          //    (Isso garante que a lista mostre o produto novo/editado)
          setState(() {
            _productsFuture = ProductService.getAllProducts();
          });
        });
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF9c0707)],
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ), // Limita a largura na Web
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar produtos: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nenhum produto cadastrado',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final products = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
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
                        trailing: ElevatedButton(
                          onPressed: () => _navigateToEditScreen(product),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF404040,
                            ), // Cor escura (EDITAR)
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('EDITAR'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToEditScreen(null), // 'null' significa criar
        label: const Text('CADASTRAR NOVO PRODUTO'),
        icon: const Icon(Icons.add),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
