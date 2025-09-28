import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  int _itineraryCount = 0;
  int _favoriteCount = 0;

  int get itineraryCount => _itineraryCount;
  int get favoriteCount => _favoriteCount;

  void incrementItinerary() {
    _itineraryCount++;
    notifyListeners();
  }

  void setFavoriteCount(int count) {
    _favoriteCount = count;
    notifyListeners();
  }
}
