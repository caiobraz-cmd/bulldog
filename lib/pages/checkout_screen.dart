import 'package:flutter/material.dart';
import 'package:bulldog/pages/payment_screen.dart';

// --- 2.2. TELA DE FINALIZAÇÃO (Endereço) ---
// Baseada no Mock-up (Página 13)
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finalizar Pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Endereço',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Digite seu endereço completo...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            const Text(
              'Observação',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Ex: Tirar cebola, ponto da carne...',
              ),
              maxLines: 2,
            ),
            const Spacer(), // Empurra o botão para baixo
            FilledButton(
              onPressed: () {
                // Navega para a tela de Pagamento
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentScreen(),
                  ),
                );
              },
              child: const Text('Ir para Pagamento'),
            ),
          ],
        ),
      ),
    );
  }
}
