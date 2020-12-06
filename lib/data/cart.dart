import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Shopping {
  Shopping({
    this.bought,
    this.price,
    this.date,
    this.user,
    this.userDisplayName,
  });

  String bought;
  double price;
  DateTime date;
  String user;
  String userDisplayName;

  Shopping.from(Shopping other) {
    bought = other.bought;
    price = other.price;
    date = other.date;
    user = other.user;
    userDisplayName = other.userDisplayName;
  }

  Shopping.fromFirestore(Map data) {
    bought = data["bought"];
    price = data["price"] is int ? data["price"].toDouble() : data["price"];
    date = data["date"].toDate();
    user = data["user"];
    userDisplayName = data["userDisplayName"];
  }

  Map<String, dynamic> toFirestore() {
    return {
      "bought": bought,
      "price": price,
      "date": date,
      "user": user,
      "userDisplayName": userDisplayName,
    };
  }
}

class AllShopping extends ChangeNotifier {
  List<Shopping> _cart = List();

  List<Shopping> get cart => _cart;

  bool hasFetchedData = false;
  Future fetchFuture;

  Future fetchData() {
    hasFetchedData = true;
    Completer completer = Completer();
    FirebaseFirestore.instance
        .collection("shopping")
        .orderBy("date", descending: true)
        .limit(10)
        .snapshots()
        .listen((event) {
      event.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          _cart.add(Shopping.fromFirestore(change.doc.data()));
        }
      });
      _cart.sort((a,b) => b.date.millisecondsSinceEpoch - a.date.millisecondsSinceEpoch);
      if (!completer.isCompleted) {
        completer.complete();
      }
      notifyListeners();
    });

    fetchFuture = completer.future;

    return completer.future;
  }

  Future add(Shopping shopping) async{
    await FirebaseFirestore.instance.collection("shopping").add(shopping.toFirestore());
  }
}
