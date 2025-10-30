import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/product_service.dart';

class AdditionalsDialog extends StatefulWidget {
  final Product product;
  final CartProvider cartProvider;

  const AdditionalsDialog({
    super.key,
    required this.product,
    required this.cartProvider,
  });

  @override
  State<AdditionalsDialog> createState() => _AdditionalsDialogState();
}

class _AdditionalsDialogState extends State<AdditionalsDialog> {
  final List<Additional> _selectedAdditionals = [];
  late List<Additional> _availableAdditionals;

  @override
  void initState() {
    super.initState();
    _availableAdditionals = ProductService.getAdditionals();
  }

  double get _totalAdditionalPrice {
    return _selectedAdditionals.fold(
      0,
      (sum, additional) => sum + additional.price,
    );
  }

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
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            final cartItem = CartItem(
              product: widget.product,
              additionals: List.from(_selectedAdditionals),
            );
            widget.cartProvider.addItem(cartItem);
            Navigator.of(context).pop();

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Item adicionado ao carrinho!',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red.withOpacity(0.8),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFe41d31),
            foregroundColor: Colors.white,
          ),
          child: Text(
            'Adicionar ao carrinho (R\$ ${_totalPrice.toStringAsFixed(2)})',
          ),
        ),
      ],
    );
  }
}
