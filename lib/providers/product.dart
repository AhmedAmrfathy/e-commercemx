import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isfavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isfavourite = false});

  Future<void> toogle(Product product,String token,String userid) async {
    isfavourite = !isfavourite;
    notifyListeners();
    final url = 'https://test-f4bd9.firebaseio.com/usersfavourite/$userid/${product.id}.json?auth=$token';
    http.put(url,
        body: json.encode(isfavourite));
  }
}
