import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'localVariables.dart';
import 'localVariables.dart';

class SendUser {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  saveDeviceToken(storeId) async {
    // Get the current user
    // String storeId = 'jeffd23';
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('riderUsers')
          .doc(storeId)
          .collection('tokens')
          .doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
      await saveStringValue('token', fcmToken);
    }
  }

  saveOrderTokens(orderId) async {
    String orders = await readStringValue('orders');
    if (orders != "") {
      List decodedOrders = jsonDecode(orders);
      decodedOrders.add(orderId);
      await saveStringValue('orders', jsonEncode(decodedOrders));
    } else {
      List decodedOrders = [];
      decodedOrders.add(orderId);
      await saveStringValue('orders', jsonEncode(decodedOrders));
    }

    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('riderUsers')
          .doc(orderId)
          .collection('tokens')
          .doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
      await saveStringValue('token', fcmToken);
    }
  }

  deleteDeviceToken() async {
    // Get the current user
    // String uid = 'jeffd23';
    // FirebaseUser user = await _auth.currentUser();
    String user = await readStringValue('user');
    if (user != "") {
      String accountId = jsonDecode(user)['account_id'];
      // Get the token for this device
      String fcmToken = await readStringValue('token');
      // Save it to Firestore
      if (fcmToken != null) {
        await _db
            .collection('riderUsers')
            .doc(accountId)
            .collection('tokens')
            .doc(fcmToken)
            .delete();

        String orders = await readStringValue('orders');
        if (orders != "") {
          List decodedOrders = jsonDecode(orders);

          for (var i = 0; i < decodedOrders.length; i++) {
            await _db
                .collection('riderUsers')
                .doc(decodedOrders[i])
                .collection('tokens')
                .doc(fcmToken)
                .delete();
          }
        }
      }
    }
  }

  deleteDeliveryToken(order_id) async {
    // Get the current user
    // String uid = 'jeffd23';
    // FirebaseUser user = await _auth.currentUser();
    // Get the token for this device
    String fcmToken = await readStringValue('token');
    // Save it to Firestore
    if (fcmToken != '') {
      await _db
          .collection('riderUsers')
          .doc(order_id)
          .collection('tokens')
          .doc(fcmToken)
          .delete();
    }
  }
}
