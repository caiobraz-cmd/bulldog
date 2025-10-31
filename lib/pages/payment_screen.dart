import 'package:flutter/material.dart';

// --- 2.3. TELA DE PAGAMENTO (UI Pronta) ---
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Tela de Pagamento',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ainda não implementado.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: () {
                  // TODO: Lógica para finalizar o pedido (dar baixa no estoque, etc)

                  // Simplesmente volta para a Home por enquanto
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Finalizar Pedido (Simulado)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
