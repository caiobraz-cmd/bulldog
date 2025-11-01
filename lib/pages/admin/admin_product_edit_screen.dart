import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/product_service.dart'; // Agora este import será usado

class AdminProductEditScreen extends StatefulWidget {
  final Product?
  product; // 'null' se for para criar, ou o produto se for para editar

  const AdminProductEditScreen({super.key, this.product});

  @override
  State<AdminProductEditScreen> createState() => _AdminProductEditScreenState();
}

class _AdminProductEditScreenState extends State<AdminProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imagePathController;

  bool _isEditing = false;
  String _appBarTitle = 'Novo Produto';

  // 1. ADICIONADO ESTADO DE CARREGAMENTO
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _imagePathController = TextEditingController();

    if (widget.product != null) {
      _isEditing = true;
      _appBarTitle = 'Editar Produto';
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _imagePathController.text = widget.product!.imagePath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }

  // 2. FUNÇÃO DE SALVAR AGORA É 'async'
  Future<void> _saveForm() async {
    // Valida o formulário
    if (!(_formKey.currentState?.validate() ?? false)) {
      return; // Se o formulário for inválido, não faz nada
    }

    // Ativa o loading
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Coleta os dados dos campos
      final name = _nameController.text;
      final description = _descriptionController.text;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final imagePath = _imagePathController.text;

      // 2. Cria um novo mapa de dados do produto
      // (Seu product.dart precisa de um método 'toJson' ou um construtor que aceite um 'id')
      // Por enquanto, vamos criar um mapa simples
      final productData = {
        'name': name,
        'description': description,
        'price': price,
        'imagePath': imagePath,
        // TODO: Você precisará adaptar isso ao seu modelo
      };

      // 3. CHAMA O SERVICE
      if (_isEditing) {
        // Lógica para ATUALIZAR
        // (Assumindo que seu 'updateProduct' precisa do ID e dos dados)
        final productId =
            widget.product!.seqId; // Assumindo que seu ID se chama 'seqId'
        await ProductService.updateProduct(productId, productData);
      } else {
        // Lógica para CRIAR
        await ProductService.createProduct(productData);
      }

      // 4. Mostra uma mensagem de sucesso (se tudo deu certo)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Produto "${name}" salvo com sucesso!'),
            backgroundColor: Colors.green[700],
          ),
        );
        // 5. Retorna para a tela da lista
        Navigator.of(context).pop();
      }
    } catch (e) {
      // 6. Tratamento de erro
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar produto: $e'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      }
    } finally {
      // Desativa o loading, mesmo se der erro
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Função de Validação (Simples)
  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'O campo "$fieldName" não pode estar vazio.';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (_validateNotEmpty(value, 'Preço') != null) {
      return _validateNotEmpty(value, 'Preço');
    }
    if (double.tryParse(value!) == null) {
      return 'Por favor, insira um número válido (ex: 15.50)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFe41d31);
    const textFieldColor = Color(0xFF2e2d2d); // Um pouco mais claro

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
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
            // Permite rolar em telas pequenas
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ), // Limita a largura na Web
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      // --- CAMPO NOME ---
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration(
                          'Nome do Produto',
                          Icons.fastfood,
                          textFieldColor,
                        ),
                        validator: (value) =>
                            _validateNotEmpty(value, 'Nome do Produto'),
                        enabled:
                            !_isLoading, // Desativa o campo durante o loading
                      ),
                      const SizedBox(height: 20),

                      // --- CAMPO DESCRIÇÃO ---
                      TextFormField(
                        controller: _descriptionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration(
                          'Descrição',
                          Icons.description,
                          textFieldColor,
                        ),
                        maxLines: 3,
                        validator: (value) =>
                            _validateNotEmpty(value, 'Descrição'),
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 20),

                      // --- CAMPO PREÇO ---
                      TextFormField(
                        controller: _priceController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration(
                          'Preço (ex: 17.00)',
                          Icons.attach_money,
                          textFieldColor,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: _validatePrice,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 20),

                      // --- CAMPO CAMINHO DA IMAGEM ---
                      TextFormField(
                        controller: _imagePathController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration(
                          'Caminho da Imagem (ex: assets/img/dog_bacon.png)',
                          Icons.image,
                          textFieldColor,
                        ),
                        validator: (value) =>
                            _validateNotEmpty(value, 'Caminho da Imagem'),
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 40),

                      // --- BOTÃO SALVAR ---
                      ElevatedButton(
                        // 3. BOTÃO DESATIVADO DURANTE O LOADING
                        onPressed: _isLoading ? null : _saveForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // 4. MOSTRANDO O LOADING
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text('SALVAR PRODUTO'),
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

  // Helper para criar a decoração dos campos de texto (evita repetição)
  InputDecoration _buildInputDecoration(
    String hint,
    IconData icon,
    Color fillColor,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
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
