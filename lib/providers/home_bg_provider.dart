import 'package:flutter/material.dart';

class HomeBgProvider extends ChangeNotifier {
  String _newBgImg = "";
  String get newBgImg => _newBgImg;

  void setNewBgImg(String newBgImgUrl) {
    _newBgImg = newBgImgUrl;
    notifyListeners();
  }
}
