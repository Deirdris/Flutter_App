import 'package:chores_flutter/data/chores_user.dart';
import 'package:chores_flutter/default_scaffold.dart';
import 'package:chores_flutter/widgets/future_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:chores_flutter/data/cart.dart';

class ChartList extends StatefulWidget {
  @override
  _ChartListState createState() => _ChartListState();
}

class _ChartListState extends State<ChartList> {
  Future future;
  List<Shopping> data;
  List<Map> users = List();
  Map chartData = {};
  List<String> chartUserData;

  fetchData() async {
    var userQuerySnapshot = await FirebaseFirestore.instance.collection("users").get();
    userQuerySnapshot.docs.forEach((element) {
      var user = UserData.fromFirestore(element.data());
      users.add({
        'id': element.id,
        'displayName': user.displayName,
      });
    });
    data = List();
    var querySnapshot = await FirebaseFirestore.instance.collection("shopping").where("date", isGreaterThan: DateTime.now().subtract(Duration(days: 30))).get();
    querySnapshot.docs.forEach((element) {
      data.add(Shopping.fromFirestore(element.data()));
    });
    for(var shopping in data){
      if(chartData[shopping.user] == null){
        chartData[shopping.user] = {
          "sum": 0,
          "id": shopping.user,
        };
      }
      chartData[shopping.user]["sum"] += shopping.price;
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
          // color: Color(0xff2F4858),
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.only(
            top: 18,
            left: 8,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Tydzień",
                          style: TextStyle(color: Colors.white70),
                        ),
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                            if (states.contains(MaterialState.hovered)) return Colors.white70?.withOpacity(0.04);
                            if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed))
                              return Colors.white70?.withOpacity(0.12);
                            return null;
                          }),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Miesiąc",
                          style: TextStyle(color: Colors.amber),
                        ),
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                            if (states.contains(MaterialState.hovered)) return Colors.white70?.withOpacity(0.04);
                            if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed))
                              return Colors.white70?.withOpacity(0.12);
                            return null;
                          }),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Całość",
                          style: TextStyle(color: Colors.white70),
                        ),
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                            if (states.contains(MaterialState.hovered)) return Colors.white70?.withOpacity(0.04);
                            if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed))
                              return Colors.white70?.withOpacity(0.12);
                            return null;
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  color: Colors.white70,
                  thickness: 0.5,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Wydany pieniądz na miesiąc",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white70),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 10),
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 20,
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
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                  ));
                            }),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) =>
                              const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14),
                          margin: 20,
                          getTitles: (double value) {
                            return users[value.toInt()]["displayName"];
                            switch (value.toInt()) {
                              case 0:
                                return 'Michał';
                              case 1:
                                return 'Wojtek';
                              case 2:
                                return 'Trojan';
                              default:
                                return '';
                            }
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          interval: 5,
                          getTextStyles: (value) => const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border:
                            Border(bottom: BorderSide(color: Colors.white70), left: BorderSide(color: Colors.white70)),
                      ),
                      barGroups: [
                        for(var entry in chartData.values)
                          BarChartGroupData(
                            x: users.indexWhere((element) => element['id'] == entry['id']),
                            barRods: [
                              BarChartRodData(
                                  y: entry['sum'],
                                  colors: [Colors.red[700], Colors.yellow[900]],
                                  width: 18,
                                  borderRadius: BorderRadius.zero)
                            ],
                            showingTooltipIndicators: [0],
                          ),
                        // BarChartGroupData(
                        //   x: 0,
                        //   barRods: [
                        //     BarChartRodData(
                        //         y: 8,
                        //         colors: [Colors.red[700], Colors.yellow[900]],
                        //         width: 18,
                        //         borderRadius: BorderRadius.zero)
                        //   ],
                        //   showingTooltipIndicators: [0],
                        // ),
                        // BarChartGroupData(
                        //   x: 1,
                        //   barRods: [
                        //     BarChartRodData(
                        //         y: 10,
                        //         colors: [Colors.red[700], Colors.yellow[900]],
                        //         width: 18,
                        //         borderRadius: BorderRadius.zero)
                        //   ],
                        //   showingTooltipIndicators: [0],
                        // ),
                        // BarChartGroupData(
                        //   x: 2,
                        //   barRods: [
                        //     BarChartRodData(
                        //         y: 15,
                        //         colors: [Colors.red[700], Colors.yellow[900]],
                        //         width: 18,
                        //         borderRadius: BorderRadius.zero)
                        //   ],
                        //   showingTooltipIndicators: [0],
                        // ),
                      ],
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
