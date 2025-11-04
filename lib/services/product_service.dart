import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'api_service.dart';

/// Camada de serviço (lógica de negócios) para gerenciar os produtos.
///
/// Esta classe age como um intermediário entre a UI (as telas)
/// e a camada de dados ([ApiService] ou chamadas http diretas).
///
/// Ela contém a lógica para buscar, criar, atualizar e deletar produtos,
/// além de fornecer dados de "fallback" (plano B) caso a API falhe.
class ProductService {
  /// URL base para os endpoints de produtos (para CUD - Create, Update, Delete).
  static const String baseUrl = 'https://oracleapex.com/ords/bulldog/api';

  /// Busca todos os produtos.
  ///
  /// Tenta buscar os produtos da [ApiService]. Se a chamada falhar
  /// (ex: erro de rede, API offline), ele retorna uma lista de produtos
  /// estáticos ([_getFallbackProducts]) para que o app continue funcionando.
  static Future<List<Product>> getAllProducts() async {
    try {
      // Tenta buscar da API
      return await ApiService.getProducts();
    } catch (e) {
      // Se a API falhar, retorna os dados estáticos de "fallback".
      print('API de getProducts falhou, usando dados de fallback: $e');
      return _getFallbackProducts();
    }
  }

  /// Retorna a lista de adicionais (atualmente estática).
  static List<Additional> getAdditionals() {
    return ApiService.getAdditionals();
  }

  /// Cria um novo produto no banco de dados via API.
  ///
  /// Envia os [productData] (um mapa) para o endpoint '/produtos' via POST.
  /// A API do APEX deve ser configurada para mapear 'ds_nome', 'preco', etc.
  static Future<Product> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/produtos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          // Mapeia os nomes do app (ex: 'name') para os nomes da API (ex: 'ds_nome')
          'ds_nome': productData['name'],
          'preco': productData['price'],
          'ingredientes': productData['description'],
          // TODO: O 'imagePath' não está sendo enviado?
        }),
      );

      // 201 (Created) é a resposta padrão para um POST bem-sucedido
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return Product.fromJson(jsonData); // Retorna o produto criado
      } else {
        throw Exception('Falha ao criar produto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao criar produto: $e');
    }
  }

  /// Atualiza um produto existente no banco de dados via API.
  ///
  /// Envia os [productData] para o endpoint '/produtos/[productId]' via PUT.
  static Future<Product> updateProduct(
    int productId,
    Map<String, dynamic> productData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/produtos/$productId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'ds_nome': productData['name'],
          'preco': productData['price'],
          'ingredientes': productData['description'],
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Product.fromJson(jsonData); // Retorna o produto atualizado
      } else {
        throw Exception('Falha ao atualizar produto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar produto: $e');
    }
  }

  /// Deleta um produto do banco de dados via API.
  ///
  /// Realiza uma chamada DELETE para o endpoint '/produtos/[productId]'.
  static Future<void> deleteProduct(int productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/produtos/$productId'),
        headers: {'Content-Type': 'application/json'},
      );

      // 200 (OK) ou 204 (No Content) são respostas de sucesso para DELETE
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao deletar produto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar produto: $e');
    }
  }

  /// Retorna uma lista estática de produtos para "fallback".
  /// Usado quando a API [getAllProducts] falha.
  static List<Product> _getFallbackProducts() {
    return [
      Product(
        seqId: 1,
        name: 'Dog Simples',
        price: 15.00,
        ingredients:
            'Pão, Salsicha, Tomate, Molho especial, Ketchup e Mostarda',
      ),
      Product(
        seqId: 2,
        name: 'Dog Duplo',
        price: 17.00,
        ingredients:
            'Pão, 2 Salsichas, Tomate, Molho especial, Ketchup e Mostarda',
      ),
    ];
  }
}
