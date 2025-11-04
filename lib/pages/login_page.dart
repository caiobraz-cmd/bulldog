import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Tela de Login
///
/// Responsável pela autenticação do usuário (cliente ou admin)
/// e pela navegação para a rota correspondente.
/// Esta tela também contém a animação de fade-in.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // Controladores para os campos de texto de email e senha.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Nó de foco para gerenciar a transição do campo de email para o de senha.
  final _passwordFocusNode = FocusNode();

  /// Controla o estado de carregamento (ex: durante a chamada da API).
  bool _isLoading = false;

  // --- Controladores de Animação para Fade-in ---

  /// Controlador principal para a animação de fade-in da tela.
  late AnimationController _fadeController;

  /// Animação de opacidade (de 0.0 a 1.0) controlada pelo [_fadeController].
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Configura e inicia a animação de fade-in da tela.
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // 2 segundos de fade-in
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);

    // Inicia a animação assim que a tela é construída.
    _fadeController.forward();
  }

  @override
  void dispose() {
    // É crucial descartar os controladores para evitar memory leaks.
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  /// Tenta autenticar o usuário contra a API.
  Future<void> _login() async {
    // Remove espaços em branco do início e fim das credenciais.
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // Validação de campos vazios.
    if (email.isEmpty || password.isEmpty) {
      _showFeedbackMessage(
        'Por favor, preencha e-mail e senha.',
        isError: true,
      );
      return;
    }

    // Ativa o indicador de carregamento.
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://oracleapex.com/ords/bulldog/api/login-user');

    try {
      // Realiza a chamada POST para a API de login.
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': email, 'password': password}),
      );

      // Verifica se o widget ainda está na tela após a chamada assíncrona.
      if (!mounted) return;

      final responseData = json.decode(response.body);

      // A API do APEX retorna 200 mesmo em falha,
      // então verificamos o campo 'status' dentro do JSON.
      if (response.statusCode == 200 && responseData['status'] == 'ok') {
        // SUCESSO: Autenticado.
        final String role = responseData['role'] ?? 'unknown';

        // Navega para a rota apropriada baseada na 'role'.
        switch (role) {
          case 'admin':
            Navigator.of(context).pushReplacementNamed('/admin');
            break;
          case 'cliente':
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          default:
            _showFeedbackMessage(
              'Erro: Tipo de usuário desconhecido.',
              isError: true,
            );
        }
      } else {
        // FALHA: Credenciais inválidas ou erro da API.
        final String message =
            responseData['message'] ?? 'Credenciais inválidas.';
        _showFeedbackMessage(message, isError: true);
      }
    } catch (error) {
      // Erro de Rede (ex: sem internet, DNS, timeout).
      _showFeedbackMessage('Erro de conexão: $error', isError: true);
    } finally {
      // Garante que o indicador de carregamento seja desativado,
      // mesmo se ocorrer um erro.
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Exibe uma SnackBar de feedback (sucesso ou erro) para o usuário.
  void _showFeedbackMessage(String message, {bool isError = false}) {
    if (!mounted) return;
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

    // A tela inteira é envolvida em um FadeTransition
    // para animar sua entrada.
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Scaffold(
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 32.0,
                  right: 32.0,
                  top: 32.0,
                  bottom: 250.0, // Espaço para o footer não cobrir o form
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
                        // Campo de Email
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
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) {
                            // Pula para o campo de senha ao pressionar 'Enter'
                            FocusScope.of(
                              context,
                            ).requestFocus(_passwordFocusNode);
                          },
                        ),
                        const SizedBox(height: 20),
                        // Campo de Senha
                        TextField(
                          controller: _passwordController,
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
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            // Chama a função de login ao pressionar 'Enter'
                            if (!_isLoading) {
                              _login();
                            }
                          },
                        ),
                        const SizedBox(height: 40),
                        // Botão de Login
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            // Mostra um CircularProgressIndicator
                            // ou o texto, baseado no estado _isLoading.
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
                        // Botão de navegação para a tela de Registro
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
            // Footer Fixo no final da tela
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
      ),
    );
  }
}
