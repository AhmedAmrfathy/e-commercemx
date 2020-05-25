import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantaty;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantaty,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItems(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingitem) => CartItem(
              id: existingitem.id,
              title: existingitem.title,
              price: existingitem.price,
              quantaty: existingitem.quantaty + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantaty: 1));
    }
    notifyListeners();
  }

  int get itemcount {
    return _items.length;
  }

  double get total {
    var total = 0.0;
    _items.forEach((key, carditem) {
      total += carditem.price * carditem.quantaty;
    });
    return total;
  }

  void deleteitem(String productid) {
    _items.remove(productid);
    notifyListeners();
  }

  void deletesingleitem(String productid) {
    if (!_items.containsKey(productid)) {
      return;
    } else if (_items[productid].quantaty > 1) {
      _items.update(productid, (current) {
        return CartItem(
            id: current.id,
            price: current.price,
            title: current.title,
            quantaty: current.quantaty - 1);
      });
    }
    else{
      _items.remove(productid);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
