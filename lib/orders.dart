import 'package:flutter/material.dart';
import 'package:sahasa_rider_new/drawer.dart';
import 'package:sahasa_rider_new/models/user.dart';

class Orders extends StatefulWidget {
  const Orders({Key key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  bool pressAll = true;
  bool pressConfirm = true;
  bool pressNew = true;
  Users data = Users();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: loading
          ? const CircularProgressIndicator()
          : Scaffold(
              backgroundColor: const Color(0xff2c3539),
              appBar: _appbar(),
              body: Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: _searchButtons(),
                      )
                    ],
                  );
                },
              ),
              drawer: const SideDrawer(
                screenNo: 2,
              ),
            ),
    );
  }

  _appbar() {
    return AppBar(
      backgroundColor: Colors.black12,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            "Orders",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: <Widget>[
              const Text(
                'Available',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Switch(
                //value: data.body.user.isAvailable,
                onChanged: (value) {
                  setState(() {
                    data.body.user.isAvailable = value;
                  });
                  // changeAvailable(value);
                },
                activeColor: Colors.green,
                activeTrackColor: Colors.green[100],
                inactiveTrackColor: Colors.red,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _searchButtons() {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
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
                  color: pressAll ? const Color(0xff3bb143) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Center(
                  child: Text(
                    'All',
                    style: TextStyle(
                        fontSize: (15),
                        color: pressAll ? Colors.white : Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              onTap: () {
                // changeCategory('All');
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
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const Center(
                    child: Text(
                      'New',
                      style: TextStyle(
                          fontSize: (15),
                          // color: pressNew ? Colors.white : Colors.orange,
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
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Center(
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                        fontSize: 15,
                        color: pressNew ? Colors.white : Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
