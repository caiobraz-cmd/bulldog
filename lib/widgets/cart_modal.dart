import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';

// 1. CONVERTIDO PARA STATEFULWIDGET
// (Necessário para corrigir o bug de exclusão de item)
class CartModal extends StatefulWidget {
  final CartProvider cartProvider;

  const CartModal({super.key, required this.cartProvider});

  @override
  State<CartModal> createState() => _CartModalState();
}

class _CartModalState extends State<CartModal> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2e2d2d),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Seu Carrinho',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cart Items
            // (Usamos 'widget.cartProvider' por estarmos em um StatefulWidget)
            if (widget.cartProvider.items.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  'Seu carrinho está vazio',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.cartProvider.items[index];
                    return Card(
                      color: const Color(0xFF404040),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          item.displayName,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'R\$ ${item.totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // 2. CORREÇÃO DO BUG DE EXCLUSÃO
                            IconButton(
                              onPressed: () {
                                // Usamos setState para redesenhar o modal
                                // após remover o item
                                setState(() {
                                  widget.cartProvider.removeItem(index);
                                });
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Mostra o total e os botões apenas se o carrinho não estiver vazio
            if (widget.cartProvider.items.isNotEmpty) ...[
              const Divider(color: Colors.grey),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'R\$ ${widget.cartProvider.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text(
                        'Fechar',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      // 3. CONEXÃO COM A TELA DE CHECKOUT
                      onPressed: () {
                        // Fecha o modal e retorna o valor 'checkout'
                        // A HomePage está esperando por esse valor
                        Navigator.of(context).pop('checkout');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFe41d31),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Finalizar'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
