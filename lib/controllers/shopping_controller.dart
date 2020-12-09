import 'dart:async';

import 'package:chores_flutter/data/firestore_document.dart';
import 'package:chores_flutter/data/shopping.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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
          cart.add(Shopping.fromFirestore(change.doc));
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
