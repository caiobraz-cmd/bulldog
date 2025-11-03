import 'package:flutter/material.dart';

// Esta tela agora é um StatefulWidget para controlar os campos de texto
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Controladores para os campos
  final _addressController = TextEditingController();
  final _addressObservationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addressController.dispose();
    _addressObservationController.dispose();
    super.dispose();
  }

  void _goToReview() {
    // Valida o formulário
    if (_formKey.currentState?.validate() ?? false) {
      // Se válido, navega para a tela de revisão
      Navigator.of(context).pushNamed(
        '/review',
        arguments: {
          'address': _addressController.text,
          'addressObservation': _addressObservationController.text,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFe41d31);
    const textFieldColor = Color(0xFF2e2d2d);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Endereço de Entrega'),
        backgroundColor: const Color(0xFF1a1a1a),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF9c0707)],
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                // Adicionado um Form para validação
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Image.asset(
                          'assets/NETAIO/img/logo.png',
                          width: 250,
                          height: 180,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.home_work, // Ícone de endereço
                              size: 100,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _addressController,
                        decoration: _buildInputDecoration(
                          'Endereço*', // Marcado como obrigatório
                          'Digite seu endereço completo...',
                          Icons.home,
                          textFieldColor,
                        ),
                        style: const TextStyle(color: Colors.white),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, insira seu endereço.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _addressObservationController,
                        decoration: _buildInputDecoration(
                          'Observação do Endereço',
                          'Ex: Casa de esquina, portão azul...',
                          Icons.edit_note,
                          textFieldColor,
                        ),
                        style: const TextStyle(color: Colors.white),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _goToReview, // Chama a função
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Texto do botão atualizado
                        child: const Text('REVISAR PEDIDO'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper de decoração
  InputDecoration _buildInputDecoration(
    String label,
    String hint,
    IconData icon,
    Color fillColor,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[400]),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[600]),
      filled: true,
      fillColor: fillColor,
      prefixIcon: Icon(icon, color: Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFe41d31), width: 2),
      ),
    );
  }
}
