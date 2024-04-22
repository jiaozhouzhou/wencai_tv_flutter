import 'package:flutter/material.dart';
import '../utils/storage.dart';
// import 'package:flutter/services.dart';

class Global {
  static GlobalKey materialAppKey = GlobalKey();
  static Orientation? orientation; // 屏幕方向
  static Map<String, dynamic> rotate = {}; // 旋转信息
  static Map<String, dynamic> userinfo = {};
  static String token = '';

  //初始化全局信息
  static Future init() async {
    orientation = null;
    final localData = await Storage.getMapDataByKey(['rotate','token','userinfo']);
    debugPrint('localData：$localData');
    rotate = localData['rotate']??{};
    token = localData['token']??'';
    userinfo = localData['userinfo']??{};
    debugPrint('localData：$rotate');
  }

  static void setGlobeInfo(side){
    // 设置全局信息
    orientation = side;
  }

  static void updateUserInfo(data){
    userinfo = data;
  }
  static void updateUserToken(data){
    token = data;
  }
}