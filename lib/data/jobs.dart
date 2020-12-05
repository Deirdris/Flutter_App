import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  Job({
    this.job,
    this.duration,
    this.date,
    this.user,
    this.userDisplayName,
  });

  String job;
  String duration;
  DateTime date;
  String user;
  String userDisplayName;

  Job.from(Job jobModel) {
    job = jobModel.job;
    duration = jobModel.duration;
    date = jobModel.date;
    user = jobModel.user;
    userDisplayName = jobModel.userDisplayName;
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

class Jobs extends ChangeNotifier {
  List<Job> _jobs = List();

  List<Job> get jobs => _jobs;

  bool hasFetchedData = false;
  Future fetchFuture;

  Future fetchData() {
    hasFetchedData = true;
    Completer completer = Completer();
    FirebaseFirestore.instance
        .collection("jobs")
        .orderBy("date", descending: true)
        .limit(10)
        .snapshots()
        .listen((event) {
      event.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          _jobs.add(Job.fromFirestore(change.doc.data()));
        }
      });
      _jobs.sort((a,b) => b.date.millisecondsSinceEpoch - a.date.millisecondsSinceEpoch);
      if (!completer.isCompleted) {
        completer.complete();
      }
      notifyListeners();
    });

    fetchFuture = completer.future;

    return completer.future;
  }

  Future add(Job job) async {
    await FirebaseFirestore.instance.collection("jobs").add(job.toFirestore());
    // jobs.add(job);
    // notifyListeners();
  }
}
