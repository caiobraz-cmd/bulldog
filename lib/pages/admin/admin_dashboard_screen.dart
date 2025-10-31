import 'package:flutter/material.dart';
import 'package:bulldogs/pages/login_page.dart';
import 'package:bulldogs/pages/admin/admin_product_list_screen.dart';
import 'package:bulldogs/pages/admin/admin_reports_screen.dart';

// --- 3.1. PAINEL DE CONTROLE DO ADMIN ---
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  void _logout(BuildContext context) {
    // Volta para a tela de Login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false, // Remove todas as rotas anteriores
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bem-vindo, Admin!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            // Botão para Gerenciar Produtos
            FilledButton.icon(
              icon: const Icon(Icons.edit_note),
              label: const Text('Gerenciar Produtos e Estoque'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminProductListScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Botão para Ver Relatórios
            FilledButton.icon(
              icon: const Icon(Icons.bar_chart),
              label: const Text('Ver Relatórios de Vendas'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminReportsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
