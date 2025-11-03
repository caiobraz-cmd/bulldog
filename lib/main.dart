import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // 1. IMPORT DO PROVIDER

// Models e Providers
import 'models/product.dart';
import 'providers/cart_provider.dart'; // 2. IMPORT DO CART_PROVIDER

// Telas do Cliente
import 'pages/splash_screen.dart'; // 3. IMPORT DA TELA SPLASH
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

void main() {
  // 4. ENVOLVER A APLICAÇÃO COM O PROVIDER (ESSENCIAL)
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
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
          background: darkBackground,
          surface: cardColor, // Cor dos cards
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
        // 5. CORREÇÃO DA COR DO TEXTO DA APPBAR (branco)
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

      // 6. ROTA INICIAL MUDADA PARA A SPLASH
      initialRoute: '/',

      // Define todas as rotas do aplicativo
      routes: {
        '/': (context) => const SplashScreen(), // 7. ROTA DA SPLASH
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomePage(),
        '/checkout': (context) => const CheckoutScreen(),
        '/review': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return ReviewOrderScreen(
            address: args['address']!,
            addressObservation: args['addressObservation']!,
          );
        },
        '/payment': (context) => const PaymentScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/admin/products': (context) => const AdminProductListScreen(),
        '/admin/reports': (context) => const AdminReportsScreen(),
        '/admin/product/edit': (context) {
          final product =
              ModalRoute.of(context)!.settings.arguments as Product?;
          return AdminProductEditScreen(product: product);
        },
      },
    );
  }
}
