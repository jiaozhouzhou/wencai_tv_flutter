import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_orientation/flutter_orientation.dart';

class Global {
  static DeviceOrientation? orientation; // 屏幕方向

  //初始化全局信息
  static Future init() async {
    orientation = null;
  }

  static void changeOrientation(side){
    orientation = side;
  }

  static void rotatingScreen(content){
    // 竖屏有4个方向，横屏只有3个方向可以转动
    DeviceOrientation direction;
    if(content.orientation==Orientation.portrait){ // 竖屏
      direction = (orientation==DeviceOrientation.portraitUp)
          ? DeviceOrientation.landscapeLeft
          : DeviceOrientation.landscapeRight;
    } else { // 横屏
      direction = (orientation==DeviceOrientation.landscapeLeft)
          ? DeviceOrientation.portraitDown
          : DeviceOrientation.portraitUp;
    }
    SystemChrome.setPreferredOrientations([direction]);
    // FlutterOrientation.setOrientation(direction);
    changeOrientation(direction);
  }
}