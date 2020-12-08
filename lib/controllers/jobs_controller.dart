import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Job {
  Job({
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
  static String collection = "jobs";

  Job.from(Job other) {
    job = other.job;
    duration = other.duration;
    date = other.date;
    user = other.user;
    userDisplayName = other.userDisplayName;
  }

  Job.fromFirestore(Map data) {
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

class JobsController extends GetxController {
  final jobs = RxList();

  Future fetchFuture;

  @override
  void onInit(){
    super.onInit();

    Completer completer = Completer();
    FirebaseFirestore.instance
        .collection("jobs")
        .orderBy("date", descending: true)
        .limit(10)
        .snapshots()
        .listen((event) {
      event.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          jobs.add(Job.fromFirestore(change.doc.data()));
        }
      });
      jobs.sort((a,b) => b.date.millisecondsSinceEpoch - a.date.millisecondsSinceEpoch);
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    fetchFuture = completer.future;
  }

  Future add(Job job) async {
    await FirebaseFirestore.instance.collection("jobs").add(job.toFirestore());
  }
}
