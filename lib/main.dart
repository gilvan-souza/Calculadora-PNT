import 'package:flutter/material.dart';
import 'screens/calc_app.dart';
import 'themes/theme_dark.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      theme: darkTheme,
      home: Calculator(),
    );
  }
}
