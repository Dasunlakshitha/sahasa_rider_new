// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sahasa_rider_new/api/api.dart';
import 'package:sahasa_rider_new/drawer.dart';
import 'package:sahasa_rider_new/screens/connection_check/connection_check.dart';
import 'package:sahasa_rider_new/models/earning.dart';
import 'package:sahasa_rider_new/models/earnings.dart';
import 'package:sahasa_rider_new/toast.dart';
import 'package:jiffy/jiffy.dart';

import 'package:flutter_offline/flutter_offline.dart';

class MyEarnings extends StatefulWidget {
  final int screenNum;

  const MyEarnings({Key key, @required this.screenNum}) : super(key: key);

  @override
  _MyEarningsState createState() => _MyEarningsState(screenNum);
}

class _MyEarningsState extends State<MyEarnings> {
  final int screenNum;
  _MyEarningsState(this.screenNum);
  Earnings data = Earnings();
  Earning earning = Earning();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    Earning earningData = await Api().getEarnings(context, data);
    if (earningData.message != null) {
      errorMessage(earningData.message);
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
        earning = earningData;
      });
    }
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.black12,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "My Earnings",
            style: TextStyle(
              fontSize: 30.sp,
            ),
          ),
        ],
      ),
    );
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
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5)),
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: TextButton(
                    onPressed: () {
                      _openStartDate();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Text(
                            getStartDate(),
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  '   -   ',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(25),
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5)),
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: TextButton(
                    onPressed: () {
                      _openEndDate();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Text(
                            getLastDate(),
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
    if (data.startDate == null) {
      return 'start date';
    } else {
      return Jiffy(data.startDate).format('MMM do yy');
    }
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
    });
    earning.body.items.clear();
    getData();
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
    });
    earning.body.items.clear();
    getData();
  }

  Widget summery() {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Cash on delivery',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(25),
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Card(
            //color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: Colors.green[100],
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Delivery(${earning.body.totalCashOrders.toString()})',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(23),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              // alignment: Alignment(1, 0),
                              child: Text(
                                'Rs. ${earning.body.totalCashDelivery.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(25),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700]),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Text(
                                '${earning.body.totalCashDelivery.toStringAsFixed(2)} X 100%',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(18),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Pick and Drop(${earning.body.totalPickup != null ? earning.body.totalPickup.toString() : 0})',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(23),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              // alignment: Alignment(1, 0),
                              child: Text(
                                'Rs. ${earning.body.pickCash != null ? (earning.body.pickCash * 0.8).toStringAsFixed(2) : 0.00}',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(25),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700]),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Text(
                                '${earning.body.pickCash != null ? earning.body.pickCash.toStringAsFixed(2) : 0.00} x 80%',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(18),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Total Bonus',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(23),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              // alignment: Alignment(1, 0),
                              child: Text(
                                'Rs. ${earning.body.totalCashBonus.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(25),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Total Earnings',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(23),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              // alignment: Alignment(1, 0),
                              child: Text(
                                'Rs. ${(earning.body.totalCashDelivery + earning.body.totalCashBonus).toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(25),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Online Payments',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(25),
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Card(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: Colors.blue[100],
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Delivery(${earning.body.totalOnlineOrders.toString()})',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(23),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              // alignment: Alignment(1, 0),
                              child: Text(
                                'Rs. ${earning.body.totalOnlineDelivery.toString()}',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(25),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700]),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              child: Text(
                                '${earning.body.totalOnlineDelivery} X 100%',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(18),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Total Bonus',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(23),
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Rs. ${earning.body.totalOnlineBonus.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(25),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700]),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Total Earnings',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(23),
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Rs. ${(earning.body.totalOnlineDelivery + earning.body.totalOnlineBonus).toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(25),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Cash in Hand',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(22),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Rs. ${(earning.body.orderCash - earning.body.onlineCash).toStringAsFixed(2)}',
                  // "001",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(22),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Delivery Charge',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(22),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '-Rs. ${earning.body.deliveryCash.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(22),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total Bonus',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(22),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '-Rs. ${(earning.body.totalOnlineBonus + earning.body.totalCashBonus).toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(22),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Cash Balance',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(22),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Rs. ${((earning.body.orderCash - earning.body.onlineCash) - (earning.body.deliveryCash + earning.body.totalOnlineBonus + earning.body.totalCashBonus)).toStringAsFixed(2)}',
                  //"100",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(22),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget details() {
    return Column(
      children: <Widget>[
        for (int i = earning.body.items.length - 1; i >= 0; i--)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text(
                    Jiffy(earning.body.items[i].orderDate).format('MMM do yy'),
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(25),
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
                color: Colors.blue,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Cash on delivery',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(25),
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Card(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: Colors.green[50],
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    'Delivery(${earning.body.items[i].totalCashOrders.toString()})',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(23),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  // alignment: Alignment(1, 0),
                                  child: Text(
                                    'Rs. ${earning.body.items[i].totalCashDelivery.toStringAsFixed(2)}',
                                    //'Rs. ${this.earning.body.totalCashDelivery.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(25),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text(
                                    '${earning.body.items[i].totalCashDelivery.toStringAsFixed(2)} X 100%',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(18),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    'Pick and Drop()',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(23),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  // alignment: Alignment(1, 0),
                                  child: Text(
                                    'Rs. ${earning.body.items[i].pickCash.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(25),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Text(
                                    '${earning.body.pickCash} X 80%',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(18),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    'Total Bonus',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(23),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  // alignment: Alignment(1, 0),
                                  child: Text(
                                    'Rs. ${earning.body.items[i].cashBonus.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(25),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    'Total Earnings',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(23),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  // alignment: Alignment(1, 0),
                                  child: Text(
                                    //'Rs. ${(this.earning.body.items[i].cashBonus + this.earning.body.items[i].deliveryCash).toStringAsFixed(2)}',
                                    'Rs. ${(earning.body.items[i].totalCashDelivery + earning.body.items[i].cashBonus).toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(25),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Online Payments',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(25),
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Card(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: Colors.blue[50],
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        //blurRadius: 20.0,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    'Delivery(${earning.body.items[i].totalOnlineOrders.toString()})',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(23),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  // alignment: Alignment(1, 0),
                                  child: Text(
                                    'Rs. ${this.earning.body.items[i].totalOnlineDelivery.toString()}',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(25),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  child: Text(
                                    '${earning.body.items[i].totalOnlineDelivery} X 100%',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(18),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    'Total Bonus',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(23),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  // alignment: Alignment(1, 0),
                                  child: Text(
                                    'Rs. ${earning.body.items[i].onlineBonus.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(25),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    'Total Earnings',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(23),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  // alignment: Alignment(1, 0),
                                  child: Text(
                                    'Rs. ${(earning.body.items[i].totalOnlineDelivery + earning.body.items[i].onlineBonus).toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(25),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Cash in Hand',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: ScreenUtil().setSp(22),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // alignment: Alignment(1, 0),
                      child: Text(
                        'Rs. ${(earning.body.items[i].orderCash - earning.body.items[i].onlineCash).toStringAsFixed(2)}',
                        // "001",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(22),
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Delivery Charge',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: ScreenUtil().setSp(22),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // alignment: Alignment(1, 0),
                      child: Text(
                        '-Rs. ${earning.body.items[i].deliveryCash.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(22),
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Total Bonus',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: ScreenUtil().setSp(22),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      // alignment: Alignment(1, 0),
                      child: Text(
                        '-Rs. ${(earning.body.items[i].onlineBonus + earning.body.items[i].cashBonus).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(22),
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Cash Balance',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: ScreenUtil().setSp(22),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Rs. ${((earning.body.items[i].orderCash - earning.body.items[i].onlineCash) - (earning.body.items[i].deliveryCash + earning.body.items[i].onlineBonus + earning.body.items[i].cashBonus)).toStringAsFixed(2)}',
                      //"100",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(22),
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
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
          builder: (BuildContext context) {
            ScreenUtil.init(
                BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                    maxHeight: MediaQuery.of(context).size.height),
                designSize: const Size(640, 1136),
                orientation: Orientation.portrait);
            return Scaffold(
              backgroundColor: const Color(0xff2c3539),
              appBar: _appBar(),
              body: SingleChildScrollView(
                child: loading
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              // padding: const EdgeInsets.only(left: 15),
                              color: Colors.transparent,
                              child: _search(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(5)),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Summary',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(25),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  summery(),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Details',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(25),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  details(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              drawer: SideDrawer(
                screenNo: screenNum,
              ),
            );
          },
        );
      },
    );
  }
}
