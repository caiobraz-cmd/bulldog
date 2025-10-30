class Product {
  final int seqId;
  final String name;
  final double price;
  final String ingredients;

  Product({
    required this.seqId,
    required this.name,
    required this.price,
    required this.ingredients,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      seqId: json['seq_id'] as int,
      name: json['ds_nome'] as String,
      price: (json['preco'] as num).toDouble(),
      ingredients: json['ingredientes'] as String,
    );
  }

  String get id => seqId.toString();
  String get description => ingredients;

  // Para manter compatibilidade com o código existente
  String get imagePath {
    // Mapeamento simples baseado no nome do produto
    final normalizedName = name.toLowerCase();
    if (normalizedName.contains('dog simples')) {
      return 'assets/NETAIO/img/hotdogsimples.jpg';
    } else if (normalizedName.contains('dog duplo') &&
        !normalizedName.contains('bacon') &&
        !normalizedName.contains('frango')) {
      return 'assets/NETAIO/img/hotdogduplo.jpg';
    } else if (normalizedName.contains('bacon') &&
        normalizedName.contains('frango')) {
      return 'assets/NETAIO/img/simplesfrangobacon.jpg';
    } else if (normalizedName.contains('bacon')) {
      return 'assets/NETAIO/img/simplesbacon.jpg';
    } else if (normalizedName.contains('frango')) {
      return 'assets/NETAIO/img/simplesfrango.jpg';
    } else if (normalizedName.contains('burguer')) {
      return 'assets/NETAIO/img/burguer.jpg';
    }
    // Imagem padrão
    return 'assets/NETAIO/img/hotdogsimples.jpg';
  }

  ProductType get type {
    return name.toLowerCase().contains('burguer')
        ? ProductType.burger
        : ProductType.hotdog;
  }
}

enum ProductType { hotdog, burger }

class CartItem {
  final Product product;
  final List<Additional> additionals;
  late final double totalPrice;

  CartItem({required this.product, this.additionals = const []}) {
    totalPrice =
        product.price +
        additionals.fold(0, (sum, additional) => sum + additional.price);
  }

  String get displayName {
    if (additionals.isEmpty) return product.name;
    return '${product.name} + ${additionals.map((a) => a.name).join(", ")}';
  }
}

class Additional {
  final String name;
  final double price;

  Additional({required this.name, required this.price});
}

// Modelo para a resposta da API
class ApiResponse {
  final List<Product> items;
  final bool hasMore;
  final int limit;
  final int offset;
  final int count;

  ApiResponse({
    required this.items,
    required this.hasMore,
    required this.limit,
    required this.offset,
    required this.count,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      items: (json['items'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
      hasMore: json['hasMore'] as bool,
      limit: json['limit'] as int,
      offset: json['offset'] as int,
      count: json['count'] as int,
    );
  }
}
