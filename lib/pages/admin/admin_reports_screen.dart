import 'package:flutter/material.dart';

// --- 3.3. TELA DE RELATÓRIOS (Admin) ---
// Baseada no Mock-up (Página 8)
class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Relatório de Saídas de Estoque',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '(Aqui vai a tabela/lista de saídas)',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                'Relatório por Período',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '(Aqui vão os seletores de data e a tabela filtrada)',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
