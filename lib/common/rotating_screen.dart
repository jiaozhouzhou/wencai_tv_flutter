import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_orientation/flutter_orientation.dart';

void rotatingScreen(content){
  // print(content.orientation==Orientation.portrait);
  if(content.orientation==Orientation.portrait){
    // FlutterOrientation.setOrientation(DeviceOrientation.landscapeLeft);
    FlutterOrientation.setOrientation(DeviceOrientation.landscapeLeft);
  } else {
    FlutterOrientation.setOrientation(DeviceOrientation.portraitUp);
  }
}

// 强制横屏
// SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
// 强制竖屏
// SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);