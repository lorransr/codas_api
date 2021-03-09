import 'dart:developer';

import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:myanimate/screens/form_page.dart';
import 'package:myanimate/screens/matrix_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CODAS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => FormPage(),
        "/matrix": (context) => MatrixPage()
      },
      // home: MyHomePage(title: 'CODAS METHOD'),
    );
  }
}
