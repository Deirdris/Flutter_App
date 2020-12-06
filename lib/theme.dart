import 'package:flutter/material.dart';

const MaterialColor blueGrey = MaterialColor(
  _blueGreyPrimaryValue,
  <int, Color>{
    50: Color(_blueGreyPrimaryValue),
    100: Color(_blueGreyPrimaryValue),
    200: Color(_blueGreyPrimaryValue),
    300: Color(_blueGreyPrimaryValue),
    400: Color(_blueGreyPrimaryValue),
    500: Color(_blueGreyPrimaryValue),
    600: Color(_blueGreyPrimaryValue),
    700: Color(_blueGreyPrimaryValue),
    800: Color(_blueGreyPrimaryValue),
    900: Color(_blueGreyPrimaryValue),
  },
);
const int _blueGreyPrimaryValue = 0xFF263238;

final theme = ThemeData(
  errorColor: Colors.red[900],
  scaffoldBackgroundColor: Colors.blueGrey[100],
  appBarTheme: AppBarTheme(
    color: Colors.blueGrey[900],
  ),
  primaryColor: blueGrey,
  primarySwatch: blueGrey,
  // accentColor: Colors.blueGrey[900],
  buttonTheme: ButtonThemeData(
    buttonColor: blueGrey,
  ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.blueGrey[900],
      unselectedItemColor: Colors.blueGrey[600],
      selectedItemColor: Colors.blueGrey[100],
    ),
);