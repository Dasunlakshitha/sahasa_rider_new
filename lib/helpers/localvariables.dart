import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

Future<String>readStringValue(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getString(key) ?? '';
  return value;
}

Future<String>saveStringValue(String key, var value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
  return 'true';
}

Future<String>removeStringValue(String key) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
  return 'true';
}
