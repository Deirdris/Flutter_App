import 'dart:async';

import 'package:chores_flutter/data/chore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChoresController extends GetxController {
  final chores = RxList();

  Future fetchFuture;

  @override
  void onInit(){
    super.onInit();

    Completer completer = Completer();
    FirebaseFirestore.instance
        .collection("chores")
        .orderBy("date", descending: true)
        .limit(10)
        .snapshots()
        .listen((event) {
      event.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          chores.add(Chore.fromFirestore(change.doc));
        }
      });
      chores.sort((a,b) => b.date.millisecondsSinceEpoch - a.date.millisecondsSinceEpoch);
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    fetchFuture = completer.future;
  }

  Future add(Chore job) async {
    await FirebaseFirestore.instance.collection("chores").add(job.toFirestore());
  }
}
