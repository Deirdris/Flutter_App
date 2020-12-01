import 'package:chores_flutter/routes.dart';
import 'package:chores_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => JobsModel()),
      ChangeNotifierProvider(create: (context) => CartModel()),
    ],
    child: MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if(!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null){
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        initialRoute: '/job',
        routes: routes.map((key, value) => MapEntry(key, value.builder)),
        theme: theme,
        title: 'Madzia brzeska apka',
      ),
    );
  }
}

