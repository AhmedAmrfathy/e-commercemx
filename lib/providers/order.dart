import 'dart:convert';

import 'package:flutter/foundation.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderItem {
  final String id;
  final DateTime dateTime;
  final double amount;
  final List<CartItem> list;

  OrderItem(
      {@required this.id,
      @required this.dateTime,
      @required this.amount,
      @required this.list});
}

class Order with ChangeNotifier {
  final String token;
  final String userid;

  Order(this.token, this._list, this.userid);

  List<OrderItem> _list = [];

  List<OrderItem> get orderitems {
    return [..._list];
  }

  Future<void> addOrder(List<CartItem> list, double total) async {
    final url =
        'https://test-f4bd9.firebaseio.com/Orders/$userid.json?auth=$token';
    try {
      final response = await http.post(url,
          body: json.encode({
            'datetime': DateTime.now().toIso8601String(),
            'amount': total,
            'list': list
                .map((elemnt) => {
                      'id': elemnt.id,
                      'title': elemnt.title,
                      'quantaty': elemnt.quantaty,
                      'price': elemnt.price
                    })
                .toList()
          }));
      _list.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              dateTime: DateTime.now(),
              amount: total,
              list: list));
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> getorderfromserverandset() async {
    final url =
        'https://test-f4bd9.firebaseio.com/Orders/$userid.json?auth=$token';
    final response = await http.get(url);
    final List<OrderItem> loadeddata = [];
    final data = json.decode(response.body) as Map<String, dynamic>;
    print(data);
    data.forEach((orderid, orderdata) {
      loadeddata.add(OrderItem(
          id: orderid,
          dateTime: DateTime.parse(orderdata['datetime']),
          amount: orderdata['amount'],
          list: (orderdata['list'] as List<dynamic>).map((elemnt) {
            return CartItem(
                id: elemnt['id'],
                title: elemnt['title'],
                price: elemnt['price'],
                quantaty: elemnt['quantaty']);
          }).toList()));
    });
    _list = loadeddata;
    notifyListeners();
  }
}
