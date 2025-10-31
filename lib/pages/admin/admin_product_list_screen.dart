import 'package:flutter/material.dart';

// --- 3.2. TELA DE LISTA/EDIÇÃO DE PRODUTOS (Admin) ---
// Baseada no Mock-up (Página 14)
class AdminProductListScreen extends StatelessWidget {
  const AdminProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Produtos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Lista simulada de produtos
            Expanded(
              child: ListView(
                children: [
                  // Item de produto simulado
                  Card(
                    color: Colors.black.withOpacity(0.3),
                    child: ListTile(
                      title: const Text('Produto Nome 1'),
                      subtitle: const Text('descrição...'),
                      trailing: TextButton(
                        child: const Text(
                          'EDITAR',
                          style: TextStyle(color: Color(0xffe64d1d)),
                        ),
                        onPressed: () {
                          // TODO: Abrir modal ou tela de edição
                        },
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.black.withOpacity(0.3),
                    child: ListTile(
                      title: const Text('Produto Nome 2'),
                      subtitle: const Text('descrição...'),
                      trailing: TextButton(
                        child: const Text(
                          'EDITAR',
                          style: TextStyle(color: Color(0xffe64d1d)),
                        ),
                        onPressed: () {
                          // TODO: Abrir modal ou tela de edição
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Botão de Cadastrar
            FilledButton(
              onPressed: () {
                // TODO: Abrir tela de cadastro de novo produto
              },
              child: const Text('CADASTRAR NOVO PRODUTO'),
            ),
          ],
        ),
      ),
    );
  }
}
