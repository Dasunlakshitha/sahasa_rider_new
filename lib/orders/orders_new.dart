import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:sahasa_rider_new/connection_check/connection_check.dart';
import 'package:sahasa_rider_new/helpers/sendfirebase.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sahasa_rider_new/api/api.dart';
import 'package:sahasa_rider_new/helpers/sendfirebase.dart';
import 'package:sahasa_rider_new/models/accept.dart';
import 'package:sahasa_rider_new/models/orders.dart';
import 'package:sahasa_rider_new/models/user.dart';
import 'package:sahasa_rider_new/oneorder/loading.dart';
import 'package:sahasa_rider_new/oneorder/oneorder.dart';
import 'package:sahasa_rider_new/orders/orders.dart';
import 'dart:async';
import '../drawer.dart';
import '../toast.dart';

class NewOrder extends StatefulWidget {
  final int screenNum;
  NewOrder({this.screenNum});

  @override
  _NewOrderState createState() => _NewOrderState(screenNum);
}

class _NewOrderState extends State<NewOrder> {
  final int screenNum;
  final _formKey = GlobalKey<FormState>();

  _NewOrderState(this.screenNum);

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

  @override
  void initState() {
    super.initState();
    getData();

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
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
      timer = Timer.periodic(Duration(seconds: 15), (Timer t) {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    key:
    myGlobals.scaffoldKey;
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
            appBar: AppBar(
              backgroundColor: Colors.black12,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Orders",
                    style: TextStyle(
                      fontSize: (20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Available',
                        style: TextStyle(
                          fontSize: (18),
                        ),
                      ),
                      loading
                          ? Container()
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
                              // inactiveThumbColor: Colors.red,
                            ),
                    ],
                  )
                ],
              ),
            ),
            body: Container(
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
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
                              // shrinkWrap: true,
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
                                              fontSize: (15),
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
                                                fontSize: (15),
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
                                                fontSize: (15),
                                                color: pressConfirm
                                                    ? Colors.white
                                                    : Colors.blue,
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
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: pressAll || pressNew
                              ? Container(
                                  child: newItemsLoading || confirmItemsLoading
                                      ? loadingItems()
                                      : newItems(newOrders.body),
                                )
                              : Container(),
                        ),
                        SliverToBoxAdapter(
                          child: pressAll || pressConfirm
                              ? Container(
                                  child: confirmItemsLoading || newItemsLoading
                                      ? Container()
                                      : confirmItems(confirmOrders.body),
                                )
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
            style: const TextStyle(
                fontSize: (18),
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
                      style: const TextStyle(
                          fontSize: (15), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Address :  ${items[i].address}',
                      style: const TextStyle(
                          fontSize: (15), fontWeight: FontWeight.bold),
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
                              child: const Text(
                                'Reject',
                                style: TextStyle(
                                    fontSize: (15),
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
                              child: const Text(
                                'Confirm',
                                style: TextStyle(
                                    fontSize: (15),
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
              style: const TextStyle(
                  fontSize: (18),
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

  _confirm(id, type) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Container(
          padding: const EdgeInsets.all(15),
          // color: Colors.green,
          alignment: Alignment.center,
          child: type == 'reject'
              ? const Text(
                  'Please Confirm.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: (20)),
                )
              : const Text(
                  'Please Confirm.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: (20)),
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
                    const Text(
                      'Pickup Time: ',
                      style: TextStyle(
                          fontSize: (15), fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Jiffy(item.deliveryTime).format('MM-dd h:mm a'),
                      style: const TextStyle(
                          fontSize: (15),
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
                      style:
                          const TextStyle(fontSize: (12), color: Colors.white),
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
                const Text(
                  'Order No: ',
                  style: TextStyle(fontSize: (15), fontWeight: FontWeight.bold),
                ),
                Text(
                  item.orderNo.toString(),
                  style: const TextStyle(
                      fontSize: (15),
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
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: (15),
                    fontWeight: FontWeight.bold),
              ),
            ),
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
                          fontSize: (12)),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
