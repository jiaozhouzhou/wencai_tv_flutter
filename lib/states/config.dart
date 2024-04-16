import 'package:flutter/material.dart';

class Config with ChangeNotifier {
  // final FocusScopeNode _leftBtnScope = FocusScopeNode(); // 左侧导航焦点区域
  // final FocusScopeNode _topBtnScope = FocusScopeNode(); // 顶部按钮焦点区域
  bool _showToast = false;
  String _toastCon = '';

  bool get showToast => _showToast;
  String get toastCon => _toastCon;

   void setToast(bool flag, String con) {
    _showToast = flag;
    _toastCon = con;
    notifyListeners();
  }
}