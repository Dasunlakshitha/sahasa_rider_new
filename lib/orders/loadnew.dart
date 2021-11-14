import 'package:flutter/material.dart';

class LoadingNew extends StatefulWidget {
  @override
  _LoadingNewState createState() => _LoadingNewState();
}

class _LoadingNewState extends State<LoadingNew> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          for (var i = 0; i < 0; i++)
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Card(
                elevation: 4,
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        // padding: EdgeInsets.only(top:5,bottom: 5,left: 15,right: 15),
                        child: const Text(
                          'Order No: 001',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: FlatButton(
                                // color: Colors.blue,
                                child: const Text(
                                  'Reject',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.red, width: 2),
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: FlatButton(
                                // color: Colors.blue,
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.green, width: 2),
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
            ),
        ],
        // ),
      ),
    );
  }
}
