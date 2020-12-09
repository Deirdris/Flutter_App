import 'package:chores_flutter/data/firestore_document.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product extends FirestoreDocument {

  Product({
    this.price,
  });
  double price;

  String get name => id;

  Product.fromFirestore(DocumentSnapshot docSnapshot) : super(docSnapshot) {
    var data = docSnapshot.data();

    price = data["price"];
  }

  Map<String, dynamic> toFirestore() {
    return {
      "price": price,
    };
  }
}
