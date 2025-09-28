import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userEmail = "";

  bool get isLoggedIn => _isLoggedIn;
  String get userEmail => _userEmail;

  Future<void> login(String email, String password) async {
    // sementara login dummy
    _isLoggedIn = true;
    _userEmail = email;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    // sementara register dummy
    _isLoggedIn = true;
    _userEmail = email;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userEmail = "";
    notifyListeners();
  }
}
