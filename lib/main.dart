import 'package:chores_flutter/bootstrap.dart';
import 'package:chores_flutter/routes.dart';
import 'package:chores_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: GetMaterialApp(
        // onGenerateRoute: (settings) {
        //   if (routes[settings.name] != null) {
        //     return PageRouteBuilder(
        //       settings: settings,
        //       pageBuilder: (context, __, ___) => routes[settings.name].builder(context),
        //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //         return FadeTransition(opacity: animation, child: child);
        //         // return SlideTransition(
        //         //     position: Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero)
        //         //         .animate(CurvedAnimation(parent: animation, curve: Curves.linear)),
        //         //     child: child);
        //       },
        //     );
        //   }
        //   return MaterialPageRoute(builder: (_) => Container());
        // },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('pl', 'PL'),
        ],
        home: Bootstrap(),
        routes: routes.map((key, value) => MapEntry(key, value.builder)),
        theme: theme,
        title: 'Madzia brzeska apka',
      ),
    );
  }
}
