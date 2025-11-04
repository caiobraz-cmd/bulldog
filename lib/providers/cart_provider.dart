import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// Gerenciador de estado para o carrinho de compras.
///
/// Usando o padrão [ChangeNotifier], esta classe armazena a lista de
/// [CartItem]s e notifica os "ouvintes" (widgets, como o [Consumer])
/// sempre que o carrinho é modificado (item adicionado, removido ou limpo).
class CartProvider extends ChangeNotifier {
  /// A lista interna e privada de itens no carrinho.
  final List<CartItem> _items = [];

  /// Getter público que retorna uma cópia *não modificável* da lista de itens.
  /// Isso previne que widgets externos modifiquem a lista diretamente.
  List<CartItem> get items => List.unmodifiable(_items);

  /// Getter para o número total de itens no carrinho.
  int get itemCount => _items.length;

  /// Getter que calcula e retorna o preço total do carrinho.
  ///
  /// Ele usa o método [fold] para somar o [totalPrice] de cada [CartItem].
  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  /// Adiciona um [CartItem] ao carrinho e notifica os ouvintes.
  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners(); // Informa aos widgets (ex: Consumer) que o estado mudou.
  }

  /// Remove um [CartItem] do carrinho pelo seu [index] na lista
  /// e notifica os ouvintes.
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners(); // Informa que o estado mudou.
    }
  }

  /// Remove todos os itens do carrinho e notifica os ouvintes.
  /// (Usado ao finalizar um pedido).
  void clearCart() {
    _items.clear();
    notifyListeners(); // Informa que o estado mudou.
  }
}
