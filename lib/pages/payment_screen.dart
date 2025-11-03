import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

// Enum para controlar a seleção de pagamento
enum PaymentMethod { pix, creditCard, cash }

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Estado para controlar qual método está selecionado
  PaymentMethod? _selectedMethod =
      PaymentMethod.pix; // Começa com Pix selecionado

  // --- MUDANÇA AQUI ---
  // A função agora é 'async' para esperar o dialog
  Future<void> _finishOrder() async {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma forma de pagamento.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Pega o provider ANTES de mostrar o dialog
    final cart = Provider.of<CartProvider>(context, listen: false);
    final total = cart.totalPrice;

    // --- DIALOG DE SUCESSO ADICIONADO ---
    await showDialog(
      context: context,
      barrierDismissible: false, // Usuário não pode fechar clicando fora
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1a1a1a),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Pedido Recebido!'),
            ],
          ),
          content: Text(
            'Obrigado!\nSeu pedido de R\$ ${total.toStringAsFixed(2)} está sendo preparado e logo sairá para entrega.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Fecha o dialog
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFFe41d31)),
              ),
            ),
          ],
        );
      },
    );

    // --- Lógica movida para DEPOIS do dialog ---
    // Verifica se o widget ainda está montado após o 'await'
    if (!mounted) return;

    // Limpa o carrinho e volta para a home
    cart.clearCart();
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFe41d31);
    const cardColor = Color(0xFF1a1a1a);
    // Pega o carrinho para mostrar o total
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento'),
        backgroundColor: cardColor,
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
                    // --- 1. RESUMO DO TOTAL ---
                    Card(
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'TOTAL DO PEDIDO:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'R\$ ${cart.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // --- 2. OPÇÕES DE PAGAMENTO ---
                    const Text(
                      'Forma de Pagamento',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Usando o RadioGroup (forma correta)
                    RadioGroup<PaymentMethod>(
                      groupValue: _selectedMethod,
                      onChanged: (PaymentMethod? newValue) {
                        setState(() {
                          _selectedMethod = newValue;
                        });
                      },
                      child: Column(
                        children: [
                          // Opção PIX
                          _buildPaymentOption(
                            title: 'Pix',
                            icon: Icons.qr_code,
                            value: PaymentMethod.pix,
                          ),
                          // Opção Cartão
                          _buildPaymentOption(
                            title: 'Cartão de Crédito',
                            icon: Icons.credit_card,
                            value: PaymentMethod.creditCard,
                          ),
                          // Opção Dinheiro
                          _buildPaymentOption(
                            title: 'Dinheiro (na entrega)',
                            icon: Icons.money,
                            value: PaymentMethod.cash,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // --- 3. BOTÃO FINALIZAR ---
                    ElevatedButton(
                      onPressed: _finishOrder, // Chama a função de finalizar
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('FINALIZAR PEDIDO'),
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

  // Helper para construir os botões de rádio de pagamento
  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required PaymentMethod value,
  }) {
    const cardColor = Color(0xFF1a1a1a);
    const primaryColor = Color(0xFFe41d31);

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: _selectedMethod == value ? primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: RadioListTile<PaymentMethod>(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        secondary: Icon(icon, color: Colors.white),
        value: value,
        activeColor: primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
