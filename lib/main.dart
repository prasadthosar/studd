import 'package:flutter/material.dart';
import 'package:studd/pages/home_page..dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: homeScreen(),
    );
  }
}
