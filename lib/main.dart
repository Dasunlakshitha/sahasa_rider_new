import 'package:flutter/material.dart';
import 'package:sahasa_rider_new/login.dart';
import 'package:sahasa_rider_new/models/order.dart';
import 'package:sahasa_rider_new/myearnings.dart';
import 'package:sahasa_rider_new/orders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyEarnings(),
    );
  }
}
