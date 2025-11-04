import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart'; // Precisamos do CartItem

/// A tela de "Revisão Final" do pedido.
///
/// Esta é a etapa *antes* do pagamento, onde o usuário pode:
/// 1. Confirmar o endereço de entrega (passado da [CheckoutScreen]).
/// 2. Rever os itens do carrinho em um carrossel horizontal.
/// 3. Adicionar observações *individuais* para cada item.
/// 4. Ver o total final do pedido.
class ReviewOrderScreen extends StatefulWidget {
  /// O endereço digitado pelo usuário na tela anterior.
  final String address;

  /// A observação do endereço digitada pelo usuário.
  final String addressObservation;

  const ReviewOrderScreen({
    super.key,
    required this.address,
    required this.addressObservation,
  });

  @override
  State<ReviewOrderScreen> createState() => _ReviewOrderScreenState();
}

class _ReviewOrderScreenState extends State<ReviewOrderScreen> {
  /// Uma lista de controladores de texto para as observações
  /// de *cada item* no carrossel.
  late List<TextEditingController> _itemObservationControllers;

  /// Controlador para o [PageView] (carrossel de itens).
  final PageController _pageController = PageController(
    viewportFraction: 0.85, // Faz com que o próximo item "espreite"
  );

  @override
  void initState() {
    super.initState();
    // Acessa o provider (sem escutar) para inicializar os controladores
    final cart = Provider.of<CartProvider>(context, listen: false);

    // Cria um TextEditingController para cada item no carrinho.
    _itemObservationControllers = List.generate(
      cart.items.length,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    // Descarta todos os controladores para evitar memory leaks.
    for (var controller in _itemObservationControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFe41d31);
    const textFieldColor = Color(0xFF2e2d2d);
    // Acessa o CartProvider (escutando) para o build.
    // Se o carrinho mudar (ex: item removido), esta tela se reconstrói.
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisão Final do Pedido'),
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
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              // Limita a largura máxima em telas maiores
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    // --- 1. Card de Revisão do Endereço ---
                    _buildAddressReviewCard(),
                    const SizedBox(height: 40),

                    // --- 2. Seção de Revisão de Itens ---
                    const Text(
                      'Itens do Pedido',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Carrossel horizontal de itens
                    _buildItemsCarousel(cart, textFieldColor),

                    const SizedBox(height: 40),

                    // --- 3. Total do Pedido ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL:',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'R\$ ${cart.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // --- 4. Botão de Pagamento ---
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Coletar as observações individuais
                        // de '_itemObservationControllers' e
                        // passá-las adiante (provavelmente salvando no provider).
                        Navigator.of(context).pushNamed('/payment');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('IR PARA PAGAMENTO'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Constrói o card que exibe o endereço e a observação do endereço.
  Widget _buildAddressReviewCard() {
    return Card(
      color: const Color(0xFF1a1a1a),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Endereço para Entrega',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Botão "Editar" que volta para a tela anterior
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFFe41d31)),
                  onPressed: () {
                    // Volta para a CheckoutScreen (tela de endereço)
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            // Exibe o endereço passado como argumento
            Text(
              widget.address,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            // Exibe a observação (se houver)
            if (widget.addressObservation.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Observação: ${widget.addressObservation}',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Constrói o carrossel horizontal [PageView] para os itens do carrinho.
  Widget _buildItemsCarousel(CartProvider cart, Color textFieldColor) {
    // Se o carrinho estiver vazio, mostra uma mensagem e um botão para voltar.
    if (cart.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            children: [
              const Text(
                'Seu carrinho está vazio.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home',
                  (Route<dynamic> route) => false,
                ),
                child: const Text('Voltar para o Cardápio'),
              ),
            ],
          ),
        ),
      );
    }

    // Constrói o carrossel
    return SizedBox(
      height: 450, // Altura fixa para o PageView
      child: PageView.builder(
        controller: _pageController,
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          final item = cart.items[index];
          // Padding para o efeito de "espiar" (viewportFraction)
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildItemReviewCard(
              item,
              _itemObservationControllers[index],
              textFieldColor,
            ),
          );
        },
      ),
    );
  }

  /// Constrói o card individual para cada item no carrossel de revisão.
  Widget _buildItemReviewCard(
    CartItem item,
    TextEditingController controller,
    Color textFieldColor,
  ) {
    return Card(
      color: const Color(0xFF1a1a1a),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Permite rolar se o conteúdo do card for grande
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem do produto
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  item.product.imagePath,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(
                    height: 180,
                    color: Colors.grey[800],
                    child: const Icon(Icons.fastfood, size: 80),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Nome do produto
              Text(
                item.product.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // Preço do item (com adicionais)
              Text(
                'Subtotal: R\$ ${item.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              // Lista de adicionais (se houver)
              if (item.additionals.isNotEmpty)
                Text(
                  'Adicionais: ${item.additionals.map((a) => a.name).join(', ')}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              const SizedBox(height: 16),
              // Campo de observação individual
              TextFormField(
                controller: controller,
                decoration: _buildInputDecoration(
                  'Observação para este item',
                  'Ex: Tirar a cebola...',
                  Icons.edit,
                  textFieldColor,
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper de decoração para os campos de texto.
  InputDecoration _buildInputDecoration(
    String label,
    String hint,
    IconData icon,
    Color fillColor,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[400]),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[600]),
      filled: true,
      fillColor: fillColor,
      prefixIcon: Icon(icon, color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFe41d31), width: 2),
      ),
    );
  }
}
