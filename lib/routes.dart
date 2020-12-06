import 'package:chores_flutter/pages/chart_list.dart';
import 'package:chores_flutter/pages/chores_page.dart';
import 'package:chores_flutter/pages/shopping_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteEntry {
  RouteEntry({ this.title, this.builder, this.icon,});

  final String title;
  final WidgetBuilder builder;
  final IconData icon;
}

final routes = {
  '/job': RouteEntry(
    title: 'Robota',
    builder: (context) => ChoresPage(),
    icon: Icons.shopping_cart_outlined,
  ),
  '/shopping': RouteEntry(
    title: 'Lista zakupów',
    builder: (context) => ShoppingPage(),
    icon: Icons.cleaning_services_outlined,
  ),
  '/charts': RouteEntry(
    title: 'Wykresiki',
    builder: (context) => ChartList(),
    icon: Icons.bar_chart,
  ),
};