import 'package:flutter/material.dart';

class CartBloc with ChangeNotifier {
  Map _cart = {};
  get cart => _cart;

  void addToCart(product) {
    if (_cart.containsKey(product)) {
      _cart[product] += 1;
    } else {
      _cart[product] = 1;
    }
    notifyListeners();

    _cart.forEach((key, value) {
      print('Key = $key : Value = $value');
    });
  }

  void clear(index) {
    if (_cart.containsKey(index)) {
      _cart.remove(index);
      notifyListeners();
    }
  }
}
