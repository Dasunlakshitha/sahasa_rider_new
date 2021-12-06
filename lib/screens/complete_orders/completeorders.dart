import 'package:flutter/material.dart';

class CompleteOrders extends StatefulWidget {
  const CompleteOrders({Key key}) : super(key: key);

  @override
  _CompleteOrdersState createState() => _CompleteOrdersState();
}

class _CompleteOrdersState extends State<CompleteOrders> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2c3539),
      appBar: _appBar(),
      body: Builder(
        builder: (BuildContext context) {
          return loading
              ? const CircularProgressIndicator(
                  color: Colors.orange,
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.only(left: 20),
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.black12,
      title: const Text('Complete Orders'),
    );
  }
}
