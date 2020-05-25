import 'package:flutter/material.dart';
import 'package:shop_app/models/http_Exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  final String token;
  final String userid;
  ProductProvider(
      this.token,this._list,this.userid); // you can mix claas with more than mixin to get their proberties and methods but there is not logical relation between class and mixin just utilities
  List<Product> _list = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

  List<Product> get items {
    return [..._list];
  }

  List<Product> get favouriteitems {
    return _list.where((elemnt) => elemnt.isfavourite).toList();
  }

  Product getFirstwhere(String id) {
    return _list.firstWhere((elemnt) {
      return elemnt.id == id;
    });
  }

  Future<void> addproduct(Product product) async {
//    const url = 'https://test-f4bd9.firebaseio.com/products.json';
//    return http.post(url,
//        body: json.encode({
//          'title': product.title,
//          'description': product.description,
//          'price': product.price,
//          'imageurl': product.imageUrl
//        })).then((response){
//      final prod = Product(
//          id: json.decode(response.body)['name'],
//          title: product.title,
//          description: product.description,
//          price: product.price,
//          imageUrl: product.imageUrl);
//      _list.add(prod);
//      notifyListeners();
//    }).catchError((error){// will execute if an error occured in post or in then (lw hsl error fe post he3ml skip l then w ynfz catch error)
//      print(error.toString());
//      throw error;//if an error occured then it can ne thrown to the result of the method and can change some thing in the ui
//    });

    // another way to do the same

    final url = 'https://test-f4bd9.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http
          .post(url,
              body: json.encode({
                'title': product.title,
                'description': product.description,
                'price': product.price,
                'imageurl': product.imageUrl,
                'creatorid':userid
              }))
          .then((response) {
        final prod = Product(
            isfavourite: product.isfavourite,
            id: json.decode(response.body)['name'],
            title: product.title,
            description: product.description,
            price: product.price,
            imageUrl: product.imageUrl);

        _list.add(prod);
        notifyListeners();
      });
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchdatafromserverandset([bool filter=false]) async {
    if(token!=null){
      final segment=filter?'orderBy="creatorid"&equalTo="$userid"':'';
      final url = 'https://test-f4bd9.firebaseio.com/products.json?auth=$token&$segment';
      try {
        final response = await http.get(url);
        final data = json.decode(response.body) as Map<String, dynamic>;
        print(data);
        final ur = 'https://test-f4bd9.firebaseio.com/usersfavourite/$userid.json?auth=$token';
        final favouriteresponse=await http.get(ur);
        final favouritedata=json.decode(favouriteresponse.body);
        print(favouritedata);
        final List<Product> loadedlist = [];
        data.forEach((productid, productdata) {
          loadedlist.add(Product(
              id: productid,
              price: productdata['price'],
              imageUrl: productdata['imageurl'],
              description: productdata['description'],
              title: productdata['title'],
              isfavourite:favouritedata==null?false:favouritedata[productid]??false));
        });
        _list = loadedlist;
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    }
    else{

    }

  }

  Future<void> updateproduct(String id, Product newProduct) async {
    final index = _list.indexWhere((elemnt) => elemnt.id == id);
    final url = 'https://test-f4bd9.firebaseio.com/products/$id.json?auth=$token';
    await http.patch(url,
        body: json.encode({
          'description': newProduct.description,
          'title': newProduct.title,
          'imageurl': newProduct.imageUrl,
          'price': newProduct.price
        }));
    _list[index] = newProduct;
    notifyListeners();
  }

  Future<void> removeproduct(String id) async {
    final index = _list.indexWhere((elemnt) => elemnt.id == id);
    var ite = _list[index];
    _list.removeWhere((elemnt) => elemnt.id == id);
    notifyListeners();
    final url = 'https://test-f4bd9.firebaseio.com/products/$id.json?auth=$token';
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _list.insert(index, ite);
      notifyListeners();
      throw myException('this is my message ahmed');
    }
    ite = null;
  }
}
