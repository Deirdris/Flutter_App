import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChoresUser extends ChangeNotifier {
  User user;
  DocumentReference userDoc;

  Future<bool> checkAuthStatus() async {
    Completer completer = Completer<bool>();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if(!completer.isCompleted){
        this.user = user;
        completer.complete(user == null);
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
    try{
      user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      userDoc = FirebaseFirestore.instance.collection("users").doc(user.uid);
      if (!(await userDoc.get()).exists) {
        await userDoc.set({
          "displayName": user.displayName,
        });
      }
    }catch(e){
      print(e.toString());
      FirebaseAuth.instance.signOut();
      // await signin();
    }
  }
}
