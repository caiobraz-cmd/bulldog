import '../models/product.dart';
import 'api_service.dart';

class ProductService {
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

  // Produtos de fallback caso a API não funcione
  static List<Product> _getFallbackProducts() {
    return [
      Product(
        seqId: 1,
        name: 'Dog Simples',
        price: 15.00,
        ingredients: 'Pão, Salsicha, Tomate, Molho especial, Ketchup e Mostarda',
      ),
      Product(
        seqId: 2,
        name: 'Dog Duplo',
        price: 17.00,
        ingredients: 'Pão, 2 Salsichas, Tomate, Molho especial, Ketchup e Mostarda',
      ),
    ];
  }
}
