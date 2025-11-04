import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

/// Camada de serviço responsável pela comunicação direta com a API
/// do Oracle APEX.
///
/// Contém os métodos estáticos para realizar as chamadas HTTP (GET, POST, etc.)
/// e desserializar as respostas JSON.
class ApiService {
  /// URL base para todos os endpoints da API no Oracle APEX.
  static const String baseUrl = 'https://oracleapex.com/ords/bulldog/api';

  /// Busca a lista de produtos da API.
  ///
  /// Realiza uma chamada HTTP GET para o endpoint '/produtos' e
  /// desserializa a resposta JSON usando o modelo [ApiResponse].
  static Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/produtos'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Decodifica a resposta JSON
        final jsonData = json.decode(response.body);
        // Usa o modelo ApiResponse para analisar o JSON
        final apiResponse = ApiResponse.fromJson(jsonData);
        // Retorna apenas a lista de 'items' (produtos)
        return apiResponse.items;
      } else {
        // Lança um erro se a API retornar um status inesperado
        throw Exception('Falha ao carregar produtos: ${response.statusCode}');
      }
    } catch (e) {
      // Lança um erro genérico em caso de falha de rede (ex: sem internet)
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Retorna uma lista estática (mockada) de adicionais.
  ///
  /// (Esta função será substituída por uma chamada de API no futuro,
  /// quando o endpoint de adicionais estiver pronto no APEX).
  static List<Additional> getAdditionals() {
    // Mantendo os adicionais estáticos por enquanto
    return [
      Additional(name: 'Burguer', price: 6.00),
      Additional(name: 'Bacon', price: 6.00),
      Additional(name: 'Frango', price: 5.00),
      Additional(name: 'Queijo', price: 3.00),
      Additional(name: 'Salsicha', price: 2.00),
      Additional(name: 'Alface', price: 2.00),
      Additional(name: 'Molho extra', price: 1.50),
      Additional(name: 'Catupiry', price: 5.00),
      Additional(name: 'Cheddar', price: 5.00),
    ];
  }

  // TODO: Adicionar aqui as futuras funções de API
  //
  // static Future<void> createProduct(Map<String, dynamic> productData) async {
  //   final response = await http.post(...);
  // }
  //
  // static Future<void> updateProduct(int id, Map<String, dynamic> productData) async {
  //   final response = await http.put(...);
  // }
}
