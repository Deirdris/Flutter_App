import 'package:chores_flutter/data/firestore_document.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chore extends FirestoreDocument {
  Chore({
    this.job,
    this.duration,
    this.date,
    this.user,
    this.userDisplayName,
  });

  String job;
  int duration;
  DateTime date;
  String user;
  String userDisplayName;
  static String collection = "chore";

  Chore.from(Chore other) {
    job = other.job;
    duration = other.duration;
    date = other.date;
    user = other.user;
    userDisplayName = other.userDisplayName;
  }

  Chore.fromFirestore(DocumentSnapshot docSnapshot): super(docSnapshot) {
    var data = docSnapshot.data();
    job = data["job"];
    duration = data["duration"];
    date = data["date"].toDate();
    user = data["user"];
    userDisplayName = data["userDisplayName"];
  }

  Map<String, dynamic> toFirestore() {
    return {
      "job": job,
      "duration": duration,
      "date": date,
      "user": user,
      "userDisplayName": userDisplayName,
    };
  }
}