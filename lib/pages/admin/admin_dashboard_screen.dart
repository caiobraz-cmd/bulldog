import 'package:flutter/material.dart';

/// Tela principal do painel administrativo (Dashboard).
///
/// Esta tela serve como o menu central para o administrador,
/// oferecendo navegação para as seções de "Gerenciar Produtos"
/// e "Ver Relatórios".
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFe41d31);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Admin'),
        backgroundColor: const Color(
          0xFF1a1a1a,
        ), // Cor escura para combinar com o tema
        actions: [
          /// Botão de Logout
          /// Desconecta o admin e o retorna para a tela de login.
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Retorna para a tela de login
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Aplicando o mesmo gradiente do login e home
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF9c0707)],
          ),
        ),
        // Alinha o conteúdo no topo (para web/telas maiores)
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            // Limita a largura máxima do conteúdo em telas grandes
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // Logo
                  Image.asset(
                    'assets/NETAIO/img/logo.png', // O mesmo caminho da tela de Login
                    width: 250,
                    height: 180,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.admin_panel_settings,
                        size: 100,
                        color: Colors.white,
                      );
                    },
                  ),
                  const SizedBox(height: 40),

                  /// Botão de navegação para "Gerenciar Produtos"
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit_document),
                    label: const Text('GERENCIAR PRODUTOS'),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/admin/products');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Botão de navegação para "Ver Relatórios"
                  ElevatedButton.icon(
                    icon: const Icon(Icons.bar_chart),
                    label: const Text('VER RELATÓRIOS'),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/admin/reports');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
