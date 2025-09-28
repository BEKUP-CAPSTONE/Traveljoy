import 'package:flutter/material.dart';

class WisataProvider extends ChangeNotifier {
  List<String> _wisataList = ["Pantai", "Gunung", "Museum"];

  List<String> get wisataList => _wisataList;

  void addWisata(String nama) {
    _wisataList.add(nama);
    notifyListeners();
  }
}
