import 'dart:async';
import 'package:flutter/material.dart';
// 1. O IMPORT DA LOGIN_PAGE NÃO É MAIS NECESSÁRIO AQUI
// import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimationMid;
  late Animation<Color?> _colorAnimationEnd;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Duração total da animação da splash
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 2 segundos
    );

    // Animação do Gradiente (para corrigir o "banding")
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

    // Animação da Logo (Fade-in)
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
    _navigateToLogin();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    // 3. TIMER DE ESPERA
    // A animação da splash dura 2s.
    // Vamos esperar 2.5s (2500ms) para garantir que ela termine
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        // 4. MUDANÇA: Navegação instantânea "de uma vez"
        // Removemos o PageRouteBuilder
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 5. VOLTAMOS A USAR O AnimatedBuilder
    // para mostrar a animação do gradiente subindo
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            // 6. O GRADIENTE DE 3 CORES (para suavizar)
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black,
                  _colorAnimationMid.value!, // Cor do meio animada
                  _colorAnimationEnd.value!, // Cor do fim animada
                ],
                stops: const [0.0, 0.5, 1.0], // Distribuição
              ),
            ),
            // 7. O FADE-IN DA LOGO
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/NETAIO/img/logo.png', // O caminho da sua logo
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
