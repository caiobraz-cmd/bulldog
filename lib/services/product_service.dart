import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'api_service.dart';

class ProductService {
  static const String baseUrl = 'https://oracleapex.com/ords/bulldog/api';

  static Future<List<Product>> getAllProducts() async {
    try {
      return await ApiService.getProducts();
    } catch (e) {
      // Fallback para dados estáticos em caso de erro na API
      return _getFallbackProducts();
    }
  }

  static List<Additional> getAdditionals() {
    return ApiService.getAdditionals();
  }

  // Criar novo produto
  static Future<Product> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/produtos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'ds_nome': productData['name'],
          'preco': productData['price'],
          'ingredientes': productData['description'],
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return Product.fromJson(jsonData);
      } else {
        throw Exception('Falha ao criar produto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao criar produto: $e');
    }
  }

  // Atualizar produto existente
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
        return Product.fromJson(jsonData);
      } else {
        throw Exception('Falha ao atualizar produto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar produto: $e');
    }
  }

  // Deletar produto
  static Future<void> deleteProduct(int productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/produtos/$productId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao deletar produto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar produto: $e');
    }
  }

  // Produtos de fallback caso a API não funcione
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
