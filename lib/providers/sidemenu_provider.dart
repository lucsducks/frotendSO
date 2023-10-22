import 'package:flutter/material.dart';

class SideMenuProvider extends ChangeNotifier {
  String _currentPage = '';

  String get currentPage => _currentPage;

  void setCurrentPageUrl(String routeName) {
    _currentPage = routeName;
    Future.delayed(Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
