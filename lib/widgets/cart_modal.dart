import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';

/// Um [Dialog] que exibe o estado atual do [CartProvider].
///
/// Este é um [StatefulWidget] para permitir que a lista de itens
/// seja atualizada visualmente (usando [setState]) quando um item
/// é removido, sem a necessidade de fechar e reabrir o modal.
class CartModal extends StatefulWidget {
  /// A instância do [CartProvider] (passada da [HomePage]).
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
          mainAxisSize:
              MainAxisSize.min, // Para o dialog se ajustar ao conteúdo
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

            // Lista de Itens do Carrinho
            // (Usa 'widget.cartProvider' para acessar o provider no StatefulWidget)
            if (widget.cartProvider.items.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  'Seu carrinho está vazio',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
            else
              // [Flexible] garante que a lista não estoure
              // a altura do [Column]
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
                          item.displayName, // ex: "Dog Duplo + Bacon"
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
                            // Botão de Excluir
                            IconButton(
                              onPressed: () {
                                /// Remove o item do provider e chama [setState]
                                /// para forçar a reconstrução *deste modal*,
                                /// atualizando a lista visualmente.
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

              // Botões de Ação
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
                      /// Ao clicar em "Finalizar", fecha o modal e
                      /// retorna o valor 'checkout' para a [HomePage].
                      /// A [HomePage] está "escutando" esse valor no `.then()`
                      /// para saber que deve navegar para a tela de checkout.
                      onPressed: () {
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
