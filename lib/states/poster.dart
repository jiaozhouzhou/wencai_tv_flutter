import 'package:flutter/material.dart';

class Poster with ChangeNotifier {
  List _posterIdArr = [];

  List get posterIdArr => _posterIdArr;

  void setLoopSwitchPosterList(li) {
    _posterIdArr = li;
  }
}