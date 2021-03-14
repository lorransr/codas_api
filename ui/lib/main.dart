import 'package:flutter/material.dart';
import 'package:myanimate/screens/form_page.dart';
import 'package:myanimate/screens/home_page.dart';
import 'package:myanimate/screens/matrix_page.dart';
import 'package:myanimate/screens/result_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CODAS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "/form": (context) => FormPage(),
        "/matrix": (context) => MatrixPage(),
        "/results": (context) => ResultPage()
      },
    );
  }
}
