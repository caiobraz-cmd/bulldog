import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product.dart'; // Precisamos do CartItem

class ReviewOrderScreen extends StatefulWidget {
  final String address;
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
  // Controladores para os campos de observação de CADA item
  late List<TextEditingController> _itemObservationControllers;

  final PageController _pageController = PageController(
    viewportFraction: 0.85,
  ); // Para o carrossel

  @override
  void initState() {
    super.initState();
    // Pega o cartProvider (sem escutar) para inicializar os controllers
    final cart = Provider.of<CartProvider>(context, listen: false);

    // Cria um controller para cada item no carrinho
    _itemObservationControllers = List.generate(
      cart.items.length,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    // Limpa todos os controllers
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
    // Pega o cartProvider (escutando) para o build
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
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // --- 1. SEÇÃO DE REVISÃO DE ENDEREÇO ---
                    _buildAddressReviewCard(),
                    const SizedBox(height: 40),

                    // --- 2. SEÇÃO DE REVISÃO DE ITENS ---
                    const Text(
                      'Itens do Pedido',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Carrossel Horizontal
                    _buildItemsCarousel(cart, textFieldColor),

                    const SizedBox(height: 40),

                    // --- 3. TOTAL DO PEDIDO ---
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

                    // --- 4. BOTÃO DE PAGAMENTO ---
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Coletar TODOS os dados (endereço, observações)
                        // e passar para a tela de pagamento
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

  // Card para mostrar o endereço e observação (para revisão)
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
                // Botão para voltar e editar o endereço
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFFe41d31)),
                  onPressed: () {
                    // Simplesmente volta para a tela anterior
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              widget.address, // Mostra o endereço digitado
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            // Mostra a observação do endereço (se houver)
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

  // Widget para o Carrossel
  Widget _buildItemsCarousel(CartProvider cart, Color textFieldColor) {
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

    return SizedBox(
      height: 450, // Altura fixa para o carrossel
      child: PageView.builder(
        controller: _pageController,
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          final item = cart.items[index];
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

  // Widget para o Card de Revisão de cada Item (igual ao anterior)
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Text(
                item.product.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Subtotal: R\$ ${item.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 8),
              if (item.additionals.isNotEmpty)
                Text(
                  'Adicionais: ${item.additionals.map((a) => a.name).join(', ')}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              const SizedBox(height: 16),
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

  // Helper de decoração
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
