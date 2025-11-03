import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'additionals_dialog.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final CartProvider cartProvider;
  final VoidCallback onCartUpdated;

  const ProductCard({
    super.key,
    required this.product,
    required this.cartProvider,
    required this.onCartUpdated,
  });

  void _showAdditionalsDialog(BuildContext context, {required bool isBuyNow}) {
    showDialog(
      context: context,
      builder: (context) => AdditionalsDialog(
        product: product,
        cartProvider: cartProvider,
        isBuyNow: isBuyNow,
      ),
    ).then((_) {
      onCartUpdated();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(106, 46, 45, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      // 1. Padding geral ajustado
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Aumentei um pouco (era 12)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                // 2. ALTURA DA IMAGEM AUMENTADA (para cortar menos)
                height: 200, // Antes era 150
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.grey),
                child: Image.asset(
                  product.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
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
            // 3. Espaçamentos internos ajustados
            const SizedBox(height: 10), // Antes era 8
            // Product Name
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

            // Product Price
            Text(
              'R\$ ${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // Product Description
            Text(
              product.description,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // 4. ESPAÇAMENTO FLEXÍVEL (para empurrar os botões para baixo)
            // Isso vai usar o "espaço em branco" que estava sobrando
            const Spacer(),

            // Buttons Row - "Vamos nessa?" and Cart Button
            Row(
              children: [
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
