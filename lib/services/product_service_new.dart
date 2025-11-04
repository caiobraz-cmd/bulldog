import '../models/product.dart';
import 'api_service.dart';

/// Camada de serviço (lógica de negócios) para gerenciar os produtos.
///
/// Esta classe age como um intermediário entre a UI (as telas)
/// e a camada de dados ([ApiService]). Isso permite adicionar
/// lógica extra, como o "fallback" (plano B) de dados estáticos.
class ProductService {
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
      // Isso é excelente para testes e para a apresentação.
      print('API falhou, usando dados de fallback: $e');
      return _getFallbackProducts();
    }
  }

  /// Retorna a lista de adicionais (atualmente estática).
  static List<Additional> getAdditionals() {
    return ApiService.getAdditionals();
  }

  /// Retorna uma lista estática de produtos para "fallback".
  /// Usado quando a API [ApiService.getProducts] falha.
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
