// ignore_for_file: prefer_const_constructors, no_logic_in_create_state
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sahasa_rider_new/api/api.dart';
import 'package:sahasa_rider_new/drawer.dart';
import 'package:sahasa_rider_new/models/completeOrders.dart';
import 'package:sahasa_rider_new/models/orders.dart';
import 'package:sahasa_rider_new/oneorder/oneorder.dart';
import 'package:sahasa_rider_new/screens/connection_check/connection_check.dart';
import 'package:sahasa_rider_new/toast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_offline/flutter_offline.dart';

class AllOrders extends StatefulWidget {
  final int screenNum;

  const AllOrders({Key key, @required this.screenNum}) : super(key: key);

  @override
  _AllOrdersState createState() => _AllOrdersState(screenNum);
}

class _AllOrdersState extends State<AllOrders> {
  final int screenNum;
  _AllOrdersState(this.screenNum);
  int ordercount;

  bool pressAll = true;
  bool pressDelivered = false;
  List<DateTime> pickedDates;
  final ScrollController _sc = ScrollController();
  List<Body> orders = List<Body>();
  bool loading = true;
  CompleteOrder data = CompleteOrder();
  OrdersMdl dataOrders = OrdersMdl();
  bool loadingMore = false;
  bool loadingSearch = false;
  bool isConnected = false;
  bool loadingDate;

  @override
  void initState() {
    super.initState();

    getData(false);
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        moreData();
      }
    });
  }

  getData(status) async {
    dataOrders = await Api().completedOrders(context, data);
    if (dataOrders.message != null) {
      errorMessage(dataOrders.message);
      setState(() {
        loading = false;
        loadingDate = false;
      });
    } else {
      setState(() {
        loading = false;
        loadingDate = false;
        if (status) {
          orders = orders + dataOrders.body;
        } else {
          orders = dataOrders.body;
        }
      });
    }
  }

  moreData() async {
    setState(() {
      loadingMore = true;
      data.offset += data.limit;
    });
    await getData(true);
    setState(() {
      loadingMore = false;
    });
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.black12,
      title: Row(
        children: <Widget>[
          Text(
            "Completed Orders",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(30),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Spacer(),
          Text(
            "Orders : 0" + orderCount().toString(),
            style: TextStyle(
                fontSize: 25.sp,
                color: Colors.white70,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Future _openStartDate() async {
    var datePicked = await showDatePicker(
      context: context,
      initialDate: data.startDate,
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    );
    if (datePicked == null) return;
    setState(() {
      data.startDate = datePicked;
      data.offset = 0;
    });
    orders.clear();
    getData(false);
    loadingDate = true;
  }

  Future _openEndDate() async {
    var datePicked = await showDatePicker(
      context: context,
      initialDate: data.endDate,
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    );
    if (datePicked == null) return;
    setState(() {
      data.endDate = datePicked;
      data.offset = 0;
    });
    orders.clear();
    getData(false);
    loadingDate = true;
  }

  Widget _search() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blue),
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: TextButton(
                      onPressed: () {
                        _openStartDate();
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Text(
                              getStartDate(),
                              style: TextStyle(
                                  fontSize: 23.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.white,
                              size: 23.sp,
                            )
                          ],
                        ),
                      ),
                    )),
                Text(
                  '   -   ',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(25),
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blue),
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: TextButton(
                      onPressed: () {
                        _openEndDate();
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Text(
                              getLastDate(),
                              style: TextStyle(
                                  fontSize: 23.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.white,
                              size: 23.sp,
                            ),
                          ],
                        ),
                      ),
                    )),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        ),
        //_searchDates(),
      ],
    );
  }

  getLastDate() {
    if (data.endDate == null) {
      return 'end date';
    } else {
      return Jiffy(data.endDate).format('MMM do yy');
    }
  }

  getStartDate() {
    if (data.endDate == null) {
      return 'start date';
    } else {
      return Jiffy(data.startDate).format('MMM do yy');
    }
  }

  Widget _cardDet(item) {
    Color backColor;
    Color statusColor;
    if (item.status == 'Returned') {
      backColor = Colors.red[50];
      statusColor = Colors.red;
    } else {
      backColor = Colors.orange[50];
      statusColor = Colors.orange;
    }

    return Card(
      color: Colors.transparent,
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: backColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              //blurRadius: 20.0,
            ),
          ],
        ),
        padding:
            const EdgeInsets.only(top: 10, bottom: 15, left: 15, right: 15),
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
                          fontSize: ScreenUtil().setSp(25),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Jiffy(item.deliveryTime).format('MM-dd h:mm a'),
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(23),
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
                Container(
                  // height: 20,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: FlatButton(
                    padding: EdgeInsets.all(5),
                    color: statusColor,
                    child: Text(
                      item.status,
                      textAlign: TextAlign.center,
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
            const SizedBox(
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
                  item.orderNo.toString(),
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(23),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ],
            ),
            Divider(),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                item.address,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: ScreenUtil().setSp(23),
                    fontWeight: FontWeight.bold),
              ),
            ),
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
    );
  }

  orderCount() {
    ordercount = orders.length.toInt();
    return ordercount;
  }

  Widget _orders() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: MediaQuery.of(context).size.height - 200,
      child: ListView.builder(
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        itemCount: orders.length,
        controller: _sc,
        itemBuilder: (BuildContext ctxt, int index) {
          return Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: InkWell(
                  child: _cardDet(orders[index]),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OneOrder(
                                  id: orders[index].id,
                                  orderNo: '',
                                )));
                  },
                ),
              ),
              index == orders.length - 1
                  ? Visibility(
                      child: const CircularProgressIndicator(),
                      visible: loadingMore,
                    )
                  : Container()
            ],
          );
        },
      ),
    );
  }

  // Shimmer
  Widget cardDetShimmer(item) {
    Color backColor = Colors.black;
    Color statusColor = Colors.black;

    return Card(
      elevation: 4,
      child: Container(
        color: backColor,
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
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
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
                Container(
                  // height: 20,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: FlatButton(
                    padding: EdgeInsets.all(5),
                    color: statusColor,
                    child: Text(
                      '',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white),
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
              children: const <Widget>[
                Text(
                  'Order No: ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  '',
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
                    '',
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
    );
  }

  Widget _ordersShimmer() {
    return Shimmer.fromColors(
        child: ListView.builder(
            shrinkWrap: true,
            addAutomaticKeepAlives: true,
            itemCount: 3,
            controller: _sc,
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                padding: const EdgeInsets.only(left: 20, right: 24),
                child: InkWell(
                  child: cardDetShimmer('data'),
                  onTap: () {},
                ),
              );
            }),
        baseColor: Colors.white,
        highlightColor: Colors.grey[200]);
  }

  setConnect(connected) {
    Future.delayed(Duration.zero, () async {
      setState(() {
        isConnected = connected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(640, 1136),
        orientation: Orientation.portrait);

    return Builder(builder: (BuildContext context) {
      return OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          if (connectivity == ConnectivityResult.none) {
            return NoConnection();
          } else {
            return child;
          }
        },
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: const Color(0xff2c3539),
            appBar: _appBar(),
            body: Builder(
              builder: (BuildContext context) {
                return OfflineBuilder(
                  connectivityBuilder: (
                    BuildContext context,
                    ConnectivityResult connectivity,
                    Widget child,
                  ) {
                    if (connectivity == ConnectivityResult.none) {
                      return NoConnection();
                    } else {
                      return child;
                    }
                  },
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    // padding: const EdgeInsets.only(left: 15),
                                    color: Colors.transparent,
                                    child: _search(),
                                  ),
                                ],
                              ),
                              loadingDate
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.4,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.orange,
                                        ),
                                      ),
                                    )
                                  : orders.isEmpty
                                      ? SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              1.4,
                                          child: Center(
                                            child: Text(
                                              "No Data",
                                              style: TextStyle(
                                                  fontSize: 22.sp,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      : _orders(),
                            ],
                          ),
                        ),
                );
              },
            ),
            drawer: SideDrawer(
              screenNo: screenNum,
            ),
          );
        },
      );
    });
  }
}
