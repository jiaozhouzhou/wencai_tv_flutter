import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class Global {
  static Orientation? orientation; // 屏幕方向
  //初始化全局信息
  static Future init() async {
    orientation = null;
  }

  static void changeOrientation(side){
    orientation = side;
  }
}