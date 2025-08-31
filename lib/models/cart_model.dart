import 'package:flutter/material.dart';
import 'product_model.dart';

class CartModel extends ChangeNotifier {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => _items;

  void add(ProductModel product) {
    _items.add(product);
    notifyListeners();
  }

  void remove(ProductModel product) {
    _items.remove(product);
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.price);
  }
}
