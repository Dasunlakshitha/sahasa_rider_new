/**
 * when used logged in to the sysytem the credential are saved in shared preferences to avoid call get user data frm backend again and again.
 */

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void updateUserAuthPref({String key, var data}) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString(key, json.encode(data));
}

void removeUserAuthPref({String key}) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove(key);
}

Future getUserAuthPref({String key}) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.getString(key) == null) {
    return null;
  } else {
    return json.decode(pref.getString(key));
  }
}
