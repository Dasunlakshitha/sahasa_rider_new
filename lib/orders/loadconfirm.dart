import 'package:flutter/material.dart';

class LoadConfirm extends StatefulWidget {
  @override
  _LoadConfirmState createState() => _LoadConfirmState();
}

class _LoadConfirmState extends State<LoadConfirm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          for (var i = 0; i < 0; i++)
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: InkWell(
                child: Card(
                  elevation: 4,
                  child: Container(
                    color: Colors.green[50],
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: const <Widget>[
                                Text(
                                  'Pickup Time: ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '2.00 PM',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                            Container(
                              height: 20,
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                color: Colors.green,
                                child: const Text(
                                  'Ready',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const <Widget>[
                            Text(
                              'Order No: ',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '001',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const <Widget>[
                              Text(
                                'Gamigedara, Bandarawela',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              )
                            ]),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const <Widget>[
                            InkWell(
                                onTap: null,
                                child: Text(
                                  "View Details",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {},
              ),
            ),
        ],
      ),
    );
  }
}
