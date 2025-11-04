import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'api_service.dart';

class ProductService {
  static const String baseUrl = 'https://oracleapex.com/ords/bulldog/api';

  /// 🔹 Buscar todos os produtos
  static Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/produtos'));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        // 👇 APEX retorna {"items": [...]}, tratamos isso
        final List<dynamic> jsonList =
            decoded is Map && decoded.containsKey('items')
            ? decoded['items']
            : (decoded as List<dynamic>);

        return jsonList.map((jsonItem) {
          return Product(
            seqId: jsonItem['seq_id'] ?? 0,
            name: jsonItem['ds_nome'] ?? 'Sem nome',
            price: (jsonItem['preco'] ?? 0).toDouble(),
            ingredients: jsonItem['ds_descricao'] ?? '',
            imageBase64: jsonItem['imagem'], // pode ser null
          );
        }).toList();
      } else {
        throw Exception(
          'Falha ao carregar produtos: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      print('❌ Erro ao carregar produtos: $e');
      return _getFallbackProducts();
    }
  }

  /// 🔹 Buscar adicionais
  static List<Additional> getAdditionals() {
    return ApiService.getAdditionals();
  }

  /// 🔹 Criar novo produto (tratando ausência de JSON na resposta)
  static Future<Product> createProduct(Map<String, dynamic> productData) async {
    try {
      String? base64Image;

      // Converte imagem dependendo da plataforma
      if (productData['image'] != null) {
        if (kIsWeb && productData['image'] is Uint8List) {
          base64Image = base64Encode(productData['image']);
        } else if (productData['image'] is File) {
          final bytes = await (productData['image'] as File).readAsBytes();
          base64Image = base64Encode(bytes);
        }
      }

      final body = jsonEncode({
        'ds_nome': productData['name'],
        'preco': productData['price'],
        'ds_descricao': productData['description'],
        'imagem': base64Image, // ok se null
      });

      final response = await http.post(
        Uri.parse('$baseUrl/produtos'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body);
          return Product.fromJson(jsonData);
        } else {
          return Product(
            seqId: 0,
            name: productData['name'],
            price: productData['price'],
            ingredients: productData['description'] ?? '',
            imageBase64: base64Image,
          );
        }
      } else {
        throw Exception(
          'Falha ao criar produto: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao criar produto: $e');
    }
  }

  /// 🔹 Atualizar produto existente (tratando resposta vazia)
  static Future<Product> updateProduct(
    int productId,
    Map<String, dynamic> productData,
  ) async {
    try {
      String? base64Image;

      if (productData['image'] != null) {
        if (kIsWeb && productData['image'] is Uint8List) {
          base64Image = base64Encode(productData['image']);
        } else if (productData['image'] is File) {
          final bytes = await (productData['image'] as File).readAsBytes();
          base64Image = base64Encode(bytes);
        }
      }

      final body = jsonEncode({
        'ds_nome': productData['name'],
        'preco': productData['price'],
        'ds_descricao': productData['description'],
        'imagem': base64Image,
      });

      final response = await http.put(
        Uri.parse('$baseUrl/produtos/$productId'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body);
          return Product.fromJson(jsonData);
        } else {
          return Product(
            seqId: productId,
            name: productData['name'],
            price: productData['price'],
            ingredients: productData['description'] ?? '',
            imageBase64: base64Image,
          );
        }
      } else {
        throw Exception(
          'Falha ao atualizar produto: ${response.statusCode}\n${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao atualizar produto: $e');
    }
  }

  /// 🔹 Deletar produto
  /// 🔹 "Deletar" produto (soft delete → SN_ATIVO = 'N')
  /// 🔹 Soft delete (desativar produto)
  static Future<void> deleteProduct(int productId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/produtos/$productId/desativar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({}), // 👈 corpo vazio para evitar erro 400
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Produto desativado: ${data['message']}');
      } else if (response.statusCode == 404) {
        throw Exception('Produto não encontrado.');
      } else {
        throw Exception(
          'Falha ao desativar produto: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erro ao desativar produto: $e');
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
