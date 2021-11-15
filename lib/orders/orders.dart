import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sahasa_rider_new/api/api.dart';
import 'package:sahasa_rider_new/connection_check/connection_check.dart';
import 'package:sahasa_rider_new/helpers/refresh.dart';
import 'package:sahasa_rider_new/helpers/sendfirebase.dart';
import 'package:sahasa_rider_new/models/accept.dart';
import 'package:sahasa_rider_new/models/orders.dart';
import 'package:sahasa_rider_new/models/user.dart';
import 'package:sahasa_rider_new/oneorder/oneorder.dart';
import 'package:shimmer/shimmer.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart';
import 'package:background_geolocation_plugin/background_geolocation_plugin.dart';
import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../drawer.dart';
import '../toast.dart';
import 'loadconfirm.dart';
import 'loading.dart';
import 'loadnew.dart';

class Orders extends StatefulWidget {
  final int screenNum;

  Orders({Key key, @required this.screenNum}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState(screenNum);
}

class _OrdersState extends State<Orders> {
  final int screenNum;
  final _formKey = GlobalKey<FormState>();

  _OrdersState(this.screenNum);

  int newOrdersCount = 0;
  int confirmOrdersCount = 0;
  AcceptOrder accept = AcceptOrder();
  Users data = Users();
  bool loading = true;
  bool newLoading = false;
  bool rejectLoading = false;
  MyGlobals myGlobals = MyGlobals();
  bool pressAll = true;
  bool pressNew = false;
  bool pressConfirm = false;
  bool newItemsLoading = true;
  bool confirmItemsLoading = true;
  OrdersMdl newOrders = OrdersMdl();
  OrdersMdl confirmOrders = OrdersMdl();
  OrdersMdl newOrdersTmp = OrdersMdl();
  OrdersMdl confirmOrdersTmp = OrdersMdl();
  Timer timer;

  @override
  void initState() {
    super.initState();
    //startLocationTrack();
    getData();
    // messageManipulation();
    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
        resumeCallBack: () async => setState(() {
              // do something
              (context as Element).reassemble();
            })));
  }

  getFrequently() async {
    if (!loading) {
      timer = Timer.periodic(Duration(seconds: 15), (Timer t) {
        getNewItems();
        getConfirmItems();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  getNewItems() async {
    newOrdersTmp = await Api().newOrders(context);
    if (newOrdersTmp.message != null) {
      errorMessage(newOrdersTmp.message);
      setState(() {
        newItemsLoading = false;
      });
    } else {
      if (newOrders.body == null) {
        setState(() {
          newOrders = newOrdersTmp;
          newItemsLoading = false;
        });
      } else {
        Function deepEq = const DeepCollectionEquality().equals;
        if (deepEq(newOrders.body, newOrdersTmp.body) == false) {
          setState(() {
            newOrders = newOrdersTmp;
            newItemsLoading = false;
          });
        }
      }
    }
  }

  getConfirmItems() async {
    confirmOrdersTmp = await Api().confirmOrders(context);
    if (confirmOrdersTmp.message != null) {
      errorMessage(confirmOrdersTmp.message);
      setState(() {
        confirmItemsLoading = false;
      });
    } else {
      if (confirmOrders.body == null) {
        setState(() {
          confirmOrders = confirmOrdersTmp;
          confirmItemsLoading = false;
        });
      } else {
        Function deepEq = const DeepCollectionEquality().equals;
        if (deepEq(confirmOrders.body, confirmOrdersTmp.body) == false) {
          setState(() {
            confirmOrders = confirmOrdersTmp;
            confirmItemsLoading = false;
          });
        }
      }
    }
  }

  startLocationTrack() async {
    await BackgroundGeolocationPlugin.requestPermissions();
  }

  _playSound() async {
    var pool = Soundpool(streamType: StreamType.notification);

    var soundId =
        await rootBundle.load("assets/swiftly.mp3").then((ByteData soundData) {
      return pool.load(soundData);
    });
    pool.setVolume(soundId: soundId, volume: 200);
    int streamId = await pool.play(soundId, repeat: 3);
  }

  // messageManipulation() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print("message recieved : $message");
  //     // print(event.notification!.body);
  //   });
  //   _fcm.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print("onMessage: $message");
  //       (context as Element).reassemble();
  //       // Workmanager.registerOneOffTask("1", 'start');
  //       // Navigator.pushAndRemoveUntil(
  //       //   context,
  //       //   MaterialPageRoute(builder: (context) => OrdersPage(screenNo: 0)),
  //       //   (Route<dynamic> route) => false,
  //       // );
  //       // var newCount = this.allOrders.body.counts.newOrders + 1;
  //       // Navigator.of(context).pop();
  //       await _playSound();
  //       showDialog(
  //         context: myGlobals.scaffoldKey.currentContext,
  //         builder: (context) => AlertDialog(
  //           backgroundColor:
  //               message['notification']['title'] == 'New Order(s) Available!'
  //                   ? Colors.blue
  //                   : Colors.green,
  //           content: Align(
  //             alignment: Alignment.bottomCenter,
  //             child: Container(
  //               width: MediaQuery.of(context).size.width,
  //               height: MediaQuery.of(context).size.height * 0.8,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: <Widget>[
  //                   // if (message['notification']['title'] ==
  //                   //     'New Order(s) Available!')
  //                   //   Container(
  //                   //     padding: EdgeInsets.all(30),
  //                   //     decoration: BoxDecoration(
  //                   //         borderRadius:
  //                   //             BorderRadius.all(Radius.circular(200)),
  //                   //         color: Colors.black12),
  //                   //     child: Text(
  //                   //       newCount.toString(),
  //                   //       style: TextStyle(
  //                   //           decoration: TextDecoration.none,
  //                   //           fontSize: ScreenUtil().setSp(100),
  //                   //           color: Colors.white),
  //                   //     ),
  //                   //   ),

  //                   // Icon(
  //                   //   Icons.new_releases,
  //                   //   size: 40,
  //                   //   color: Colors.white,
  //                   // ),
  //                   const SizedBox(
  //                     height: 20,
  //                   ),
  //                   Text(
  //                     message['notification']['title'],
  //                     style: TextStyle(
  //                         decoration: TextDecoration.none,
  //                         fontSize: ScreenUtil().setSp(70),
  //                         color: Colors.white),
  //                   ),
  //                 ],
  //               ),
  //               margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
  //               decoration: BoxDecoration(
  //                 color: message['notification']['title'] ==
  //                         'New Order(s) Available!'
  //                     ? Colors.blue
  //                     : Colors.green,
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //             ),
  //           ),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: const Text(
  //                 'Ok',
  //                 style: TextStyle(color: Colors.white, fontSize: 20),
  //               ),
  //               onPressed: () {
  //                 // _stopSound();
  //                 Navigator.of(context, rootNavigator: true).pop();
  //                 Navigator.of(context, rootNavigator: true).pop();
  //                 Navigator.of(context, rootNavigator: true).pop();
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (context) => Orders(
  //                               screenNum: 0,
  //                             )));
  //                 // (context as Element).reassemble();
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //       // }
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print("onLaunch: $message");
  //       (context as Element).reassemble();
  //       // TODO optional
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print("onResume: $message");
  //       (context as Element).reassemble();
  //       // TODO optional
  //     },
  //   );
  // }

  changeAvailable(value) async {
    var available = await Api().availableChange(context, value);
    if (available.message != null) {
      errorMessage(available.message);
    } else {
      getData();
      successMessage('Succesfully Updated');
    }
  }

  getData() async {
    data = await Api().isLogedin();
    if (data.message != null) {
      errorMessage(data.message);
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      await getNewItems();
      await getConfirmItems();
      getFrequently();
    }
  }

  _acceptOrder(id) async {
    if (!newLoading) {
      setState(() {
        newLoading = true;
      });
      accept = await Api().acceptOrders(context, id);
      if (accept.message != null) {
        errorMessage(accept.message);
        setState(() {
          newLoading = false;
        });
        getConfirmItems();
        getNewItems();
      } else {
        successMessage('Successfully Updated.');
        if (accept.body != null) {
          await SendUser().saveOrderTokens(accept.body);
        }
        setState(() {
          newLoading = false;
        });
        getConfirmItems();
        getNewItems();
      }
    }
  }

  _rejectOrder(id) async {
    if (!rejectLoading) {
      setState(() {
        rejectLoading = true;
      });

      accept = await Api().rejectOrders(context, id);
      if (accept.message != null) {
        setState(() {
          rejectLoading = false;
        });
        errorMessage(accept.message);
      } else {
        successMessage('Successfully Updated.');
        setState(() {
          rejectLoading = false;
        });
        getConfirmItems();
        getNewItems();
      }
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
            "Orders",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(20),
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: <Widget>[
              Text(
                'Available',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(18),
                ),
              ),
              Switch(
                value: data.body.user.isAvailable,
                onChanged: (value) {
                  setState(() {
                    data.body.user.isAvailable = value;
                  });
                  changeAvailable(value);
                },
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

  // ignore: unused_element
  Widget _formWidget() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            onSaved: (String value) {
              // this._data.username = value;
            },
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.blue, width: 2)),
              fillColor: Colors.black,
              hintText: 'Search',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  changeCategory(name) {
    if (name == 'All') {
      setState(() {
        pressAll = true;
        pressConfirm = false;
        pressNew = false;
      });
      (context as Element).reassemble();
      // _getMoreData(this._searchData.offset, false);
    } else if (name == 'New') {
      setState(() {
        pressAll = false;
        pressConfirm = false;
        pressNew = true;
      });
      (context as Element).reassemble();
      // _getMoreData(this._searchData.offset, false);
    } else if (name == 'Confirmed') {
      setState(() {
        pressAll = false;
        pressConfirm = true;
        pressNew = false;
      });
      (context as Element).reassemble();
    }
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
                changeCategory('All');
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
                changeCategory('New');
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
                changeCategory('Confirmed');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget newItems(items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Text(
            'New Orders(${newOrders.body.length})',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        for (var i = 0; i < items.length; i++)
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Card(
              elevation: 4,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Order No: ${items[i].orderNo}',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(15),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Address :  ${items[i].address}',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(15),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: FlatButton(
                              color: Colors.red,
                              child: Text(
                                'Reject',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                _confirm(items[i].id, 'reject');
                              },
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: FlatButton(
                              color: Colors.green,
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                _confirm(items[i].id, 'accept');
                              },
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.green, width: 2),
                                  borderRadius: BorderRadius.circular(5)),
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
    );
  }

  Widget _newItems() {
    return Container(
      child: newItemsLoading || confirmItemsLoading
          ? loadingItems()
          : newItems(newOrders.body),
    );
  }

  Widget _confirmItems() {
    return Container(
      child: confirmItemsLoading || newItemsLoading
          ? Container()
          : confirmItems(confirmOrders.body),
    );
  }

  Widget loadingItems() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.greenAccent,
      ),
    );
  }

  _confirm(id, type) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Container(
          padding: const EdgeInsets.all(15),
          // color: Colors.green,
          alignment: Alignment.center,
          child: type == 'reject'
              ? Text(
                  'Please Confirm.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(20)),
                )
              : Text(
                  'Please Confirm.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(20)),
                ),
        ),
        backgroundColor: Colors.white,
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: const Text(''),
          margin: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  color: Colors.red,
                  child: Text(
                    'No',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(15),
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                ),
                FlatButton(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  color: Colors.green,
                  child: Text(
                    'Yes',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(15),
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (type == 'reject') {
                      _rejectOrder(id);
                    } else {
                      _acceptOrder(id);
                    }
                  },
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget cardDet(item) {
    Color backColor;
    Color statusColor;
    if (item.orderStatus == 'Ready') {
      backColor = Colors.green[50];
      statusColor = Colors.green;
    } else if (item.orderStatus == "Being Prepared") {
      backColor = Colors.blue[50];
      statusColor = Colors.blue;
    } else if (item.orderStatus == "On the way") {
      backColor = Colors.orange[50];
      statusColor = Colors.orange;
    } else {
      backColor = Colors.red[50];
      statusColor = Colors.red;
    }

    return Card(
      color: Colors.transparent,
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
            color: backColor, borderRadius: BorderRadius.circular(5)),
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
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
                          fontSize: ScreenUtil().setSp(15),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Jiffy(item.deliveryTime).format('MM-dd h:mm a'),
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(15),
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
                Container(
                  // height: 20,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: FlatButton(
                    padding: const EdgeInsets.all(5),
                    color: statusColor,
                    child: Text(
                      item.orderStatus,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(12),
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
                      fontSize: ScreenUtil().setSp(15),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  item.orderNo.toString(),
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(15),
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
                    fontSize: ScreenUtil().setSp(15),
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
                          fontSize: ScreenUtil().setSp(12)),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget confirmItems(items) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              'Confirmed Order(${confirmOrders.body.length})',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(18),
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          for (var i = 0; i < items.length; i++)
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: InkWell(
                child: cardDet(items[i]),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OneOrder(
                              orderNo: items[i].orderNo.toString(),
                              id: items[i].id)));
                },
              ),
            ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height),
    );
    ScreenUtil().setWidth(640);
    ScreenUtil().setHeight(1136);

    return WillPopScope(
        key: myGlobals.scaffoldKey,
        child: Builder(
          builder: (BuildContext context) {
            return OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                if (connectivity == ConnectivityResult.none) {
                  return const NoConnection();
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
                            return const NoConnection();
                          } else {
                            return child;
                          }
                        },
                        builder: (BuildContext context) {
                          return LoadingOverlay(
                            progressIndicator: const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            color: Colors.black,
                            isLoading: newLoading || rejectLoading,
                            child: CustomScrollView(
                              slivers: <Widget>[
                                SliverToBoxAdapter(
                                  child: _searchButtons(),
                                ),
                                SliverToBoxAdapter(
                                  child: pressAll || pressNew
                                      ? _newItems()
                                      : Container(),
                                ),
                                SliverToBoxAdapter(
                                  child: pressAll || pressConfirm
                                      ? _confirmItems()
                                      : Container(),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    // ),
                  ),
                  drawer: SideDrawer(
                    screenNo: screenNum,
                  ),
                );
              },
            );
          },
        ),
        onWillPop: () {
          print('pop');
        });
  }
}

class MyGlobals {
  GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}
