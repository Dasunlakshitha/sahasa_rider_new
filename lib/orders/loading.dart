// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../drawer.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool pressAll = true;
  bool pressNew = false;
  bool pressConfirm = false;
  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.black12,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Orders",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(20),
            ),
          ),
          SizedBox(width: 12),
          Row(
            children: <Widget>[
              Text(
                'Available',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(18),
                ),
              ),
              Switch(
                value: true,
                onChanged: (value) {},
                activeColor: Colors.green,
                activeTrackColor: Colors.green[100],
                inactiveTrackColor: Colors.red,
                // inactiveThumbColor: Colors.red,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _formWidget() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),

          // TextFormField(
          //   onSaved: (String value) {
          //     // this._data.username = value;
          //   },
          //   // decoration: const InputDecoration(
          //   //   contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          //   //   enabledBorder: OutlineInputBorder(
          //   //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //   //       borderSide: BorderSide(color: Colors.grey, width: 2)),
          //   //   focusedBorder: OutlineInputBorder(
          //   //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //   //       borderSide: BorderSide(color: Colors.blue, width: 2)),
          //   //   fillColor: Colors.black,
          //   //   hintText: 'Search',
          //   // ),
          // ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _newItems() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Card(
            elevation: 4,
            child: Container(
              color: Colors.white,
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.only(top:5,bottom: 5,left: 15,right: 15),
                    child: Text(
                      'Order No: 001',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(25),
                          fontWeight: FontWeight.bold),
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
                            child: Text(
                              'Reject',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(20),
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.red, width: 2),
                                borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: FlatButton(
                            // color: Colors.blue,
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(20),
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green, width: 2),
                                borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          ),
        );
      }, childCount: 3),
    );
  }

  Widget _searchButtons() {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      height: 40.0,
      child: ListView(
        // shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        addAutomaticKeepAlives: true,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: pressAll ? const Color(0xff3bb143) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(color: const Color(0xff6c757d)),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Center(
                  child: Text(
                    'All',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(15),
                        color: pressAll ? Colors.white : Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              onTap: () {
                //changeCategory('All');
                // _dialog();
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              child: Container(
                  decoration: BoxDecoration(
                    color: pressNew ? Colors.orange : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(
                    //   color: pressNew ? Colors.white : Colors.orange,
                    // )
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Center(
                    child: Text(
                      'New',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(15),
                          color: pressNew ? Colors.white : Colors.orange,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              onTap: () {
                // changeCategory('New');
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              child: Container(
                  decoration: BoxDecoration(
                    color: pressConfirm ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(
                    //     color: pressConfirm ? Colors.white : Colors.blue)
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Center(
                    child: Text(
                      'Confirmed',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(15),
                          color: pressConfirm ? Colors.white : Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              onTap: () {
                // changeCategory('Confirmed');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _confirmItems() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: InkWell(
            child: Card(
              elevation: 4,
              child: Container(
                color: Colors.green[50],
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Pickup Time: ',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(27),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '2.00 PM',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(27),
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
                            child: Text(
                              'Ready',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(20),
                                  color: Colors.white),
                            ),
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Order No: ',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(25),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '001',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(25),
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Gamigedara, Bandarawela',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: ScreenUtil().setSp(25),
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                            onTap: null,
                            child: Text(
                              "View Details",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(20)),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {},
          ),
        );
      }, childCount: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 640, height: 1136);
    return Scaffold(
        backgroundColor: Color(0xff2c3539),
        // body: Center(
        //   child: CircularProgressIndicator(
        //     color: Colors.greenAccent,
        //   ),
        // ),
        appBar: _appBar(),
        body: Shimmer.fromColors(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    // padding: const EdgeInsets.only(
                    //     top: 10, bottom: 10, left: 20, right: 20),
                    child: _searchButtons(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 20, right: 20),
                    alignment: Alignment.topLeft,
                    // margin: EdgeInsets.only(top:10),
                    child: Text(
                      'New Orders(10)',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(18),
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                ),
                //_newItems(),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 5, left: 20, right: 20),
                    alignment: Alignment.topLeft,
                    // margin: EdgeInsets.only(top:10),
                    child: Text(
                      'Confirmed Order(10)',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(15),
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                ),
                // _confirmItems(),
              ],
            ),
            baseColor: Colors.white,
            highlightColor: Colors.grey[200]),
        drawer: const SideDrawer(
          screenNo: 0,
        ));
  }
}
