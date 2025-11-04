import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Models e Providers
import 'models/product.dart';
import 'providers/cart_provider.dart';

// Telas do Cliente
import 'pages/splash_screen.dart';
import 'pages/login_page.dart';
import 'pages/register_screen.dart';
import 'pages/home_page.dart';
import 'pages/checkout_screen.dart';
import 'pages/payment_screen.dart';
import 'pages/review_order_screen.dart'; // Import da tela de Revisão

// Telas do Admin
import 'pages/admin/admin_dashboard_screen.dart';
import 'pages/admin/admin_product_list_screen.dart';
import 'pages/admin/admin_reports_screen.dart';
import 'pages/admin/admin_product_edit_screen.dart';

/// Ponto de entrada principal da aplicação.
///
/// O [ChangeNotifierProvider] é "injetado" acima do [MyApp] para garantir
/// que o [CartProvider] (o carrinho de compras) esteja disponível
/// para todas as telas do aplicativo (ex: HomePage, CheckoutScreen).
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

/// O widget raiz da aplicação.
///
/// Responsável por configurar o [MaterialApp], incluindo o tema global
/// (cores, fontes) e o sistema de rotas (navegação por nomes).
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definição do tema de cores padrão do app
    const primaryColor = Color(0xFFe41d31);
    const darkBackground = Color(0xFF121212);
    const cardColor = Color(0xFF1a1a1a);

    return MaterialApp(
      title: 'Bull Dogs Lanches',
      debugShowCheckedModeBanner: false,

      // --- Tema Global ---
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: darkBackground,
        // Esquema de cores principal
        colorScheme: const ColorScheme.dark(
          primary: primaryColor,
          secondary: primaryColor,
          background: darkBackground,
          surface: cardColor, // Cor padrão para Cards, AppBars, etc.
        ),
        // Tema de texto padrão (Google Fonts: Poppins)
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
        // Tema padrão para AppBars
        appBarTheme: AppBarTheme(
          backgroundColor: cardColor,
          elevation: 0,
          foregroundColor: Colors.white, // Cor dos ícones (ex: seta de voltar)
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white, // Cor do texto do título
          ),
        ),
        // Tema padrão para ElevatedButtons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      // --- Fim do Tema ---

      /// Rota inicial do app.
      /// Aponta para a [SplashScreen] (tela de abertura).
      initialRoute: '/',

      /// Mapa de todas as rotas nomeadas da aplicação.
      /// Usar rotas nomeadas (ex: '/login') desacopla a navegação
      /// das telas, facilitando a manutenção.
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomePage(),
        '/checkout': (context) => const CheckoutScreen(),

        /// Rota para a tela de Revisão.
        /// Ela extrai os argumentos (endereço) passados pelo [Navigator.pushNamed].
        '/review': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return ReviewOrderScreen(
            address: args['address']!,
            addressObservation: args['addressObservation']!,
          );
        },
        '/payment': (context) => const PaymentScreen(),

        // Rotas do Admin
        '/admin': (context) => const AdminDashboardScreen(),
        '/admin/products': (context) => const AdminProductListScreen(),
        '/admin/reports': (context) => const AdminReportsScreen(),

        /// Rota para a tela de Criar/Editar Produto.
        /// Ela extrai o [Product] (ou null) passado como argumento.
        '/admin/product/edit': (context) {
          final product =
              ModalRoute.of(context)!.settings.arguments as Product?;
          return AdminProductEditScreen(product: product);
        },
      },
    );
  }
}
