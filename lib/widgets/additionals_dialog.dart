import 'package:flutter/material.dart';
import '../models/product.dart';
import '../pages/checkout_screen.dart'; // IMPORTA A TELA DE CHECKOUT
import '../providers/cart_provider.dart';
import '../services/product_service.dart';

/// Um dialog [StatefulWidget] para selecionar ingredientes adicionais.
///
/// Este dialog é reutilizável e suporta dois fluxos de usuário diferentes,
/// controlados pelo parâmetro [isBuyNow]:
///
/// 1. **Fluxo "Adicionar ao Carrinho"** ([isBuyNow] = `false`):
///    Adiciona o [Product] com os [Additional]s selecionados ao [cartProvider]
///    e exibe uma SnackBar.
///
/// 2. **Fluxo "Vamos Nessa" / Comprar Agora** ([isBuyNow] = `true`):
///    Limpa o carrinho, adiciona este item único e navega diretamente
///    para a [CheckoutScreen].
class AdditionalsDialog extends StatefulWidget {
  /// O produto base ao qual os adicionais serão somados.
  final Product product;

  /// A instância do provider do carrinho, usada para adicionar/limpar itens.
  final CartProvider cartProvider;

  /// Flag que controla o fluxo de navegação do dialog.
  /// `false` (padrão) = Adicionar ao Carrinho.
  /// `true` = Comprar Agora (limpa o carrinho e navega para o checkout).
  final bool isBuyNow;

  const AdditionalsDialog({
    super.key,
    required this.product,
    required this.cartProvider,
    this.isBuyNow = false, // Padrão é 'false' (adicionar ao carrinho)
  });

  @override
  State<AdditionalsDialog> createState() => _AdditionalsDialogState();
}

class _AdditionalsDialogState extends State<AdditionalsDialog> {
  /// Lista que armazena os adicionais selecionados pelo usuário.
  final List<Additional> _selectedAdditionals = [];

  /// Lista de todos os adicionais disponíveis (buscados do [ProductService]).
  late List<Additional> _availableAdditionals;

  @override
  void initState() {
    super.initState();
    // Busca a lista de adicionais (atualmente estática)
    _availableAdditionals = ProductService.getAdditionals();
  }

  /// Getter que calcula o preço total *apenas* dos adicionais selecionados.
  double get _totalAdditionalPrice {
    return _selectedAdditionals.fold(
      0,
      (sum, additional) => sum + additional.price,
    );
  }

  /// Getter que calcula o preço total (Produto Base + Adicionais).
  double get _totalPrice {
    return widget.product.price + _totalAdditionalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2e2d2d),
      title: const Text(
        'Escolha seus adicionais',
        style: TextStyle(color: Colors.white),
      ),
      // [SingleChildScrollView] para garantir que a lista de
      // adicionais possa rolar se for muito grande.
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _availableAdditionals.map((additional) {
            final isSelected = _selectedAdditionals.contains(additional);
            return CheckboxListTile(
              title: Text(
                '${additional.name} (+ R\$ ${additional.price.toStringAsFixed(2)})',
                style: const TextStyle(color: Colors.white),
              ),
              value: isSelected,
              onChanged: (value) {
                // Atualiza o estado da lista [_selectedAdditionals]
                // e reconstrói o widget para mostrar o check/uncheck.
                setState(() {
                  if (value == true) {
                    _selectedAdditionals.add(additional);
                  } else {
                    _selectedAdditionals.remove(additional);
                  }
                });
              },
              activeColor: const Color(0xFFe41d31),
              checkColor: Colors.white,
            );
          }).toList(),
        ),
      ),
      actions: [
        // Botão "Cancelar"
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        // Botão Principal (Adicionar ou Finalizar)
        ElevatedButton(
          onPressed: () {
            // Cria o CartItem com os dados selecionados
            final cartItem = CartItem(
              product: widget.product,
              additionals: List.from(_selectedAdditionals),
            );

            // Se for "Vamos nessa?" (Comprar Agora)
            if (widget.isBuyNow) {
              // Limpa o carrinho para garantir que é um item único
              widget.cartProvider.clearCart();
              // Adiciona este item
              widget.cartProvider.addItem(cartItem);

              // Fecha o dialog E navega para a tela de checkout
              Navigator.of(context).pop(); // Fecha o dialog
              // Navega para a tela de checkout (passando o 'context' da tela anterior)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CheckoutScreen()),
              );
            }
            // Se for o fluxo normal (Adicionar ao Carrinho)
            else {
              widget.cartProvider.addItem(cartItem);
              Navigator.of(context).pop();

              // Mostra uma SnackBar de feedback
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Item adicionado ao carrinho!',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red.withValues(alpha: 0.8),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFe41d31),
            foregroundColor: Colors.white,
          ),
          // O texto do botão muda de acordo com o fluxo (isBuyNow)
          child: Text(
            widget.isBuyNow
                ? 'Finalizar (R\$ ${_totalPrice.toStringAsFixed(2)})'
                : 'Adicionar ao carrinho (R\$ ${_totalPrice.toStringAsFixed(2)})',
          ),
        ),
      ],
    );
  }
}
