import 'package:flutter/material.dart';

class ShoppingModel {
  ShoppingModel({
    this.bought,
    this.price,
    this.date,
  });

  ShoppingModel.from(ShoppingModel shoppingModel){
    bought = shoppingModel.bought;
    price = shoppingModel.price;
    date = shoppingModel.date;
  }

  String bought;
  int price;
  DateTime date;
}

class CartModel extends ChangeNotifier {
  List<ShoppingModel> _cart = List();

  List<ShoppingModel> get cart => _cart;

  void add(ShoppingModel shopping) {
    cart.add(shopping);
    notifyListeners();
  }
}
