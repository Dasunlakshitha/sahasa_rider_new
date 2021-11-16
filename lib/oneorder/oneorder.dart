// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sahasa_rider_new/api/api.dart';
import 'package:sahasa_rider_new/connection_check/connection_check.dart';
import 'package:sahasa_rider_new/helpers/calculateDistance.dart';
import 'package:sahasa_rider_new/helpers/localvariables.dart';
import 'package:sahasa_rider_new/helpers/sendfirebase.dart';
import 'package:sahasa_rider_new/models/accept.dart';
import 'package:sahasa_rider_new/models/order.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:background_geolocation_plugin/background_geolocation_plugin.dart';
import 'package:background_geolocation_plugin/location_item.dart';

import 'package:flutter_offline/flutter_offline.dart';

import '../toast.dart';

class OneOrder extends StatefulWidget {
  final String id;
  final String orderNo;
  OneOrder({Key key, @required this.id, @required this.orderNo})
      : super(key: key);

  @override
  _OneOrderState createState() => _OneOrderState(this.id, this.orderNo);
}

class _OneOrderState extends State<OneOrder> {
  final String id;
  final String orderNo;

  _OneOrderState(this.id, this.orderNo);

  String returnNote = '';
  Order order = Order();
  bool loading = true;
  bool loadingUpdate = false;
  AcceptOrder update = AcceptOrder();
  String buttonStatus;
  double totalDistance = 0;
  // List points = [];

  @override
  initState() {
    super.initState();
    getData();
  }

  final String startLocation = 'start';
  List points = [];
  List<LocationItem> allLocations = [];

  calTotalDistance() async {
    List<LocationItem> items =
        await BackgroundGeolocationPlugin.getAllLocations();
    if (items != null && items.length > 0) {
      for (var i = 0; i < items.length - 1; i++) {
        totalDistance += calculateDistance(items[i].latitude,
            items[i].longitude, items[i + 1].latitude, items[i + 1].longitude);
      }
    }

    points = [];
    AcceptOrder updateData = await Api().updateOrderDistance(totalDistance, id);

    if (updateData.message != null) {
      errorMessage(updateData.message);
    } else {
      successMessage('Successfully Completed.');
    }
  }

  startLocationTrack() async {
    await BackgroundGeolocationPlugin.requestPermissions();
    var currentState = await BackgroundGeolocationPlugin.getState();
    // print(currentState.permissionGranted);
    if (currentState.permissionGranted) {
      if (!currentState.isRunning) {
        await BackgroundGeolocationPlugin.startLocationTracking();
      }
    }
  }

  stopLocationTrack() async {
    var currentState = await BackgroundGeolocationPlugin.getState();
    // print(currentState);
    if (currentState.isRunning) {
      await BackgroundGeolocationPlugin.stopLocationTracking();
    }
  }

  getData() async {
    order = await Api().getOrder(context, id);
    if (order.message != null) {
      errorMessage(order.message);
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        order = order;
        loading = false;
      });
    }
  }

  changeStatus() async {
    setState(() {
      loadingUpdate = true;
    });
    update = await Api().updateOrder(context, buttonStatus, returnNote, id);
    if (update.message != null) {
      errorMessage(update.message);
    } else {
      successMessage('Successfully Changed.');
    }

    getData();

    if (buttonStatus == 'On the way') {
      // initBackground();
      await saveStringValue('orderNo', orderNo);
      await saveStringValue('orderId', id);
      points = [];
      startLocationTrack();
    }
    if (buttonStatus == 'Delivered') {
      stopLocationTrack();
      await calTotalDistance();
      await removeStringValue('points');
    }

    setState(() {
      loadingUpdate = false;
    });
  }

  Widget _appBar() {
    Color statusColor;
    if (order.body.orderStatus == 'Ready') {
      statusColor = Colors.green;
    } else if (order.body.orderStatus == "Being Prepared") {
      statusColor = Colors.blue;
    } else if (order.body.orderStatus == "On the way") {
      statusColor = Colors.orange;
    } else if (order.body.orderStatus == "Delivered") {
      statusColor = Colors.lightGreen;
    } else {
      statusColor = Colors.red;
    }

    return AppBar(
      backgroundColor: Colors.black12,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Order(${order.body.orderNo})',
            style: const TextStyle(fontSize: (18)),
          ),
          Container(
            // height: 20,
            width: MediaQuery.of(context).size.width * 0.2,
            child: FlatButton(
              padding: const EdgeInsets.all(0),
              color: statusColor,
              child: Text(
                order.body.orderStatus,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: (14), color: Colors.white),
              ),
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deliveryDet() {
    Color backColor;
    var orderTime = Jiffy(order.body.deliveryTime).format('h:mm a');
    var orderDate = Jiffy(order.body.deliveryTime).format('yyyy/MM/dd');
    var today = Jiffy(DateTime.now()).format('yyyy/MM/dd');

    return Container(
      child: Card(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.green[50],
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    // ignore: prefer_const_constructors
                    child: Text(
                      'Delivery Address: ',
                      style: const TextStyle(
                          fontSize: (15), fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.46,
                    child: Text(
                      this.order.body.address,
                      style: const TextStyle(
                          fontSize: (15),
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Text(
                      'Delivery Time: ',
                      style: TextStyle(
                          fontSize: (15), fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.46,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          orderDate,
                          style: TextStyle(
                              fontSize: (15),
                              fontWeight: FontWeight.bold,
                              color: today == orderDate
                                  ? Colors.black
                                  : Colors.red),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          orderTime,
                          style: TextStyle(
                              fontSize: (15),
                              fontWeight: FontWeight.bold,
                              color: today == orderDate
                                  ? Colors.black
                                  : Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Order No: ',
                          style: TextStyle(
                              fontSize: (15), fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          this.order.body.orderNo.toString(),
                          style: TextStyle(
                              fontSize: (15),
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ]),
              SizedBox(
                height: 5,
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Phone No: ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: (15),
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        this.order.body.contactNo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: (15),
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: FlatButton(
                      color: Colors.blue,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.call,
                            color: Colors.white,
                            size: (15),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Call',
                            style: TextStyle(
                                fontSize: (15),
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _getCall(this.order.body.contactNo);
                      },
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(item) {
    Color statusColor;
    if (item.itemStatus == 'New') {
      statusColor = Colors.orange;
    } else if (item.itemStatus == 'Confirmed') {
      statusColor = Colors.blue;
    } else if (item.itemStatus == 'Ready') {
      statusColor = Colors.green;
    } else if (item.itemStatus == 'Issued') {
      statusColor = Colors.deepPurple;
    } else if (item.itemStatus == 'Canceled') {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.red;
    }
    return Container(
      child: Card(
        elevation: 1,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Image(
                  //   width: MediaQuery.of(context).size.width * 0.2,
                  //   image: NetworkImage(
                  //       this.order.body.items[i]
                  //       'https://s3.us-west-2.amazonaws.com/cdn.lankanstore/item_images/156552dd-c4d1-4494-ac69-9bfc3eb25d1a/43eeea14-4862-40a6-81a5-ce1e61722b2a.jpeg'),
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.name,
                          style: const TextStyle(
                              fontSize: (13), fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${item.unit} x ${item.quantity}',
                          style: const TextStyle(
                              fontSize: (18), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // height: 20,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      color: statusColor,
                      child: Text(
                        item.itemStatus,
                        style: TextStyle(fontSize: (15), color: Colors.white),
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
    );
  }

  Widget _partners(partner) {
    var orderDateNo = Jiffy(order.body.deliveryTime).subtract(minutes: 25);
    // var orderDate = Jiffy(orderDateNo).format('yyyy/MM/dd');
    var deliveryTime = Jiffy(orderDateNo).format('h:mm a');
    var deliveryDate = Jiffy(orderDateNo).format('yyyy/MM/dd');
    var today = Jiffy(DateTime.now()).format('yyyy/MM/dd');
    // var deliveryTime = Jiffy(this.order.body.deliveryTime).format('h:mm a');
    return Container(
      child: Card(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.blue[50],
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.27,
                    child: const Text(
                      'Store Name: ',
                      style: TextStyle(
                        fontSize: (18),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      partner.name,
                      style: TextStyle(
                          fontSize: (18),
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.27,
                    child: const Text(
                      'Pickup Time: ',
                      style: TextStyle(
                        fontSize: (15),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          deliveryDate,
                          style: TextStyle(
                              fontSize: (15),
                              fontWeight: FontWeight.bold,
                              color: today == deliveryDate
                                  ? Colors.black
                                  : Colors.red),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          deliveryTime,
                          style: TextStyle(
                              fontSize: (15),
                              fontWeight: FontWeight.bold,
                              color: today == deliveryDate
                                  ? Colors.black
                                  : Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text(
                        'Phone No: ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: (15),
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        partner.contactNo != null ? partner.contactNo : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: (15),
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 30,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: FlatButton(
                      color: Colors.blue,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.call,
                            color: Colors.white,
                            size: (20),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Call',
                            style: TextStyle(
                                fontSize: (15),
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _getCall(partner.contactNo);
                      },
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              for (var i = 0; i < partner.orderItems.length; i++)
                _item(partner.orderItems[i])
            ],
          ),
        ),
      ),
    );
  }

  Widget _items() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
      child: Column(
        children: <Widget>[
          for (var i = 0; i < this.order.body.items.length; i++)
            _partners(this.order.body.items[i])
          // for (var i = 0; i < this.order.body.items.length; i++)
          //   _item(this.order.body.items[i])
        ],
      ),
    );
  }

  _getCall(number) async {
    if (await canLaunch('tel:$number')) {
      await launch('tel:$number');
    } else {
      print('cannot launch');
    }
  }

  _update(status) async {
    if (status == 'Returned' || status == 'Delivered') {
      await SendUser().deleteDeliveryToken(this.id);
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Container(
          padding: EdgeInsets.all(15),
          // color: Colors.green,
          alignment: Alignment.center,
          child: status == 'Returned'
              ? Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'This will return the Order',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: (30)),
                        ),
                        Icon(
                          Icons.warning,
                          size: (40),
                          color: Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Please Confirm.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: (30)),
                    ),
                  ],
                )
              : Text(
                  'Please Confirm.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: (30)),
                ),
        ),
        backgroundColor: Colors.white,
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: status == 'Returned'
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Return Note',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: (25),
                          color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        setState(() {
                          this.returnNote = value;
                        });
                      },
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                    ),
                  ],
                )
              : Text(''),
          margin: EdgeInsets.only(bottom: 10, left: 12, right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        // ),
        actions: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  color: Colors.red,
                  child: Text(
                    'No',
                    style: TextStyle(
                        fontSize: (20),
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                ),
                FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  color: Colors.green,
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        fontSize: (20),
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    changeStatus();
                  },
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _bottom() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Subtotal',
                style: TextStyle(
                    fontSize: (18),
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
              Text(
                'Rs. ${num.parse(this.order.body.subTotal).toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: (18),
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.only(top: 5),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Delivery Fee',
                style: TextStyle(
                    fontSize: (18),
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
              Text(
                'Rs. ${num.parse(order.body.distanceValue).toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: (18),
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
            ],
          ),
        ),
        if (order.body.convenienceFee != '0')
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(top: 5),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Convenience Fee',
                  style: TextStyle(
                      fontSize: (18),
                      fontWeight: FontWeight.bold,
                      color: Colors.white70),
                ),
                Text(
                  'Rs. ${num.parse(order.body.convenienceFee).toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: (18),
                      fontWeight: FontWeight.bold,
                      color: Colors.white70),
                ),
              ],
            ),
          ),
        Divider(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Grand total',
                style: TextStyle(
                    fontSize: (20),
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
              Text(
                'Rs. ${(num.parse(order.body.convenienceFee) + num.parse(order.body.distanceValue) + num.parse(this.order.body.subTotal)).toStringAsFixed(2)}',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: (20),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Paid Amount',
                style: TextStyle(
                    fontSize: (18),
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
              Text(
                'Rs. ${(num.parse(order.body.convenienceFee) + num.parse(order.body.distanceValue) + num.parse(this.order.body.subTotal) - num.parse(this.order.body.remain)).toStringAsFixed(2)}',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: (18),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
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
            return Container(
              color: Color(0xff2c3539),
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Scaffold(
                      backgroundColor: Color(0xff2c3539),

                      appBar: _appBar(),
                      body: LoadingOverlay(
                        progressIndicator: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        color: Colors.black,
                        isLoading: loadingUpdate,
                        child: SingleChildScrollView(
                          padding:
                              EdgeInsets.only(top: 10, left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Delivery Details',
                                style: TextStyle(
                                    fontSize: (18),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70),
                              ),
                              _deliveryDet(),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Pickup Details',
                                  style: TextStyle(
                                      fontSize: (18),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70),
                                ),
                              ),
                              _items(),
                              _bottom(),
                              SizedBox(height: 5)
                            ],
                          ),
                        ),
                      ),
                      persistentFooterButtons: <Widget>[
                        // Divider(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          margin: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                'Remaining Amount',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: (15),
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Rs. ${num.parse(order.body.remain).toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: (15),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        if (order.body.remain == '0')
                          Row(
                            children: <Widget>[
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 20,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  color: Colors.deepPurpleAccent,
                                  child: Text(
                                    'Paid',
                                    style: TextStyle(
                                        fontSize: (15), color: Colors.white),
                                  ),
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                              ),
                            ],
                          ),
                        // Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                if (!(order.body.orderStatus == 'Delivered' ||
                                    order.body.orderStatus == 'Returned'))
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: FlatButton(
                                      color: Colors.red,
                                      child: Text(
                                        'Return Order',
                                        style: TextStyle(
                                            fontSize: (12),
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          buttonStatus = 'Returned';
                                        });
                                        _update(buttonStatus);
                                      },
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.red, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                  ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                if (!(order.body.orderStatus == 'Delivered' ||
                                    order.body.orderStatus == 'Returned'))
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: FlatButton(
                                      color:
                                          order.body.orderStatus == 'On the way'
                                              ? Colors.purple
                                              : Colors.blue,
                                      child: order.body.orderStatus ==
                                              'On the way'
                                          ? Text(
                                              'Deliver Order',
                                              style: TextStyle(
                                                  fontSize: (12),
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              'Pickup Order',
                                              style: TextStyle(
                                                  fontSize: (15),
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                      onPressed: () {
                                        // if (order.body.orderStatus !=
                                        //     'Being Prepared') {
                                        if (order.body.orderStatus == 'Ready' ||
                                            order.body.orderStatus ==
                                                'Being Prepared') {
                                          setState(() {
                                            buttonStatus = 'On the way';
                                          });
                                        } else if (order.body.orderStatus ==
                                            'On the way') {
                                          setState(() {
                                            buttonStatus = 'Delivered';
                                          });
                                        }
                                        _update(buttonStatus);
                                        // }
                                      },
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: order.body.orderStatus ==
                                                      'On the way'
                                                  ? Colors.purple
                                                  : Colors.blue,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                      // ),
                      //   ),
                      // ],
                    ),
            );
          },
        );
      },
      // ),
    );
  }
}
