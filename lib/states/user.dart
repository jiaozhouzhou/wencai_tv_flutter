import 'package:flutter/material.dart';
import '../common/globe.dart';
import '../utils/storage.dart';

class User with ChangeNotifier {
  Map<String, dynamic> _userinfo = Global.userinfo;
  String _token = Global.token;

  Map get userinfo => _userinfo;
  bool get isLogin => _token.isNotEmpty;

  void setUserInfo(data) async {
    _userinfo = data;
    notifyListeners();
    Storage.setData('userinfo', data);
    Global.updateUserInfo(data);
  }

  void setToken(str) async {
    _token = str;
    Storage.setData('token', str);
    Global.updateUserToken(str);
  }

  void loadUserInfo() async{
    _userinfo = await Storage.getData('userinfo');
    notifyListeners();
  }
}