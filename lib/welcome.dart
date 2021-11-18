import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

import 'connection_check/connection_check.dart';

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
                child: Image(
                  image: const AssetImage('favicon.png'),
                  width: MediaQuery.of(context).size.width * 0.2,
                ),
              ),
            );
          },
        );
      },
      // ),
    );
    // checkConnection(context);
  }
}
