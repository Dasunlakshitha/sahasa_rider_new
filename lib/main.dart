import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sahasa_rider_new/firebase_notification.dart';
import 'package:sahasa_rider_new/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sahasa_rider_new/models/Push_notification_model.dart';
import 'package:sahasa_rider_new/models/completedorders.dart';

void main() {
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

  PushNotifications _notificationInfo;

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
              background: Colors.orangeAccent,
              duration: const Duration(seconds: 3));
        }
      });
    } else {
      print("permission declined by the user");
    }
  }

  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotifications notifications = PushNotifications(
          message.notification.body,
          message.data["body"],
          message.data["title"],
          message.notification.title);

      setState(() {
        _notificationInfo = notifications;
      });
    });

    registerNotification();

    super.initState();
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

      setState(() {
        _notificationInfo = notifications;
      });
      checkIntitialMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const OverlaySupport(
      child: MaterialApp(
        home: LogIn(),
      ),
    );
  }
}
