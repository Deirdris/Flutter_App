import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController extends GetxController {
  User user;
  DocumentReference userDoc;
  UserData userData;

  Future fetchFuture;

  @override
  void onInit(){
    super.onInit();

    fetchFuture = init();
  }

  Future init() async {
    await Firebase.initializeApp();
    bool isAuthenticated = await checkAuthStatus();
    if(!isAuthenticated){
      await signin();
    }else{
      await fetchUserData();
    }
  }

  Future fetchUserData() async {
    userDoc = FirebaseFirestore.instance.collection("users").doc(user.uid);
    DocumentSnapshot documentSnapshot = await userDoc.get();
    if (!documentSnapshot.exists) {
      userData = UserData(
        displayName: user.displayName.split(" ").first,
        sumSpent: 0,
        overallDuration: 0,
      );
      await userDoc.set(userData.toFirestore());
    } else {
      userData = UserData.fromFirestore(documentSnapshot.data());
    }
  }

  Future<bool> checkAuthStatus() async {
    Completer completer = Completer<bool>();

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (!completer.isCompleted) {
        this.user = user;
        completer.complete(user != null);
      }
    });

    return completer.future;
  }

  Future signin() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      await fetchUserData();
    } catch (e) {
      print(e.toString());
      FirebaseAuth.instance.signOut();
      // await signin();
    }
  }

  Future saveData() {
    return userDoc.set(userData.toFirestore());
  }
}

class UserData {
  UserData({
    this.id,
    this.displayName,
    this.overallDuration,
    this.sumSpent,
  });

  String id;
  String displayName;
  int overallDuration;
  double sumSpent;

  UserData.from(UserData other) {
    displayName = other.displayName;
    overallDuration = other.overallDuration;
    sumSpent = other.sumSpent;
  }

  UserData.fromFirestore(Map data, [String id]) {
    this.id = id;
    displayName = data["displayName"];
    overallDuration = data["overallDuration"];
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
