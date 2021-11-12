import 'package:flutter/material.dart';

class MyEarnings extends StatefulWidget {
  const MyEarnings({Key key}) : super(key: key);

  @override
  _MyEarningsState createState() => _MyEarningsState();
}

class _MyEarningsState extends State<MyEarnings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2c3539),
      appBar: _appBar(),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.black12,
      title: const Text('Myearnings'),
    );
  }
}
