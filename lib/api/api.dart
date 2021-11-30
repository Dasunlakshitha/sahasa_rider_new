// ignore_for_file: missing_return

import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:sahasa_rider_new/config.dart';
import 'package:sahasa_rider_new/helpers/sendfirebase.dart';
import 'package:sahasa_rider_new/models/accept.dart';
import 'package:sahasa_rider_new/models/courier.dart';
import 'package:sahasa_rider_new/models/earning.dart';
import 'package:sahasa_rider_new/models/order.dart';
import 'package:sahasa_rider_new/models/orders.dart';
import 'package:sahasa_rider_new/models/user.dart';
import 'package:sahasa_rider_new/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Api {
  // for cookie set
  // final Dio _dio = Dio();
  final Dio _dio = Dio();
  // ignore: prefer_function_declarations_over_variables
  HttpClient Function(HttpClient client) onHttpClientCreate =
      (HttpClient client) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Directory> get _localCoookieDirectory async {
    final path = await _localPath;
    final Directory dir = Directory(path + '/cookies');
    await dir.create();
    return dir;
  }

  Future<String> setCookie() async {
    try {
      final Directory dir = await _localCoookieDirectory;

      final cookiePath = dir.path;

      var persistentCookies = PersistCookieJar(
          ignoreExpires: true, storage: FileStorage(cookiePath));

      _dio.interceptors.add(CookieManager(
              persistentCookies) //this sets up _dio to persist cookies throughout subsequent requests
          );
      _dio.options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 500000,
        receiveTimeout: 500000,
        headers: {
          HttpHeaders.userAgentHeader: "sahasa-user-dio-all-head",
          "Connection": "keep-alive",
        },
      );
      return '';
    } catch (error) {
      errorMessage(defaultErrorMsg);
    }
  }

  // apis
  Future<Users> isLogedin() async {
    try {
      bool trustSelfSigned = true;
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback =
            ((X509Certificate cert, String host, int port) => trustSelfSigned);
      await setCookie();
      Response response = await _dio.get('$baseUrl/secure/authorize');
      return Users.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        Users result = Users();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        Users result = Users();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        Users result = Users();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        Users result = Users();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }

  Future<Users> loginApi(
      String username, String password, String subDomain) async {
    try {
      await setCookie();
      Response response =
          await _dio.post('$baseUrl/secure/deliver/login', data: {
        'username': username,
        'password': password
        // 'subdomain': subDomain
      });
      // return (response.data);
    } catch (e) {
      if (e.response.statusCode == 302) {
        return isLogedin();
      } else {
        if (e.response.statusCode == 400) {
          Users result = Users();
          result.message = 'Bad Request.';
          return result;
        } else if (e.response.statusCode == 401) {
          Users result = Users();
          result.message = 'Unauthorized.';
          return result;
        } else if (e.response.statusCode == 503) {
          Users result = Users();
          result.message = 'Service Unavailable.';
          return result;
        } else {
          Users result = Users();
          result.message = defaultErrorMsg;
          return result;
        }
      }
    }
  }

  Future<OrdersMdl> newOrders(BuildContext context) async {
    try {
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/api/v1/delivery-personnel-new-orders');
      return OrdersMdl.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        OrdersMdl result = OrdersMdl();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        OrdersMdl result = OrdersMdl();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        OrdersMdl result = OrdersMdl();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        OrdersMdl result = OrdersMdl();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }

  Future<OrdersMdl> confirmOrders(BuildContext context) async {
    try {
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/api/v1/delivery-personnel-confirm-orders');
      return OrdersMdl.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        OrdersMdl result = OrdersMdl();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        OrdersMdl result = OrdersMdl();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        OrdersMdl result = OrdersMdl();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        OrdersMdl result = OrdersMdl();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }

  Future<AcceptOrder> acceptOrders(BuildContext context, String orderId) async {
    try {
      await setCookie();
      Response response =
          await _dio.put('$baseUrl/api/v1/delivery-personnel-order/$orderId');
      return AcceptOrder.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Unauthorized.';
        return result;
      } else if (e.response.statusCode == 503) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        AcceptOrder result = AcceptOrder();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }

  Future<AcceptOrder> rejectOrders(BuildContext context, String orderId) async {
    try {
      await setCookie();
      Response response = await _dio.post(
          '$baseUrl/api/v1/delivery-personnel-orders',
          data: {'orderId': orderId});
      return AcceptOrder.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        AcceptOrder result = AcceptOrder();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }

  Future<AcceptOrder> availableChange(
      BuildContext context, bool available) async {
    try {
      await setCookie();
      Response response = await _dio.put(
          '$baseUrl/api/v1/delivery-personnel-available',
          data: {'available': available});
      return AcceptOrder.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        AcceptOrder result = AcceptOrder();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }

  Future<bool> logout() async {
    try {
      await setCookie();
      final Directory dir = await _localCoookieDirectory;
      final cookiePath = dir.path;
      var persistentCookies = PersistCookieJar(
          ignoreExpires: true, storage: FileStorage(cookiePath));
      persistentCookies.deleteAll();

      Response response = await _dio.get('$baseUrl/secure/logout');

      if (response.data['done']) {
        await SendUser().deleteDeviceToken();
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('user');
        return true;
      } else {
        errorMessage(defaultErrorMsg);
        return false;
      }
    } catch (e) {
      if (e.response.statusCode == 400) {
        errorMessage('Bad Request.');
        return false;
      } else if (e.response.statusCode == 401) {
        errorMessage('Unauthorize.');
        return false;
      } else if (e.response.statusCode == 503) {
        errorMessage('Service Unavailable.');
        return false;
      } else {
        errorMessage(defaultErrorMsg);
        return false;
      }
    }
  }

  Future<Courier> getCourier(String id) async {
    try {
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/api/v1/delivery-personnel-courier/$id');
      return Courier.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        Courier result = Courier();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        Courier result = Courier();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        Courier result = Courier();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        Courier result = Courier();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }

  Future<AcceptOrder> updateCourierStatus(
      BuildContext context, String courierId, String status) async {
    try {
      await setCookie();
      Response response = await _dio.put(
          '$baseUrl/api/v1/delivery-personnel-courier/$courierId',
          data: {'status': status});
      return AcceptOrder.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        AcceptOrder result = AcceptOrder();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }

  Future<Order> getOrder(BuildContext context, String id) async {
    try {
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/api/v1/delivery-personnel-orders/$id');
      return Order.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        Order result = Order();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        Order result = Order();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        Order result = Order();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        Order result = Order();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }

  // Future<Order> getPicAndDrops(BuildContext context, String id) async {
  //   try {
  //     await setCookie();
  //     Response response = await _dio.get('$baseUrl/api/v1/couriers/$id');
  //     return Order.fromJson(response.data);
  //   } catch (e) {
  //     if (e.response.statusCode == 400) {
  //       Order result = Order();
  //       result.message = 'Bad Request.';
  //       return result;
  //     } else if (e.response.statusCode == 401) {
  //       Order result = Order();
  //       result.message = 'Unauthorize.';
  //       return result;
  //     } else if (e.response.statusCode == 503) {
  //       Order result = Order();
  //       result.message = 'Service Unavailable.';
  //       return result;
  //     } else {
  //       Order result = Order();
  //       result.message = defaultErrorMsg;
  //       return result;
  //     }
  //   }
  // }

  Future<AcceptOrder> updateOrder(BuildContext context, String status,
      String returnNote, String orderId) async {
    try {
      await setCookie();
      Response response = await _dio.put(
          '$baseUrl/api/v1/delivery-personnel-orders/$orderId',
          data: {'status': status, 'note': returnNote});
      return AcceptOrder.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        AcceptOrder result = AcceptOrder();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }

  Future<OrdersMdl> completedOrders(BuildContext context, var data) async {
    try {
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/delivery-personnel-deliver-orders?start=${data.startDate}&end=${data.endDate}&limit=${data.limit}&offset=${data.offset}');
      return OrdersMdl.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        OrdersMdl result = OrdersMdl();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        OrdersMdl result = OrdersMdl();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        OrdersMdl result = OrdersMdl();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        OrdersMdl result = OrdersMdl();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }

  Future<Earning> getEarnings(BuildContext context, var data) async {
    try {
      await setCookie();
      Response response = await _dio.get(
          '$baseUrl/api/v1/delivery-personnel-earnings?start=${data.startDate}&end=${data.endDate}');
      return Earning.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        Earning result = Earning();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        Earning result = Earning();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        Earning result = Earning();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        Earning result = Earning();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }

  Future<OrdersMdl> readyOrders(BuildContext context) async {
    try {
      await setCookie();
      Response response =
          await _dio.get('$baseUrl/api/v1/delivery-personnel-ready-orders');
      return OrdersMdl.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        OrdersMdl result = OrdersMdl();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        OrdersMdl result = OrdersMdl();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        OrdersMdl result = OrdersMdl();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        OrdersMdl result = OrdersMdl();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }

  Future<AcceptOrder> updateOrderDistance(distance, String orderId) async {
    try {
      await setCookie();
      Response response = await _dio.put(
          '$baseUrl/api/v1/delivery-personnel-distance/$orderId',
          data: {'distance': distance});
      return AcceptOrder.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        AcceptOrder result = AcceptOrder();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        AcceptOrder result = AcceptOrder();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }

  Future<Users> getRiderDetails() async {
    try {
      Response response =
          await _dio.get('$baseUrl/api/v1/delivery-personnel/:id ');
      return Users.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        Users result = Users();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        Users result = Users();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        Users result = Users();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        Users result = Users();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }

  Future getLocation() async {
    try {
      Response response = await _dio.get('');
      return Users.fromJson(response.data);
    } catch (e) {
      if (e.response.statusCode == 400) {
        Users result = Users();
        result.message = 'Bad Request.';
        return result;
      } else if (e.response.statusCode == 401) {
        Users result = Users();
        result.message = 'Unauthorize.';
        return result;
      } else if (e.response.statusCode == 503) {
        Users result = Users();
        result.message = 'Service Unavailable.';
        return result;
      } else {
        Users result = Users();
        result.message = defaultErrorMsg;
        return result;
      }
    }
  }
}

class MapUtils {
  MapUtils._();
  static Future<void> openMap(
      double destinationLatitude, double destinationLongtude) async {
    String googleMapUrl =
        "https://www.google.com/maps/dir/?api=1&origin=&destination=6.995000,80.994275&travelmode=driving&dir_action=navigate";
    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw "cannot launch";
    }
  }
}
