import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // 1. ADICIONADO UM NÓ DE FOCO para o campo de senha
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    // 2. DESCARTAR O NÓ DE FOCO
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // 1. CORREÇÃO: Usamos .trim() para remover espaços
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // 2. Validação inicial no app (agora com os valores "limpos")
    if (email.isEmpty || password.isEmpty) {
      _showFeedbackMessage(
        'Por favor, preencha e-mail e senha.',
        isError: true,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://oracleapex.com/ords/bulldog/api/login-user');

    try {
      // 3. Envio dos dados para a API via POST (com os valores "limpos")
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': email, 'password': password}),
      );

      if (!mounted) return;

      final responseData = json.decode(response.body);

      // 4. Verificação da resposta da API
      if (response.statusCode == 200) {
        // SUCESSO! A API autenticou o usuário.
        // AGORA, a decisão é baseada na "role" que a API enviou.
        final String role = responseData['role'] ?? 'unknown'; // Pega a "role"

        switch (role) {
          case 'admin':
            Navigator.of(context).pushReplacementNamed('/admin');
            break;
          case 'cliente':
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          default:
            // Caso a API retorne uma role inesperada
            _showFeedbackMessage(
              'Erro: Tipo de usuário desconhecido.',
              isError: true,
            );
        }
      } else {
        // FALHA! A API retornou um erro (ex: 401).
        final String message =
            responseData['message'] ?? 'Credenciais inválidas.';
        _showFeedbackMessage(message, isError: true);
      }
    } catch (error) {
      // Erro de rede ou falha na comunicação com a API
      _showFeedbackMessage(
        'Erro de conexão. Verifique sua internet.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showFeedbackMessage(String message, {bool isError = false}) {
    if (!mounted) return; // Garante que o widget ainda está na tela
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFe41d31) : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFe41d31);
    const textFieldColor = Color(0xFF1a1a1a);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Color(0xFF9c0707)],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 32.0,
                right: 32.0,
                top: 32.0,
                bottom: 250.0, // Adiciona espaço para o footer
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Image.asset(
                        'assets/NETAIO/img/logo.png',
                        width: 250,
                        height: 180,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.fastfood,
                            size: 100,
                            color: Colors.white,
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: textFieldColor,
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        // 3. ADICIONADO: Ao pressionar 'Enter' (ou 'Next'), pula para o campo de senha
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          FocusScope.of(
                            context,
                          ).requestFocus(_passwordFocusNode);
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        // 4. ADICIONADO: Associa o nó de foco
                        focusNode: _passwordFocusNode,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Senha',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: textFieldColor,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        // 5. ADICIONADO: Ao pressionar 'Enter' (ou 'Done'), chama a função _login
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) {
                          if (!_isLoading) {
                            _login();
                          }
                        },
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        // Mostra o loading no botão
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : _login, // Desativa o botão durante o loading
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          'Não tem conta? Registre-se',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: const Color(0xFF1a1a1a),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quem somos:',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Uma lanchonete que prioriza o sabor e valoriza a sua experiência com a comida.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nos encontramos em:',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Astorga/PR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Redes sociais',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _showFeedbackMessage(
                          'Instagram: @bull_dogs_lanches',
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.camera_alt, color: Color(0xFFe41d31)),
                            SizedBox(width: 4),
                            Text(
                              '@bull_dogs_lanches',
                              style: TextStyle(color: Color(0xFFe41d31)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () =>
                            _showFeedbackMessage('WhatsApp: (44) 9976-5116'),
                        child: const Row(
                          children: [
                            Icon(Icons.phone, color: Color(0xFFe41d31)),
                            SizedBox(width: 4),
                            Text(
                              '(44) 9976-5116',
                              style: TextStyle(color: Color(0xFFe41d31)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const Text(
                    '© 2025 Bull Dog Lanches. Todos os direitos reservados.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
