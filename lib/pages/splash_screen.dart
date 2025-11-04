import 'dart:async';
import 'package:flutter/material.dart';
// O import da login_page foi removido pois a
// navegação para ela é feita via PageRouteBuilder
// import 'login_page.dart';

/// Tela de Abertura (Splash Screen) animada.
///
/// Exibe a logo com um efeito de "fade-in" e um gradiente
/// de fundo animado ("subindo") por alguns segundos antes de
/// navegar para a [LoginScreen].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// Usa [SingleTickerProviderStateMixin] para fornecer o 'vsync'
/// necessário para o [AnimationController].
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// Controlador principal para todas as animações desta tela.
  late AnimationController _animationController;

  /// Animação para a cor intermediária do gradiente (Preto -> Vermelho Escuro).
  late Animation<Color?> _colorAnimationMid;

  /// Animação para a cor final do gradiente (Preto -> Vermelho Claro).
  late Animation<Color?> _colorAnimationEnd;

  /// Animação para a opacidade (fade-in) da logo e do [CircularProgressIndicator].
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    /// Define a duração total da animação da splash screen.
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 2 segundos
    );

    /// Define as cores de início e fim da animação do gradiente.
    /// Usamos um ponto intermediário (midRedColor) para suavizar
    /// a transição e evitar o "color banding" (faixas de cor).
    final redColor = const Color(0xFF9c0707);
    final midRedColor = const Color(0xFF4E0303); // Ponto intermediário

    _colorAnimationMid = ColorTween(
      begin: Colors.black,
      end: midRedColor,
    ).animate(_animationController);

    _colorAnimationEnd = ColorTween(
      begin: Colors.black,
      end: redColor,
    ).animate(_animationController);

    /// Define a animação de opacidade (fade-in).
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    /// Inicia todas as animações.
    _animationController.forward();

    /// Agenda a navegação para a próxima tela.
    _navigateToLogin();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Navega para a [LoginScreen] após um tempo determinado.
  void _navigateToLogin() {
    /// Aguarda um tempo (2.5s) maior que a animação (2s)
    /// para garantir que a animação da splash termine.
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        /// Navega para a [LoginScreen] (que tem sua própria animação de fade-in)
        /// e remove a [SplashScreen] da pilha de navegação.
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /// [AnimatedBuilder] reconstrói o widget a cada "tick" da animação,
    /// permitindo a animação fluida do gradiente.
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            /// O gradiente de 3 cores animado.
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  _colorAnimationMid.value!, // Cor do meio (animada)
                  _colorAnimationEnd.value!, // Cor do fim (animada)
                ],
                stops: const [0.0, 0.5, 1.0], // Distribuição das cores
              ),
            ),

            /// [FadeTransition] aplica a animação de opacidade
            /// ao conteúdo da tela (logo e loading).
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/NETAIO/img/logo.png', // Caminho da logo
                      width: 280,
                      height: 210,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.fastfood,
                          size: 100,
                          color: Colors.white,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
