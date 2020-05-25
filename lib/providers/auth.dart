import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_Exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiretime;
  String _userid;

  bool get isauth {
    return token!=null;
  }

  String get token {
    if (_token != null &&
        _expiretime.isAfter(DateTime.now()) &&
        _expiretime != null) {
      return _token;
    }
      return null;

  }
  String get userid {
    return _userid;
  }

  Future<void> authonticate(
      String email, String password, String dynamucword) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$dynamucword?key=AIzaSyC69LSw-APnl539bqGkO0cq06LD5sOLC0o';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw myException(data['error']['message']);
      }
      _token = data['idToken'];
      _userid = data['localId'];
      _expiretime = DateTime.now().add(
        Duration(seconds: int.parse(data['expiresIn'])),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return authonticate(email, password, 'signUp');

  }

  Future<void> login(String email, String password) async {
    return authonticate(email, password, 'signInWithPassword');
  }
 Future<void> logout ()async{
    _token=null;
    _userid=null;
    _expiretime=null;
    notifyListeners();

  }
}
