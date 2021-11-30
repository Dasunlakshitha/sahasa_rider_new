// ignore_for_file: unused_local_variable, unused_label

import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sahasa_rider_new/screens/connection_check/connection_check.dart';
import 'package:sahasa_rider_new/helpers/sendfirebase.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sahasa_rider_new/api/api.dart';
import 'package:sahasa_rider_new/models/Push_notification_model.dart';
import 'package:sahasa_rider_new/models/accept.dart';
import 'package:sahasa_rider_new/models/orders.dart';
import 'package:sahasa_rider_new/models/user.dart';
import 'package:sahasa_rider_new/oneorder/oneorder.dart';
import 'package:sahasa_rider_new/toast.dart';
import 'package:soundpool/soundpool.dart';
import 'package:sahasa_rider_new/drawer.dart';

class OrdersNew extends StatefulWidget {
  final int screenNum;
  OrdersNew({this.screenNum});

  @override
  _OrdersNewState createState() => _OrdersNewState(screenNum);
}

class _OrdersNewState extends State<OrdersNew> {
  final int screenNum;
  final _formKey = GlobalKey<FormState>();

  _OrdersNewState(this.screenNum);

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
  int newOrderCount;

  double destinationLatitude;
  double destinationLongtude;

  PushNotifications _notificationInfo;
  FirebaseMessaging _messaging;

  String _currentAddress;
  var latitude;
  var longtude;
  StreamSubscription<Position> streamSubscription;

  @override
  void initState() {
    super.initState();
    getData();
    getPosition();
    registerNotification();

    checkIntitialMessage();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotifications notifications = PushNotifications(
          message.notification.body,
          message.data["body"],
          message.data["title"],
          message.notification.title);
      showSimpleNotification(Text(_notificationInfo.title),
          subtitle: Text(_notificationInfo.body),
          background: Colors.green,
          duration: const Duration(seconds: 3));

      setState(() {
        _notificationInfo = notifications;
      });
    });
  }

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("granted permission");

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotifications notifications = PushNotifications(
            message.notification.body,
            message.data["body"],
            message.data["title"],
            message.notification.title);

        setState(() {
          _notificationInfo = notifications;
        });
        if (notifications != null) {
          showSimpleNotification(Text(_notificationInfo.title),
              subtitle: Text(_notificationInfo.body),
              background: Colors.green,
              duration: const Duration(seconds: 3));
          _playSound();
          _showAlertDialog();
        }
      });
    } else {
      print("permission declined by the user");
    }
  }

  Future<void> _showAlertDialog() async {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrdersNew(
                      screenNum: 0,
                    )));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("New Order(s) Available!"),
      actions: [
        okButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });

    // return showDialog(
    //   context: context,
    //   builder: (Context) => AlertDialog(
    //     backgroundColor: Colors.transparent,
    //     content: Align(
    //       alignment: Alignment.center,
    //       child: Container(
    //         width: MediaQuery.of(context).size.width,
    //         height: MediaQuery.of(context).size.height * 0.3,
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: const <Widget>[
    //             SizedBox(
    //               height: 20,
    //             ),
    //             Center(
    //               child: Text(
    //                 "",
    //                 //message.notification.title,
    //                 style: TextStyle(
    //                     decoration: TextDecoration.none,
    //                     fontSize: (20),
    //                     color: Colors.white),
    //               ),
    //             ),
    //           ],
    //         ),
    //         decoration: BoxDecoration(
    //           color: Colors.white54,
    //           // message.notification.title == 'New Order(s) Available!'
    //           //     ? Colors.blue
    //           //     : Colors.green,
    //           borderRadius: BorderRadius.circular(20),
    //         ),
    //       ),
    //     ),
    //     actions: <Widget>[
    //       FlatButton(
    //         child: const Text(
    //           'Ok',
    //           style: TextStyle(color: Colors.white, fontSize: 20),
    //         ),
    //         onPressed: () {
    //           // _stopSound();
    //           Navigator.of(context, rootNavigator: true).pop();
    //           Navigator.of(context, rootNavigator: true).pop();
    //           Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => OrdersNew(
    //                         screenNum: 0,
    //                       )));
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }

  checkIntitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      PushNotifications notifications = PushNotifications(
          initialMessage.notification.body,
          initialMessage.data["body"],
          initialMessage.data["title"],
          initialMessage.notification.title);
      showSimpleNotification(Text(_notificationInfo.title),
          subtitle: Text(_notificationInfo.body),
          background: Colors.green,
          duration: const Duration(seconds: 3));

      setState(() {
        _notificationInfo = notifications;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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

  getFrequently() async {
    if (!loading) {
      timer = Timer.periodic(const Duration(seconds: 15), (Timer t) {
        getNewItems();
        getConfirmItems();
      });
    }
  }

  getNewItems() async {
    newOrdersTmp = await Api().newOrders(context);
    if (newOrdersTmp.message != null) {
      errorMessage(newOrdersTmp.message);
      setState(() {
        newItemsLoading = false;
        newOrderCount = newOrders.body.length;
      });
    } else {
      if (newOrders.body == null) {
        setState(() {
          newOrders = newOrdersTmp;
          newItemsLoading = false;
          newOrderCount = newOrders.body.length;
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

  _playSound() async {
    var pool = Soundpool(streamType: StreamType.notification);

    var soundId =
        await rootBundle.load("assets/swiftly.mp3").then((ByteData soundData) {
      return pool.load(soundData);
    });
    pool.setVolume(soundId: soundId, volume: 200);
    int streamId = await pool.play(soundId, repeat: 3);
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

  getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        latitude = position.latitude;
        longtude = position.longitude;
      });
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    key:
    myGlobals.scaffoldKey;
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(640, 1136),
        orientation: Orientation.portrait);
    return Builder(builder: (context) {
      return OfflineBuilder(connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        if (connectivity == ConnectivityResult.none) {
          return const NoConnection();
        } else {
          return child;
        }
      }, builder: (BuildContext context) {
        return Scaffold(
            backgroundColor: const Color(0xff2c3539),
            appBar: AppBar(
              backgroundColor: Colors.black12,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Orders",
                    style: TextStyle(
                      fontSize: 30.sp,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        MapUtils.openMap(12.132, 6.13213);
                      },
                      child: const Text("press")),
                  Row(
                    children: <Widget>[
                      Text(
                        'Available',
                        style: TextStyle(
                          fontSize: 27.sp,
                        ),
                      ),
                      loading
                          ? Switch(
                              value: true,
                              onChanged: (value) {
                                setState(() {
                                  changeAvailable(value);
                                });
                              },
                              activeColor: Colors.green,
                              activeTrackColor: Colors.green[100],
                              inactiveTrackColor: Colors.red,
                            )
                          : Switch(
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
                            ),
                    ],
                  )
                ],
              ),
            ),
            body: Container(
              child: loading
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.greenAccent,
                        ),
                      ),
                    ) /*const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )*/
                  : CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20),
                            height: 40.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              addAutomaticKeepAlives: true,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(right: 10.0),
                                  child: InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: pressAll
                                            ? const Color(0xff3bb143)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Center(
                                        child: Text(
                                          'All',
                                          style: TextStyle(
                                              fontSize: 22.sp,
                                              color: pressAll
                                                  ? Colors.white
                                                  : Colors.green,
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
                                          color: pressNew
                                              ? Colors.orange
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Center(
                                          child: Text(
                                            'New',
                                            style: TextStyle(
                                                fontSize: 22.sp,
                                                color: pressNew
                                                    ? Colors.white
                                                    : Colors.orange,
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
                                          color: pressConfirm
                                              ? Colors.blue
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Center(
                                          child: Text(
                                            'Confirmed',
                                            style: TextStyle(
                                                fontSize: 22.sp,
                                                color: pressConfirm
                                                    ? Colors.white
                                                    : Colors.blue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                    onTap: () {
                                      //_showAlertDialog();
                                      changeCategory('Confirmed');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: pressAll || pressNew
                              ? Container(
                                  child: newItemsLoading || confirmItemsLoading
                                      ? _newItems()
                                      : newItems(newOrders.body),
                                )
                              : Container(),
                        ),
                        SliverToBoxAdapter(
                          child: pressAll || pressConfirm
                              ? Container(
                                  child: confirmItemsLoading || newItemsLoading
                                      ? Container()
                                      : _confirmItems())
                              : Container(),
                        ),
                      ],
                    ),
            ),
            drawer: SideDrawer(
              screenNo: screenNum,
            ));
      });
    });
  }

  changeCategory(name) {
    if (name == 'All') {
      setState(() {
        pressAll = true;
        pressConfirm = false;
        pressNew = false;
      });
      (context as Element).reassemble();
    } else if (name == 'New') {
      setState(() {
        pressAll = false;
        pressConfirm = false;
        pressNew = true;
      });
      (context as Element).reassemble();
    } else if (name == 'Confirmed') {
      setState(() {
        pressAll = false;
        pressConfirm = true;
        pressNew = false;
      });
      (context as Element).reassemble();
    }
  }

  changeAvailable(value) async {
    var available = await Api().availableChange(context, value);
    if (available.message != null) {
      errorMessage(available.message);
    } else {
      getData();
      successMessage('Succesfully Updated');
    }
  }

  Widget loadingItems() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.greenAccent,
      ),
    );
  }

  Widget _newItems() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 1.6,
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
                fontSize: 26.sp,
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Order No: ${items[i].orderNo}',
                      style: TextStyle(
                          fontSize: 25.sp, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Address :  ${items[i].address}',
                      style: TextStyle(
                          fontSize: 25.sp, fontWeight: FontWeight.bold),
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
                                    fontSize: 25.sp,
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
                                    fontSize: 25.sp,
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
                  fontSize: 26.sp,
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
                          id: items[i].id),
                    ),
                  );
                },
              ),
            ),
        ]);
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
                      fontSize: 25.sp),
                )
              : Text(
                  'Please Confirm.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.sp),
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
                  child: const Text(
                    'No',
                    style: TextStyle(
                        fontSize: 15,
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
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                        fontSize: 15,
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
                          fontSize: (23.sp), fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Jiffy(item.deliveryTime).format('MM-dd h:mm a'),
                      style: TextStyle(
                          fontSize: (23.sp),
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
                      style: TextStyle(fontSize: (22.sp), color: Colors.white),
                    ),
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      'Order No: ',
                      style: TextStyle(
                          fontSize: (23.sp), fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item.orderNo.toString(),
                      style: TextStyle(
                          fontSize: (23.sp),
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ],
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    MapUtils.openMap(destinationLatitude, destinationLongtude);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "MAP",
                        style: TextStyle(fontSize: 23.sp, color: Colors.white),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const Divider(),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                item.address,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: (15),
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
                          fontSize: (20.sp)),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyGlobals {
  GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}
