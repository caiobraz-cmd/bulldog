import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

/// Camada de serviço (lógica de negócios) para gerenciar os produtos.
///
/// Esta classe age como um intermediário entre a UI (as telas)
/// e a camada de dados ([ApiService]). Isso permite adicionar
/// lógica extra, como o "fallback" (plano B) de dados estáticos.
class ProductService {
  // 👉 Coloque aqui a URL correta do seu endpoint APEX
  static const String _baseUrl =
      'https://oracleapex.com/ords/bulldog/api/produtos';

  /// 🔹 Busca todos os produtos da API
  static Future<List<Product>> getAllProducts() async {
    try {
      final url = Uri.parse(_baseUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // ✅ APEX geralmente retorna os dados dentro de "items"
        final List<dynamic> data =
            decoded is Map && decoded.containsKey('items')
            ? decoded['items']
            : decoded;

        return data.map((item) {
          return Product(
            seqId: item['seq_id'] ?? 0,
            name: item['ds_nome'] ?? 'Sem nome',
            price: (item['preco'] ?? 0).toDouble(),
            ingredients: item['ds_descricao'] ?? '',
            imageBase64: item['imagem'] ?? '',
          );
        }).toList();
      } else {
        throw Exception('Erro ao buscar produtos: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erro ao carregar produtos: $e');
      return _getFallbackProducts();
    }
  }

  /// 🔹 Exemplo de método para atualizar (PUT)
  static Future<bool> updateProduct(Product product) async {
    try {
      final url = Uri.parse('$_baseUrl${product.seqId}');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ds_nome': product.name,
          'ds_descricao': product.ingredients,
          'preco': product.price,
          'imagem': product.imageBase64,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('❌ Erro ao atualizar produto: $e');
      return false;
    }
  }

  /// 🔹 Produtos de fallback (caso a API falhe)
  static List<Product> _getFallbackProducts() {
    return [
      Product(
        seqId: 1,
        name: 'Dog Simples',
        price: 15.00,
        ingredients:
            'Pão, Salsicha, Tomate, Molho especial, Ketchup e Mostarda',
        imageBase64: '',
      ),
      Product(
        seqId: 2,
        name: 'Dog Duplo',
        price: 17.00,
        ingredients:
            'Pão, 2 Salsichas, Tomate, Molho especial, Ketchup e Mostarda',
        imageBase64: '',
      ),
    ];
  }

  // TODO: Implementar as funções de Criar e Atualizar
  // que chamarão o ApiService.

  /// (Pendente) Envia um novo produto para a API.
  static Future<void> createProduct(Map<String, dynamic> productData) async {
    // TODO: Chamar o ApiService.createProduct(productData)
    print('Simulando a CRIAÇÃO do produto na API...');
    // await ApiService.createProduct(productData);
  }

  /// (Pendente) Envia dados atualizados de um produto para a API.
  static Future<void> updateProduct(
    int id,
    Map<String, dynamic> productData,
  ) async {
    // TODO: Chamar o ApiService.updateProduct(id, productData)
    print('Simulando a ATUALIZAÇÃO do produto $id na API...');
    // await ApiService.updateProduct(id, productData);
  }
}
