import 'package:chores_flutter/data/firestore_document.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product extends FirestoreDocument {

  Product({
    this.name,
    this.price,
  });

  String name;
  double price;

  Product.fromFirestore(DocumentSnapshot docSnapshot) : super(docSnapshot) {
    var data = docSnapshot.data();

    name = data['name'];
    price = data["price"] is int ? data["price"].toDouble() : data["price"];
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      "price": price,
    };
  }
}
