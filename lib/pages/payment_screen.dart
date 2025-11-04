import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

/// Enum para definir as opções de forma de pagamento.
enum PaymentMethod { pix, creditCard, cash }

/// Tela final do fluxo de pedido, onde o cliente escolhe
/// a forma de pagamento e confirma a compra.
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  /// Armazena o método de pagamento selecionado pelo usuário.
  /// Começa com [PaymentMethod.pix] como padrão.
  PaymentMethod? _selectedMethod = PaymentMethod.pix;

  /// Função chamada ao pressionar "FINALIZAR PEDIDO".
  ///
  /// Valida se um método foi selecionado, exibe um dialog de sucesso (simulação),
  /// limpa o carrinho e navega de volta para a tela inicial ('/home').
  Future<void> _finishOrder() async {
    // Valida se uma opção foi selecionada
    if (_selectedMethod == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma forma de pagamento.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Acessa os providers (com 'listen: false') pois estamos dentro de um método.
    final cart = Provider.of<CartProvider>(context, listen: false);
    final total = cart.totalPrice;
    // final auth = Provider.of<AuthProvider>(context, listen: false); // Removido
    // final userName = auth.userName; // Removido

    // Exibe o dialog de sucesso (simulação)
    if (!mounted) return;
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
            // Mensagem genérica (sem o nome do usuário, conforme revertemos)
            'Obrigado!\nSeu pedido de R\$ ${total.toStringAsFixed(2)} está sendo preparado e logo sairá para entrega.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
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

    // Garante que o widget ainda está na tela após o 'await' do dialog
    if (!mounted) return;

    // Limpa o carrinho e navega para a home, finalizando o fluxo.
    cart.clearCart();
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFe41d31);
    const cardColor = Color(0xFF1a1a1a);

    // Acessa o CartProvider (com 'listen: true') para que o total
    // seja atualizado se algo mudar (embora seja raro nesta tela).
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
                    // Card com o resumo do valor total
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

                    // Título da seção de pagamento
                    const Text(
                      'Forma de Pagamento',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Grupo de opções de pagamento
                    // Usa [RadioGroup] para gerenciar o estado
                    // e evitar avisos de deprecação.
                    RadioGroup<PaymentMethod>(
                      groupValue: _selectedMethod,
                      onChanged: (PaymentMethod? newValue) {
                        setState(() {
                          _selectedMethod = newValue;
                        });
                      },
                      child: Column(
                        children: [
                          _buildPaymentOption(
                            title: 'Pix',
                            icon: Icons.qr_code,
                            value: PaymentMethod.pix,
                          ),
                          _buildPaymentOption(
                            title: 'Cartão de Crédito',
                            icon: Icons.credit_card,
                            value: PaymentMethod.creditCard,
                          ),
                          _buildPaymentOption(
                            title: 'Dinheiro (na entrega)',
                            icon: Icons.money,
                            value: PaymentMethod.cash,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Botão de Finalizar Pedido
                    ElevatedButton(
                      onPressed: _finishOrder,
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

  /// Helper para construir os widgets [RadioListTile] estilizados.
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
        // Destaca a borda do item selecionado
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
