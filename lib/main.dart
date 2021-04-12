import 'package:evdspidata/screens/homePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'evdsPiData',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      
        primarySwatch: Colors.blueGrey,
       
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

