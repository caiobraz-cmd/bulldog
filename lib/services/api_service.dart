import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://oracleapex.com/ords/bulldog/api';

  static Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/produtos'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonData);
        return apiResponse.items;
      } else {
        throw Exception('Falha ao carregar produtos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

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
}
