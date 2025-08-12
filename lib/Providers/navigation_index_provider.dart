import 'package:flutter/material.dart';

class CurrentIndexProvider with ChangeNotifier {
  int _currentIndex = 0; // default index
  int _navigationCurrentIndex = 0;
  int get currentIndex => _currentIndex;
  int get navigationCurrentIndex => _navigationCurrentIndex;

  void setCurrentIndex(int newIndex) {
    if (_currentIndex != newIndex && newIndex < 3) {
      _currentIndex = newIndex;
      _navigationCurrentIndex = newIndex;
      notifyListeners();
    } else {
      _currentIndex = newIndex;
      notifyListeners();
    }
  }
}
