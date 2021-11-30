import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sahasa_rider_new/api/api.dart';
import 'package:sahasa_rider_new/screens/login/login.dart';

import 'package:sahasa_rider_new/screens/Welcome/welcome.dart';
import 'package:sahasa_rider_new/screens/orders/orders_new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(const Homepage());
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return const OverlaySupport(
//       child: MaterialApp(
//         home: Homepage(),
//       ),
//     );
//   }
// }

class Homepage extends StatefulWidget {
  const Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  FirebaseMessaging _messaging;
  String iniPage = 'welcome';
  bool isDeviceConnected = false;

  getData() async {
    Users login = await Api().isLogedin();
    if (!login.done) {
      var sp = await SharedPreferences.getInstance();
      await sp.remove('user');
      setState(() {
        iniPage = 'login';
      });
    } else {
      setState(() {
        iniPage = 'order';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    registerNotification();

    getData();
    // initBackground();
  }

  Widget startPage(state) {
    if (state == 'login') {
      return LogIn();
    } else if (state == 'order') {
      return OrdersNew(screenNum: 0);
    } else {
      return Welcome();
    }
  }

  void registerNotification() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: ScreenUtilInit(
        builder: () => MaterialApp(
          home: startPage(iniPage),
        ),
      ),
    );
  }
}
