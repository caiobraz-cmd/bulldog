/// Representa a estrutura de um produto (lanche)
/// vindo da API do Oracle APEX.
class Product {
  int seqId;
  String name;
  double price;
  String ingredients;
  String? imageBase64; // <--- agora é variável normal, pode ser alterada

  Product({
    required this.seqId,
    required this.name,
    required this.price,
    required this.ingredients,
    this.imageBase64,
  });

  /// Construtor factory para criar uma instância de [Product]
  /// a partir de um mapa JSON (vindo da API).
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      seqId: json['seq_id'] as int,
      name: json['ds_nome'] as String,
      price: (json['preco'] as num).toDouble(),
      ingredients: json['ingredientes'] as String,
      imageBase64: json['imagem_base64'] as String?, // campo vindo do banco
    );
  }

  /// Converte a instância de [Product] em um mapa JSON.
  /// (Útil para enviar dados para a API, ex: criar/atualizar produto).
  Map<String, dynamic> toJson() {
    return {
      'seq_id': seqId,
      'ds_nome': name,
      'preco': price,
      'ingredientes': ingredients,
      'imagem_base64': imageBase64,
    };
  }

  /// Getter para o ID como String (para compatibilidade).
  String get id => seqId.toString();

  /// Getter para a descrição (para compatibilidade).
  String get description => ingredients;

  // 🖼️ Agora compatível: se tiver imagem vinda da API, retorna ela
  String get imagePath {
    if (imageBase64 != null && imageBase64!.isNotEmpty) {
      return imageBase64!; // usado diretamente para mostrar imagem em base64
    }

    // 🔙 Caso contrário, usa as imagens antigas
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
    return 'assets/NETAIO/img/hotdogsimples.jpg';
  }

  /// Getter que determina o tipo do produto (para lógica futura).
  ProductType get type {
    return name.toLowerCase().contains('burguer')
        ? ProductType.burger
        : ProductType.hotdog;
  }
}

/// Enum para definir os tipos de produto.
enum ProductType { hotdog, burger }

/// Representa um item dentro do carrinho de compras.
class CartItem {
  /// O produto base.
  final Product product;

  /// A lista de adicionais selecionados para este item.
  final List<Additional> additionals;

  /// O preço total (produto + adicionais), calculado no momento da criação.
  late final double totalPrice;

  CartItem({required this.product, this.additionals = const []}) {
    // Calcula o preço total assim que o item é instanciado.
    totalPrice =
        product.price +
        additionals.fold(0, (sum, additional) => sum + additional.price);
  }

  /// Getter para o nome de exibição formatado do item no carrinho.
  /// (ex: "Dog Duplo + Bacon, Queijo").
  String get displayName {
    if (additionals.isEmpty) return product.name;
    return '${product.name} + ${additionals.map((a) => a.name).join(", ")}';
  }
}

/// Representa um ingrediente adicional que pode ser adicionado a um [CartItem].
class Additional {
  final String name;
  final double price;

  Additional({required this.name, required this.price});
}

class ApiResponse {
  /// A lista de produtos retornada na página atual.
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

  /// Construtor factory para criar uma [ApiResponse] a partir do JSON.
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
