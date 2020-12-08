import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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
  static String collection = "shopping";

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

class ShoppingController extends GetxController {
  final cart = RxList();

  Future fetchFuture;

  @override
  void onInit(){
    super.onInit();

    Completer completer = Completer();
    FirebaseFirestore.instance
        .collection("shopping")
        .orderBy("date", descending: true)
        .limit(10)
        .snapshots()
        .listen((event) {
      event.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          cart.add(Shopping.fromFirestore(change.doc.data()));
        }
      });
      cart.sort((a,b) => b.date.millisecondsSinceEpoch - a.date.millisecondsSinceEpoch);
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    fetchFuture = completer.future;
  }

  Future add(Shopping shopping) async{
    await FirebaseFirestore.instance.collection("shopping").add(shopping.toFirestore());
  }
}
