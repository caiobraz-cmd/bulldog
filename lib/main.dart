import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 1. IMPORT FALTANTE ADICIONADO AQUI
import 'models/product.dart';

// Telas do Cliente
import 'pages/login_page.dart';
import 'pages/register_screen.dart';
import 'pages/home_page.dart';
import 'pages/checkout_screen.dart';
import 'pages/payment_screen.dart';

// Telas do Admin
import 'pages/admin/admin_dashboard_screen.dart';
import 'pages/admin/admin_product_list_screen.dart';
import 'pages/admin/admin_reports_screen.dart';
import 'pages/admin/admin_product_edit_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFe41d31);
    const darkBackground = Color(0xFF121212);
    const cardColor = Color(0xFF1a1a1a);

    return MaterialApp(
      title: 'Bull Dogs Lanches',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: primaryColor,
          secondary: primaryColor,
          surface: cardColor, // Cor dos cards
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
        // AJUSTE FEITO AQUI
        appBarTheme: AppBarTheme(
          backgroundColor: cardColor,
          elevation: 0,
          foregroundColor: Colors.white, // Define a cor dos ícones (ex: seta)
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white, // Define a cor do texto do título
          ),
        ),
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

      // Define a tela de login como a inicial
      initialRoute: '/login',

      // Define todas as rotas do aplicativo
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomePage(),
        '/checkout': (context) => const CheckoutScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/admin/products': (context) => const AdminProductListScreen(),
        '/admin/reports': (context) => const AdminReportsScreen(),

        '/admin/product/edit': (context) {
          // Pega o argumento (produto) passado pela navegação
          // 2. AGORA ESTA LINHA FUNCIONA
          final product =
              ModalRoute.of(context)!.settings.arguments as Product?;
          return AdminProductEditScreen(product: product);
        },
      },
    );
  }
}
