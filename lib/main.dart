import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Importações das telas (certifique-se de que os caminhos estão corretos)
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/checkout_screen.dart';
import 'pages/payment_screen.dart';
import 'pages/admin/admin_dashboard_screen.dart';
import 'pages/admin/admin_product_list_screen.dart';
import 'pages/admin/admin_reports_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definindo a cor primária (vermelho Bull Dogs)
    const Color primaryColor = Color(0xFFe41d31);
    // Definindo a cor de fundo principal (preto)
    const Color backgroundColor = Colors.black;

    return MaterialApp(
      title: 'Bull Dogs Lanches',
      debugShowCheckedModeBanner: false,

      // Configuração do Tema
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,

        // Define a fonte principal como Poppins
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),

        // Tema dos Botões
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),

        // Tema dos Campos de Texto
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2e2d2d),
          hintStyle: const TextStyle(color: Colors.grey),
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
        ),

        // Tema da AppBar (barra superior)
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1a1a1a), // Um cinza bem escuro
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),

      // Rota Inicial
      initialRoute: '/login',

      // Definição de todas as rotas do aplicativo
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
        '/checkout': (context) => const CheckoutScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/admin/products': (context) => const AdminProductListScreen(),
        '/admin/reports': (context) => const AdminReportsScreen(),
      },
    );
  }
}
