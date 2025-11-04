import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Tela de Registro de Novo Usuário.
///
/// Permite que um novo usuário crie uma conta (username e password)
/// que é enviada para a API do Oracle APEX.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  /// Tenta registrar um novo usuário na API.
  Future<void> _register() async {
    // Validação de campos vazios (usando .trim() para segurança)
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showFeedback('Preencha todos os campos.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse(
      'https://oracleapex.com/ords/bulldog/api/register-user',
    );

    try {
      // Realiza a chamada POST para a API de registro.
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      if (!mounted) return; // Verifica se o widget ainda está na tela

      final responseData = json.decode(response.body);

      // A API de registro retorna 200 em caso de sucesso
      if (response.statusCode == 200) {
        // Mostra a mensagem de sucesso (ex: "Usuário criado")
        _showFeedback(responseData['message'] ?? 'Registro bem-sucedido!');
        // Retorna para a tela de login
        Navigator.pop(context);
      } else {
        // Mostra a mensagem de erro (ex: "Usuário já existe")
        _showFeedback(
          responseData['message'] ?? 'Erro ao registrar.',
          isError: true,
        );
      }
    } catch (e) {
      // Erro de rede/conexão
      _showFeedback('Erro de conexão. Tente novamente.', isError: true);
    } finally {
      // Garante que o loading seja desativado
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Exibe uma SnackBar de feedback (sucesso ou erro) para o usuário.
  void _showFeedback(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFe41d31) : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFe41d31);
    const textFieldColor = Color(0xFF1a1a1a);

    return Scaffold(
      // Usamos um Stack para sobrepor o footer fixo
      // sobre o conteúdo rolável.
      body: Stack(
        children: [
          // Fundo com gradiente
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
            // Alinha o formulário no topo central
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                // Limita a largura máxima em telas maiores
                constraints: const BoxConstraints(maxWidth: 450),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      // Logo
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
                      const SizedBox(height: 30),
                      // Campo de Usuário/Email
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Usuário (ou E-mail)',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: textFieldColor,
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
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
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Botão de Registrar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          // Mostra loading ou texto
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
                                  'REGISTRAR',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Botão para voltar ao Login
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Já tem uma conta? Faça login',
                          style: TextStyle(
                            color: Colors.white70,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Footer Fixo
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
                        onTap: () =>
                            _showFeedback('Instagram: @bull_dogs_lanches'),
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
                        onTap: () => _showFeedback('WhatsApp: (44) 9976-5116'),
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
