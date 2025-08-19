import 'package:flutter/material.dart';

class CurrentIndexProvider with ChangeNotifier {
  int _currentIndex = 0; // default index
  int _navigationCurrentIndex = 0;
  int get currentIndex => _currentIndex;
  int get navigationCurrentIndex => _navigationCurrentIndex;

  void setNavigationIndex(int index) {
    _navigationCurrentIndex = index;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
