import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favorites = [];

  List<String> get favorites => _favorites;

  void addFavorite(String wisata) {
    if (!_favorites.contains(wisata)) {
      _favorites.add(wisata);
      notifyListeners();
    }
  }

  void removeFavorite(String wisata) {
    _favorites.remove(wisata);
    notifyListeners();
  }
}
