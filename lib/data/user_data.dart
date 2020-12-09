import 'package:chores_flutter/data/firestore_document.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData extends FirestoreDocument {
  UserData({
    this.displayName,
    this.overallDuration,
    this.sumSpent,
  });

  String displayName;
  double overallDuration;
  double sumSpent;

  UserData.from(UserData other) {
    displayName = other.displayName;
    overallDuration = other.overallDuration;
    sumSpent = other.sumSpent;
  }

  UserData.fromFirestore(DocumentSnapshot docSnapshot): super(docSnapshot) {
    var data = docSnapshot.data();
    displayName = data["displayName"];
    overallDuration = data["overallDuration"] is int ? data['overallDuration'].toDouble() : data['overallDuration'];
    sumSpent = data["sumSpent"] is int ? data["sumSpent"].toDouble() : data["sumSpent"];
  }

  Map<String, dynamic> toFirestore() {
    return {
      "displayName": displayName,
      "overallDuration": overallDuration,
      "sumSpent": sumSpent,
    };
  }
}