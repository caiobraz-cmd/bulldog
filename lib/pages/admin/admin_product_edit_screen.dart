import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/product_service.dart'; // Importado para a lógica de 'saveForm'

/// Tela de Formulário para Criar ou Editar um [Product].
///
/// Esta tela é [StatefulWidget] pois precisa gerenciar o estado
/// dos campos de texto e o estado de carregamento (_isLoading).
///
/// Ela recebe um [product] opcional como argumento.
/// - Se [product] for `null`, a tela opera em modo "Criar Novo Produto".
/// - Se [product] for fornecido, a tela opera em modo "Editar Produto".
class AdminProductEditScreen extends StatefulWidget {
  /// O produto existente a ser editado.
  /// Se `null`, a tela entra em modo de criação.
  final Product? product;

  const AdminProductEditScreen({super.key, this.product});

  @override
  State<AdminProductEditScreen> createState() => _AdminProductEditScreenState();
}

class _AdminProductEditScreenState extends State<AdminProductEditScreen> {
  /// Chave global para o [Form] (usada para validação).
  final _formKey = GlobalKey<FormState>();

  /// Controladores para os campos de texto do formulário.
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imagePathController;

  /// Flag para controlar se a tela está em modo de edição.
  bool _isEditing = false;

  /// Título dinâmico para a [AppBar] ("Novo Produto" ou "Editar Produto").
  String _appBarTitle = 'Novo Produto';

  /// Controla o estado de carregamento (ex: ao salvar) para desabilitar
  /// campos e mostrar um indicador no botão.
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Inicializa os controladores de texto.
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _imagePathController = TextEditingController();

    // Verifica se um produto foi passado via 'widget.product' (modo de edição).
    if (widget.product != null) {
      _isEditing = true;
      _appBarTitle = 'Editar Produto';

      // Preenche os campos do formulário com os dados do produto existente.
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _imagePathController.text = widget.product!.imagePath;
    }
  }

  @override
  void dispose() {
    // Descarta os controladores para evitar memory leaks.
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }

  /// Função assíncrona para validar e salvar os dados do formulário.
  Future<void> _saveForm() async {
    // 1. Valida o formulário usando a _formKey.
    if (!(_formKey.currentState?.validate() ?? false)) {
      return; // Se o formulário for inválido, interrompe a execução.
    }

    // 2. Ativa o estado de carregamento (mostra o loading no botão).
    setState(() {
      _isLoading = true;
    });

    try {
      // 3. Coleta os dados "limpos" dos controladores.
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final imagePath = _imagePathController.text.trim();

      // 4. Prepara os dados para a API (placeholder).
      // (O 'product.dart' precisa de um 'toJson' ou um construtor
      // que aceite um 'id' para a lógica de atualização).
      final productData = {
        'name': name,
        'description': description,
        'price': price,
        'imagePath': imagePath,
        // TODO: Adaptar este mapa ao modelo de dados exato da API.
      };

      // 5. Chama o Service (Lógica de API pendente)
      if (_isEditing) {
        // Lógica para ATUALIZAR um produto existente.
        final productId = widget.product!.seqId; // Assume que o ID é 'seqId'

        // TODO: Descomentar quando ProductService.updateProduct estiver pronto.
        // await ProductService.updateProduct(productId, productData);
        print('Simulando atualização do produto: $productId');
      } else {
        // Lógica para CRIAR um novo produto.

        // TODO: Descomentar quando ProductService.createProduct estiver pronto.
        // await ProductService.createProduct(productData);
        print('Simulando criação de novo produto');
      }

      // 6. Feedback de sucesso (após o 'await' da API)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Produto "$name" salvo com sucesso! (Simulação)'),
            backgroundColor: Colors.green[700],
          ),
        );
        // 7. Retorna para a tela anterior (a lista de produtos)
        Navigator.of(context).pop();
      }
    } catch (e) {
      // 8. Tratamento de erro (ex: falha de rede)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar produto: $e'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      }
    } finally {
      // 9. Desativa o estado de carregamento, mesmo se der erro.
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Helper de validação para campos que não podem ser vazios.
  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'O campo "$fieldName" não pode estar vazio.';
    }
    return null;
  }

  /// Helper de validação específico para o campo de preço.
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
    const textFieldColor = Color(0xFF2e2d2d); // Tom de cinza para os campos

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle), // Título dinâmico
        backgroundColor: const Color(0xFF1a1a1a),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Gradiente padrão do app
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
              // Limita a largura do formulário na web/tablet
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      // --- Campo Nome ---
                      TextFormField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration(
                          'Nome do Produto',
                          'Ex: Dog Bacon',
                          Icons.fastfood,
                          textFieldColor,
                        ),
                        validator: (value) =>
                            _validateNotEmpty(value, 'Nome do Produto'),
                        enabled:
                            !_isLoading, // Desabilita o campo durante o load
                      ),
                      const SizedBox(height: 20),

                      // --- Campo Descrição ---
                      TextFormField(
                        controller: _descriptionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration(
                          'Descrição',
                          'Ex: Pão, salsicha, bacon...',
                          Icons.description,
                          textFieldColor,
                        ),
                        maxLines: 3,
                        validator: (value) =>
                            _validateNotEmpty(value, 'Descrição'),
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 20),

                      // --- Campo Preço ---
                      TextFormField(
                        controller: _priceController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration(
                          'Preço',
                          'Ex: 17.00',
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

                      // --- Campo Caminho da Imagem ---
                      TextFormField(
                        controller: _imagePathController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _buildInputDecoration(
                          'Caminho da Imagem',
                          'Ex: assets/img/dog_bacon.png',
                          Icons.image,
                          textFieldColor,
                        ),
                        validator: (value) =>
                            _validateNotEmpty(value, 'Caminho da Imagem'),
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 40),

                      // --- Botão Salvar ---
                      ElevatedButton(
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
                        // Mostra o loading ou o texto
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

  /// Helper para construir a decoração padrão dos [TextFormField] desta tela.
  /// (Trocado de 'labelText' para 'hintText' conforme solicitado).
  InputDecoration _buildInputDecoration(
    String label, // Agora usado como hint
    String hint,
    IconData icon,
    Color fillColor,
  ) {
    return InputDecoration(
      labelText: label, // O 'labelText' flutua
      labelStyle: TextStyle(color: Colors.grey[400]),
      hintText: hint, // O 'hintText' fica dentro do campo
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
