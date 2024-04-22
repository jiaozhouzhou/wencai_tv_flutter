import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../common/globe.dart';
import '../utils/storage.dart';

class Config with ChangeNotifier {
  int _angle = Global.rotate['angle']??0;
  String _orientation =  Global.rotate['orientation']??'up';
  bool _isHorizontal =  Global.rotate['isHorizontal']??true;

  bool get isHorizontal => _isHorizontal;
  String get orientation => _orientation;
  int get angle => _angle;

  void setToast(bool flag, String con) {
    notifyListeners();
  }

  void setScreen(flag){
    // _angle = flag ? 0 : 1;
    // _orientation = flag ? 'up' : 'right';
    _isHorizontal = flag;
  }

  void screenRotate(){
    if(_orientation=='up'){
      _angle = 1; // 90度
      _orientation = 'right';
    }else if(_orientation=='right'){
      _angle = 2; // 180度
      _orientation = 'down';
    }else if(_orientation=='down'){
      _angle = 3; // 270度
      _orientation = 'left';
    }else if(_orientation=='left'){
      _angle = 0; // 360度回到原位置
      _orientation = 'up';
    }
    _isHorizontal = !_isHorizontal;
    notifyListeners();
    // 同步数据到本地存储
    final Map<String, dynamic> rotate = {
      'isHorizontal': _isHorizontal,
      'orientation': _orientation,
      'angle': _angle,
    };
    Storage.setData('rotate', rotate);
  }

  // 正确方向对照表
  correctDirection(keyboardKey){
    if(_orientation=='up'){
      return keyboardKey;
    }else if(_orientation=='right'){ // 旋转90度
      switch (keyboardKey) {
        case LogicalKeyboardKey.arrowUp:
          return LogicalKeyboardKey.arrowRight;
        case LogicalKeyboardKey.arrowRight:
          return LogicalKeyboardKey.arrowDown;
        case LogicalKeyboardKey.arrowDown:
          return LogicalKeyboardKey.arrowLeft;
        case LogicalKeyboardKey.arrowLeft:
          return LogicalKeyboardKey.arrowUp;
      }
    }else if(_orientation=='down'){ // 旋转180度
      switch (keyboardKey) {
        case LogicalKeyboardKey.arrowUp:
          return LogicalKeyboardKey.arrowDown;
        case LogicalKeyboardKey.arrowRight:
          return LogicalKeyboardKey.arrowLeft;
        case LogicalKeyboardKey.arrowDown:
          return LogicalKeyboardKey.arrowUp;
        case LogicalKeyboardKey.arrowLeft:
          return LogicalKeyboardKey.arrowRight;
      }
    }else if(_orientation=='left'){ // 旋转270度
      switch (keyboardKey) {
        case LogicalKeyboardKey.arrowUp:
          return LogicalKeyboardKey.arrowLeft;
        case LogicalKeyboardKey.arrowRight: // 右转上
          return LogicalKeyboardKey.arrowUp;
        case LogicalKeyboardKey.arrowDown:
          return LogicalKeyboardKey.arrowRight;
        case LogicalKeyboardKey.arrowLeft: //左转下
          return LogicalKeyboardKey.arrowDown;
      }
    }
  }
  correctDirection2(TraversalDirection direction){
    if(_orientation=='up'){
      return direction;
    }else if(_orientation=='right'){ // 旋转90度
      switch (direction) {
        case TraversalDirection.up:
          return TraversalDirection.right;
        case TraversalDirection.right:
          return TraversalDirection.down;
        case TraversalDirection.down:
          return TraversalDirection.left;
        case TraversalDirection.left:
          return TraversalDirection.up;
      }
    }else if(_orientation=='down'){ // 旋转180度
      switch (direction) {
        case TraversalDirection.up:
          return TraversalDirection.down;
        case TraversalDirection.right:
          return TraversalDirection.left;
        case TraversalDirection.down:
          return TraversalDirection.up;
        case TraversalDirection.left:
          return TraversalDirection.right;
      }
    }else if(_orientation=='left'){ // 旋转270度
      switch (direction) {
        case TraversalDirection.up:
          return TraversalDirection.left;
        case TraversalDirection.right:
          return TraversalDirection.up;
        case TraversalDirection.down:
          return TraversalDirection.right;
        case TraversalDirection.left:
          return TraversalDirection.down;
      }
    }
  }
}