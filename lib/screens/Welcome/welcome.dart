import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:sahasa_rider_new/screens/connection_check/connection_check.dart';

class Welcome extends StatelessWidget {
  bool isDeviceConnected = false;

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
              return const NoConnection();
            } else {
              return child;
            }
          },
          builder: (BuildContext context) {
            return Container(
              color: Colors.white10,
              child: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Image.asset("assets/favicon.png")),
              ),
            );
          },
        );
      },
    );
  }
}
