import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart'; // 1. IMPORTAR O CARTPROVIDER
import 'additionals_dialog.dart'; // 2. IMPORTAR O DIALOG (DO SEU CANVAS)

class ProductCard extends StatelessWidget {
  final Product product;
  // 3. MODIFICAR OS PARÂMETROS
  final CartProvider cartProvider;
  final VoidCallback onCartUpdated; // Substitui o onAddToCart

  const ProductCard({
    super.key,
    required this.product,
    required this.cartProvider,
    required this.onCartUpdated,
  });

  // 4. MÉTODO PRIVADO PARA MOSTRAR O DIALOG
  void _showAdditionalsDialog(BuildContext context, {required bool isBuyNow}) {
    showDialog(
      context: context,
      builder: (context) => AdditionalsDialog(
        product: product,
        cartProvider: cartProvider,
        isBuyNow: isBuyNow, // Passa o parâmetro 'true' ou 'false'
      ),
    ).then((_) {
      // Após o dialog fechar, atualiza o contador do carrinho na home
      onCartUpdated();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(106, 46, 45, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 220,
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
            const SizedBox(height: 12),

            // Product Name
            Text(
              product.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Product Price
            Text(
              'R\$ ${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Product Description
            Text(
              product.description,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Buttons Row - "Vamos nessa?" and Cart Button
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    // 5. CHAMADA DO "VAMOS NESSA?" (isBuyNow: true)
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
                    // 6. CHAMADA DO "ADICIONAR AO CARRINHO" (isBuyNow: false)
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
