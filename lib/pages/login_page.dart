import 'package:bulldogs/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:bulldogs/pages/admin/admin_dashboard_screen.dart';

// --- 1. TELA DE LOGIN ---
// Baseada no Mock-up (Página 10)

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Função de login (simulada)
  void _login() {
    // Lógica de login (simulada)
    // No futuro, aqui você fará a autenticação real
    String email = _emailController.text;

    // SIMULAÇÃO: Se o email for 'admin@bulldogs.com', vai para o painel de admin
    if (email.toLowerCase() == 'admin@bulldogs.com') {
      // Navega para o Dashboard de Admin
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    } else {
      // Senão, navega para o fluxo normal de cliente
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ), // A tela que você já tem
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              // Placeholder para o Logo "BULL DOGS LANCHES"
              // Você pode trocar por: Image.asset('assets/logo.png')
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.fastfood,
                    color: Color(0xffe64d1d),
                    size: 80,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'BULL DOGS LANCHES',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50),

              // Campo de Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Campo de Senha
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Senha',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 40),

              // Botão de Login
              FilledButton(onPressed: _login, child: const Text('LOGIN')),
            ],
          ),
        ),
      ),
    );
  }
}
