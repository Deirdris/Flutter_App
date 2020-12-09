import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreDocument {
  FirestoreDocument([DocumentSnapshot docSnapshot]){
    this.docSnapshot = docSnapshot;
  }

  DocumentSnapshot docSnapshot;

  DocumentReference get docReference => docSnapshot.reference;

  String get id => docReference.id;
}