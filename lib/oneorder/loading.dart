import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.black12,
      title: Text(
        'Order',
        style: TextStyle(fontSize: 22),
      ),
    );
  }

  Widget _deliveryDet() {
    return Container(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      color: Colors.green,
                      child: Text(
                        'Ready',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Order No: ',
                      style: TextStyle(
                          fontSize: (20), fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '001',
                      style: TextStyle(
                          fontSize: (20),
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ]),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Pickup Time: ',
                    style:
                        TextStyle(fontSize: (27), fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '2.00 PM',
                    style: TextStyle(
                        fontSize: (27),
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Text(
                    'Deliver to : ',
                    style:
                        TextStyle(fontSize: (20), fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'No 234, Badulla Road, Bandrawela.',
                    style: TextStyle(
                        fontSize: (20),
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _items() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
      child: Column(
        children: <Widget>[
          Container(
            child: Card(
              elevation: 3,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Image(
                          width: MediaQuery.of(context).size.width * 0.2,
                          image: NetworkImage(
                              'https://s3.us-west-2.amazonaws.com/cdn.lankanstore/item_images/156552dd-c4d1-4494-ac69-9bfc3eb25d1a/43eeea14-4862-40a6-81a5-ce1e61722b2a.jpeg'),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Rice & Curry with Fish',
                                style: TextStyle(
                                    fontSize: (18),
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Qty 2',
                                style: TextStyle(
                                    fontSize: (18),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            color: Colors.green,
                            child: Text(
                              'Ready',
                              style: TextStyle(
                                  fontSize: (20), color: Colors.white),
                            ),
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: Card(
              elevation: 3,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Image(
                          width: MediaQuery.of(context).size.width * 0.2,
                          image: NetworkImage(
                              'https://s3.us-west-2.amazonaws.com/cdn.lankanstore/item_images/156552dd-c4d1-4494-ac69-9bfc3eb25d1a/43eeea14-4862-40a6-81a5-ce1e61722b2a.jpeg'),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Rice & Curry with Fish',
                                style: TextStyle(
                                    fontSize: (18),
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Qty 2',
                                style: TextStyle(
                                    fontSize: (18),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            color: Colors.green,
                            child: Text(
                              'Ready',
                              style: TextStyle(
                                  fontSize: (20), color: Colors.white),
                            ),
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //ScreenUtil.init(context, width: 640, height: 1136);

    return Scaffold(
      backgroundColor: Color(0xff2c3539),
      appBar: _appBar(),
      // body: Shimmer.fromColors(
      //     child: SingleChildScrollView(
      //       padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      //       child: Column(
      //         children: <Widget>[
      //           Text(
      //             'Delivery Details',
      //             style: TextStyle(
      //                 fontSize: (27),
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.black54),
      //           ),
      //           _deliveryDet(),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           Container(
      //             alignment: Alignment.centerLeft,
      //             child: Text(
      //               'Items',
      //               style: TextStyle(
      //                   fontSize: (20),
      //                   fontWeight: FontWeight.bold,
      //                   color: Colors.black54),
      //             ),
      //           ),
      //           _items(),
      //         ],
      //       ),
      //     ),
      //     baseColor: Colors.white,
      //     highlightColor: Colors.grey[200]),
      // ),
      //   ),
      // ],
    );
  }
}
