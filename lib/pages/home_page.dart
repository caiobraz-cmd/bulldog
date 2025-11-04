import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../widgets/cart_modal.dart';
// O import do checkout_screen não é mais necessário aqui,
// pois a navegação é feita pelo nome da rota ('/checkout').

/// A tela principal do aplicativo para o cliente.
///
/// Exibe a lista de produtos disponíveis (lanches) em um [GridView]
/// e permite ao usuário adicionar itens ao carrinho.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Armazena o [Future] que busca os produtos da API.
  /// Isso evita que a API seja chamada toda vez que o widget é reconstruído.
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    // Inicia a chamada da API assim que a tela é carregada.
    _productsFuture = ProductService.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    /// Acessa o [CartProvider] aqui (com 'listen: false')
    /// para passá-lo para os widgets filhos (como [ProductCard] e [CartModal])
    /// que precisam *executar ações* (como adicionar itens),
    /// mas sem fazer esta tela inteira se reconstruir.
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,

      /// O [FloatingActionButton] (botão do carrinho) é envolvido por um
      /// [Consumer<CartProvider>].
      ///
      /// Isso faz com que *apenas* este widget se reconstrua quando o
      /// [CartProvider] notifica mudanças (ex: item adicionado/removido),
      /// atualizando o "badge" (o número) em tempo real.
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return Stack(
            children: [
              FloatingActionButton(
                onPressed: () {
                  // Abre o modal do carrinho
                  showDialog(
                    context: context,
                    // Passa o 'cart' vindo do Consumer
                    builder: (context) => CartModal(cartProvider: cart),
                  ).then((value) {
                    // Após o modal fechar, verifica se o widget ainda está na tela.
                    if (!mounted) return;

                    // Se o modal retornou o valor 'checkout'
                    // (acionado pelo botão "Finalizar" no modal),
                    // navega para a tela de checkout.
                    if (value == 'checkout') {
                      Navigator.of(context).pushNamed('/checkout');
                    }
                  });
                },
                backgroundColor: Colors.black.withValues(alpha: 0.4),
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              // Mostra o "badge" (círculo vermelho com o número)
              // apenas se houver itens no carrinho.
              if (cart.itemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFe41d31),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '${cart.itemCount}', // Lê o total de itens do provider
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      ),

      // Corpo principal da tela
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF9c0707)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40), // Espaço para o topo (tipo SafeArea)
              // Header com a Logo e Título
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/NETAIO/img/logo.png',
                        width: 250,
                        height: 180,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback caso a imagem não carregue
                          return Container(
                            width: 250,
                            height: 180,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.restaurant,
                              size: 100,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Escolha seu lanche',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Grade de Produtos
              Container(
                padding: const EdgeInsets.all(16),
                child: FutureBuilder<List<Product>>(
                  future: _productsFuture, // Usa o Future iniciado no initState
                  builder: (context, snapshot) {
                    // Estado de Carregamento
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFe41d31),
                        ),
                      );
                    }

                    // Estado de Erro
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Erro ao carregar produtos',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${snapshot.error}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                // Tenta recarregar os produtos
                                setState(() {
                                  _productsFuture =
                                      ProductService.getAllProducts();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFe41d31),
                              ),
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      );
                    }

                    // Estado de Sucesso (vazio)
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhum produto encontrado',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      );
                    }

                    // Estado de Sucesso (com dados)
                    final products = snapshot.data!;

                    // LayoutBuilder é usado para criar um GridView responsivo
                    // que muda o número de colunas baseado na largura da tela.
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount;
                        if (constraints.maxWidth > 1200) {
                          crossAxisCount = 4;
                        } else if (constraints.maxWidth > 800) {
                          crossAxisCount = 3;
                        } else if (constraints.maxWidth > 600) {
                          crossAxisCount = 2;
                        } else {
                          crossAxisCount = 1; // Padrão para mobile
                        }

                        return GridView.builder(
                          shrinkWrap: true, // Para caber dentro de um Column
                          physics:
                              const NeverScrollableScrollPhysics(), // Desabilita o scroll do Grid
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio:
                                    0.85, // Proporção ajustada para o card
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              product: product,
                              cartProvider: cartProvider,
                              onCartUpdated: () {
                                // O Consumer do badge já atualiza sozinho,
                                // mas o setState é mantido caso a home
                                // precise se redesenhar por outra razão.
                                setState(() {});
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),

              // Footer (Rodapé)
              Container(
                color: const Color(0xFF1a1a1a),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quem somos:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Uma lanchonete que prioriza o sabor e valoriza a sua experiência com a comida.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nos encontramos em:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Astorga/PR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Links de Redes Sociais
                    const Text(
                      'Redes sociais',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              _showLinkMessage('Instagram: @bull_dogs_lanches'),
                          child: const Row(
                            children: [
                              Icon(Icons.camera_alt, color: Color(0xFFe41d31)),
                              SizedBox(width: 4),
                              Text(
                                '@bull_dogs_lanches',
                                style: TextStyle(color: Color(0xFFe41d31)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () =>
                              _showLinkMessage('WhatsApp: (44) 9976-5116'),
                          child: const Row(
                            children: [
                              Icon(Icons.phone, color: Color(0xFFe41d31)),
                              SizedBox(width: 4),
                              Text(
                                '(44) 9976-5116',
                                style: TextStyle(color: Color(0xFFe41d31)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Divider(color: Colors.grey),
                    const Text(
                      '© 2025 Bull Dog Lanches. Todos os direitos reservados.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Exibe uma SnackBar (usada para os links do footer).
  void _showLinkMessage(String message) {
    if (!mounted) return; // Verificação de 'mounted'
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFe41d31),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
