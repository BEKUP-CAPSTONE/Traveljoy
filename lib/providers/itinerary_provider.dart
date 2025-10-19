import 'package:flutter/material.dart';
import '../core/services/gemini_service.dart';

class ItineraryProvider extends ChangeNotifier {
  Map<String, dynamic>? _generatedData;
  bool _isLoading = false;

  Map<String, dynamic>? get generatedData => _generatedData;
  bool get isLoading => _isLoading;

  Future<bool> generateItinerary({
    required String daerah,
    required int lamaHari,
    required String kategori,
    required String tanggal,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await GeminiService.generateItinerary(
      daerah: daerah,
      lamaHari: lamaHari,
      kategori: kategori,
      tanggal: tanggal,
    );

    _isLoading = false;

    if (result != null) {
      _generatedData = result;
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  void clear() {
    _generatedData = null;
    notifyListeners();
  }
}
