import 'dart:math';

import 'package:chores_flutter/controllers/user_controller.dart';
import 'package:chores_flutter/default_scaffold.dart';
import 'package:chores_flutter/widgets/future_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:chores_flutter/controllers/shopping_controller.dart';

enum ChartType {
  week,
  month,
  lifetime,
}

extension ChartExtension on ChartType {
  getName() {
    switch (this) {
      case ChartType.week:
        return 'Tydzień';
      case ChartType.month:
        return 'Miesiąc';
      case ChartType.lifetime:
        return 'Całość';
    }
  }
}

class ChartData {
  ChartData([this.user]);

  UserData user;
  double sum = 0;
}

class ChartList extends StatefulWidget {
  @override
  _ChartListState createState() => _ChartListState();
}

class _ChartListState extends State<ChartList> {
  Future future;
  List<Shopping> data;
  List<UserData> users;
  final chartData = RxMap<String, ChartData>();
  final chartType = ChartType.month.obs;


  List<ChartData> get chartDataList => chartData.values.toList();

  double get maxY =>
      chartDataList.fold(0, (previousValue, element) => element.sum > previousValue ? element.sum : previousValue);

  fetchData() async {
    var userQuerySnapshot = await FirebaseFirestore.instance.collection("users").get();
    users = userQuerySnapshot.docs.map((element) => UserData.fromFirestore(element.data(), element.id)).toList();
    var querySnapshot = await FirebaseFirestore.instance
        .collection("shopping")
        .where("date", isGreaterThan: DateTime.now().subtract(Duration(days: 30)))
        .get();
    data = querySnapshot.docs.map((element) => Shopping.fromFirestore(element.data())).toList();
    updateChartData();
  }

  void updateChartData() {
    chartData.clear();

    switch (chartType()) {
      case ChartType.week:
      case ChartType.month:
        var data = chartType() == ChartType.month
            ? this.data
            : this.data.where((element) =>
                element.date.millisecondsSinceEpoch >=
                DateTime.now().subtract(Duration(days: 7)).millisecondsSinceEpoch);
        for (var shopping in data) {
          if (chartData[shopping.user] == null) {
            chartData[shopping.user] = ChartData(users.firstWhere((element) => element.id == shopping.user));
          }
          chartData[shopping.user].sum += shopping.price;
        }
        break;
      case ChartType.lifetime:
        users.forEach((element) {
          chartData[element.id] = ChartData(element)..sum = element.sumSpent;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      future = fetchData();
    }

    return DefaultScaffold(
      body: FutureHandler(
        future: future,
        onDone: (_) => Container(
          padding: const EdgeInsets.only(
            top: 18,
            left: 8,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Obx(
                  () => Row(
                    children: [
                      for (var type in ChartType.values)
                        Expanded(
                          child: RawChip(
                            label: Text(
                              type.getName(),
                              style: TextStyle(
                                  color: type == chartType() ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            onPressed: () {
                              chartType.value = type;
                              updateChartData();
                            },
                            showCheckmark: false,
                            selected: type == chartType(),
                            selectedColor: Colors.amber,
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  color: Theme.of(context).primaryColor,
                  thickness: 0.5,
                ),
              ),
              SizedBox(height: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Wydany pieniądz na miesiąc",
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).primaryColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Material(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(2137),
                        clipBehavior: Clip.hardEdge,
                        child: IconButton(
                          padding: EdgeInsets.all(4),
                          visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                          icon: Icon(Icons.cached, color: Theme.of(context).backgroundColor, size: 24),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(),
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.only(top: 14, bottom: 10),
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: Obx(
                    () => BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxY + 5,
                        barTouchData: BarTouchData(
                          enabled: false,
                          touchTooltipData: BarTouchTooltipData(
                              tooltipBgColor: Colors.transparent,
                              tooltipPadding: const EdgeInsets.all(0),
                              tooltipBottomMargin: 4,
                              getTooltipItem: (
                                BarChartGroupData group,
                                int groupIndex,
                                BarChartRodData rod,
                                int rodIndex,
                              ) {
                                return BarTooltipItem(
                                    rod.y.round().toString(),
                                    TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ));
                              }),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => TextStyle(
                                color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
                            margin: 20,
                            getTitles: (double value) {
                              return users[value.toInt()].displayName;
                            },
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            interval: max(maxY ~/ 30, 1) * 5.0,
                            getTextStyles: (value) => TextStyle(
                                color: Theme.of(context).primaryColor, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                              bottom: BorderSide(color: Theme.of(context).primaryColor),
                              left: BorderSide(color: Theme.of(context).primaryColor)),
                        ),
                        barGroups: [
                          for (var i = 0; i < users.length; i++)
                            BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  y: chartDataList
                                      .firstWhere((element) => element.user.id == users[i].id,
                                          orElse: () => ChartData())
                                      .sum,
                                  colors: [Colors.blueGrey[800], Colors.red],
                                  width: 18,
                                  borderRadius: BorderRadius.zero,
                                )
                              ],
                              showingTooltipIndicators: [0],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
