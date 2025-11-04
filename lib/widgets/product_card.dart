import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'additionals_dialog.dart';

/// Um [Card] customizado para exibir um [Product] na [HomePage].
///
/// Este widget exibe a imagem, nome, preço e descrição do produto.
/// Ele também gerencia a lógica para os dois botões de ação:
/// 1. "Vamos nessa?" (Fluxo de compra direta).
/// 2. "Adicionar ao Carrinho" (Fluxo de compra múltipla).
class ProductCard extends StatelessWidget {
  /// Os dados do produto a serem exibidos.
  final Product product;

  /// A instância do provider do carrinho, necessária para o [AdditionalsDialog].
  final CartProvider cartProvider;

  /// Um callback [VoidCallback] que é chamado quando o [AdditionalsDialog]
  /// é fechado. Usado pela [HomePage] para chamar `setState` e
  /// atualizar o badge do carrinho.
  final VoidCallback onCartUpdated;

  const ProductCard({
    super.key,
    required this.product,
    required this.cartProvider,
    required this.onCartUpdated,
  });

  /// Método helper para exibir o [AdditionalsDialog].
  ///
  /// Controla qual fluxo de usuário será ativado com base no
  /// parâmetro [isBuyNow].
  void _showAdditionalsDialog(BuildContext context, {required bool isBuyNow}) {
    showDialog(
      context: context,
      builder: (context) => AdditionalsDialog(
        product: product,
        cartProvider: cartProvider,
        isBuyNow: isBuyNow, // Passa 'true' para "Vamos nessa?"
      ),
    ).then((_) {
      // Após o dialog fechar (seja adicionando ou comprando),
      // chama o callback para notificar a HomePage.
      onCartUpdated();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(106, 46, 45, 45), // Fundo semitransparente
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do Produto
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 200, // Altura ajustada para a imagem
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.grey),
                child: Image.asset(
                  product
                      .imagePath, // 'imagePath' é um getter no modelo Product
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback de imagem
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Nome do Produto
            Text(
              product.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Preço do Produto
            Text(
              'R\$ ${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // Descrição/Ingredientes
            Text(
              product.description, // 'description' é um getter no modelo
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            /// [Spacer] é usado para preencher o espaço vertical vazio
            /// no [Card], empurrando os botões para a parte inferior.
            /// Isso garante um layout consistente, independentemente do
            /// tamanho da descrição.
            const Spacer(),

            // Linha de Botões
            Row(
              children: [
                /// Botão "Vamos nessa?" (Compra Direta)
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () =>
                        _showAdditionalsDialog(context, isBuyNow: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFe41d31),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Vamos nessa?'),
                  ),
                ),
                const SizedBox(width: 8),

                /// Botão "Adicionar ao Carrinho"
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () =>
                        _showAdditionalsDialog(context, isBuyNow: false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFe41d31),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Icon(Icons.shopping_cart),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
