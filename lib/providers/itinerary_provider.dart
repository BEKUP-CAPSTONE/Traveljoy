import 'package:flutter/material.dart';

class ItineraryProvider extends ChangeNotifier {
  List<String> _history = [];

  List<String> get history => _history;

  Future<void> generateItinerary(String input) async {
    String result = "Itinerary untuk $input: Hari 1 ke Pantai, Hari 2 ke Gunung";
    _history.add(result);
    notifyListeners();
  }
}
