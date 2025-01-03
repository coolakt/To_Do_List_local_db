import 'package:flutter/material.dart';
import 'package:untitled/home_page.dart';
//import 'package:untitled/data/local/db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    //DbHelper db = DbHelper.getInstances;
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
