import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
//import 'package:flutter_screenutil/screenutil.dart';

class NoConnection extends StatefulWidget {
  const NoConnection({Key key}) : super(key: key);

  @override
  _NoConnectionState createState() => _NoConnectionState();
}

class _NoConnectionState extends State<NoConnection> {
  @override
  Widget build(BuildContext context) {
    //ScreenUtil.init(context, width: 1200, height: 1920, allowFontScaling: true);

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.signal_wifi_off,
                size: 70,
                color: Colors.grey,
              ),
              Text(
                'No Connection',
                style: TextStyle(fontSize: 60, color: Colors.red),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
