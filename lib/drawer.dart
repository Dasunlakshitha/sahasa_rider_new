import 'package:flutter/material.dart';
import 'package:sahasa_rider_new/login.dart';
import 'package:sahasa_rider_new/api/api.dart';

import 'orders.dart';

//import 'package:new_sahasa_rider/src/screens/trackPath/trackPath.dart';

class SideDrawer extends StatefulWidget {
  final int screenNo;
  const SideDrawer({Key key, @required this.screenNo}) : super(key: key);

  @override
  _SideDrawerState createState() => _SideDrawerState(screenNo);
}

class _SideDrawerState extends State<SideDrawer> {
  int screenNo;
  _SideDrawerState(this.screenNo);

  bool loading = false;

  logout() async {
    setState(() {
      loading = true;
    });
    bool log = await Api().logout();
    if (log) {
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (context) => login()),
      //   (Route<dynamic> route) => false,
      // );
    }
    setState(() {
      loading = false;
    });
  }

  Widget _title(context) {
    return Image.asset(
      "assets/images/logo.png",
      width: MediaQuery.of(context).size.width * 0.1,
    );
  }

  List screens = ['Orders', 'Completed Orders', 'My Earnings'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65, //20.0,
      child: Drawer(
        child: Container(
          color: const Color(0xff2c3539),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DrawerHeader(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(30),
                child: _title(context),
                decoration: const BoxDecoration(color: Color(0xffe3f2fd)),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  addAutomaticKeepAlives: true,
                  itemCount: screens.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Container(
                      padding: const EdgeInsets.only(left: 12),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            if (index == 0)
                              Icon(
                                Icons.dvr,
                                size: (20),
                                color: screenNo == index
                                    ? Colors.greenAccent[400]
                                    : Colors.white70,
                              ),
                            if (index == 1)
                              Icon(
                                Icons.crop_rotate,
                                size: (20),
                                color: screenNo == index
                                    ? Colors.greenAccent[400]
                                    : Colors.white70,
                              ),
                            if (index == 2)
                              Icon(
                                Icons.monetization_on,
                                size: (20),
                                color: screenNo == index
                                    ? Colors.greenAccent[400]
                                    : Colors.white70,
                              ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              screens[index],
                              style: TextStyle(
                                  color: screenNo == index
                                      ? Colors.greenAccent[400]
                                      : Colors.white70,
                                  fontSize: (15),
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Navigator.of(context).pop();
                          // if (index == 0) {
                          //   Navigator.of(context).push(MaterialPageRoute(
                          //       builder: (BuildContext context) =>
                          //           Orders(screenNum: index)));
                          // } else if (index == 1) {
                          //   Navigator.of(context).push(MaterialPageRoute(
                          //       builder: (BuildContext context) =>
                          //           AllOrders(screenNum: index)));
                          // } else if (index == 2) {
                          //   Navigator.of(context).push(MaterialPageRoute(
                          //       builder: (BuildContext context) =>
                          //           MyEarnings(screenNum: index)));
                          // }
                        },
                      ),
                    );
                  }),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 0),
                  // height: 90,
                  color: Colors.black38,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.input,
                          size: (25),
                          color: Colors.white70,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        loading
                            ? const SizedBox(
                                height: (25),
                                width: (25),
                                child: CircularProgressIndicator())
                            : const Text(
                                "Logout",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: (20),
                                    fontWeight: FontWeight.bold),
                              ),
                      ],
                    ),
                    onTap: () {
                      logout();
                    },
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
