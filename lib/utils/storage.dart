import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future setData(String key, dynamic value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(value));
  }

  static Future getData(String key) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String? tempData = prefs.getString(key);
      if (tempData != null) {
        return json.decode(tempData);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }


  static Future getMapDataByKey(List keyArr) async {
    Map<String, dynamic> data = {};
    try {
      var prefs = await SharedPreferences.getInstance();
      for(var key in keyArr){
        String? tempData = prefs.getString(key);
        data[key] = tempData != null ? json.decode(tempData) : null;
      }
      return data;
    } catch (e) {
      return data;
    }
  }

  static removeData(String key) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static clear(String key) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}