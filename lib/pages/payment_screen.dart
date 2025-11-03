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

  // Função para o botão "Finalizar Pedido" (atualmente, só mostra um aviso)
  void _finishOrder() {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma forma de pagamento.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Lógica de finalização (placeholder)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Pedido finalizado com sucesso! (Simulação)'),
        backgroundColor: Colors.green[700],
      ),
    );

    // Limpa o carrinho e volta para a home
    Provider.of<CartProvider>(context, listen: false).clearCart();
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

                    // 1. 'RadioGroup'
                    RadioGroup<PaymentMethod>(
                      // 2. 'groupValue' E 'onChanged' VIVEM AQUI
                      groupValue: _selectedMethod,
                      onChanged: (PaymentMethod? newValue) {
                        setState(() {
                          _selectedMethod = newValue;
                        });
                      },
                      // 3. 'children' FOI MUDADO PARA 'child' E USA UMA 'Column'
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
  // (Nenhuma mudança necessária aqui, já estava correto)
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
