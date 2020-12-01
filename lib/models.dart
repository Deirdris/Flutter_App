import 'package:flutter/material.dart';

class JobModel {
  JobModel({
    this.job,
    this.duration,
    this.date,
  });

  JobModel.from(JobModel jobModel){
    job = jobModel.job;
    duration = jobModel.duration;
    date = jobModel.date;
  }

  String job;
  String duration;
  DateTime date;
}

class JobsModel extends ChangeNotifier {
  List<JobModel> _jobs = List();

  List<JobModel> get jobs => _jobs;

  void add(JobModel job) {
    jobs.add(job);
    notifyListeners();
  }
}

class ShoppingModel {
  ShoppingModel({
    this.bought,
    this.price,
    this.date,
  });

  ShoppingModel.from(ShoppingModel shoppingModel){
    bought = shoppingModel.bought;
    price = shoppingModel.price;
    date = shoppingModel.date;
  }

  String bought;
  int price;
  DateTime date;
}

class CartModel extends ChangeNotifier {
  List<ShoppingModel> _cart = List();

  List<ShoppingModel> get cart => _cart;

  void add(ShoppingModel shopping) {
    cart.add(shopping);
    notifyListeners();
  }
}
