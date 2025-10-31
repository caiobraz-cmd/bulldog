import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // Lógica de login simulada
    if (_emailController.text == 'admin@bulldogs.com') {
      // Navega para o painel de admin
      Navigator.of(context).pushReplacementNamed('/admin');
    } else {
      // Navega para a home de cliente
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cores do seu tema
    const primaryColor = Color(0xFFe41d31);
    const textFieldColor = Color(0xFF1a1a1a);

    return Scaffold(
      body: Container(
        width: double.infinity, // Garante que o gradiente cubra tudo
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF9c0707)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          // 1. SUBSTITUÍDO O 'Center' POR 'Align'
          child: Align(
            // 2. ALINHADO NO TOPO E CENTRO (Horizontal)
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 450, // Limita a largura máxima do formulário
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 3. ESPAÇO NO TOPO AJUSTADO
                  const SizedBox(height: 40),

                  // Logo
                  Image.asset(
                    'assets/NETAIO/img/logo.png', // Certifique-se que este caminho está correto
                    width: 250,
                    height: 180,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback caso a imagem não carregue
                      return const Icon(
                        Icons.fastfood,
                        size: 100,
                        color: Colors.white,
                      );
                    },
                  ),
                  const SizedBox(height: 40),

                  // Campo de Email
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: textFieldColor,
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // Campo de Senha
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Senha',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: textFieldColor,
                      prefixIcon: const Icon(Icons.lock, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Botão de Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor, // Vermelho principal
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
