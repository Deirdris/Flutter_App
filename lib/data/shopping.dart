import 'package:chores_flutter/data/firestore_document.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Shopping extends FirestoreDocument {
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

  Shopping.fromFirestore(DocumentSnapshot docSnapshot): super(docSnapshot) {
    var data = docSnapshot.data();
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