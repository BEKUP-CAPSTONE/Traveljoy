import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/gemini_service.dart';

class ItineraryProvider extends ChangeNotifier {
  Map<String, dynamic>? _generatedData;
  final supabase = Supabase.instance.client;

  bool _isLoading = false;

  Map<String, dynamic>? get generatedData => _generatedData;
  bool get isLoading => _isLoading;

  Future<int> getUserItineraryCount() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        debugPrint('⚠️ [ItineraryProvider] Tidak ada user login');
        return 0;
      }

      final response = await supabase
          .from('history')
          .select('id, user_id')
          .eq('user_id', userId);

      if (response is List && response.isNotEmpty) {
        final count = response.length;
        debugPrint('📊 [ItineraryProvider] Total itinerary user: $count');
        return count;
      } else {
        debugPrint(
          'ℹ️ [ItineraryProvider] Tidak ada data itinerary untuk $userId',
        );
        return 0;
      }
    } catch (e) {
      debugPrint('❌ [ItineraryProvider] Gagal ambil count itinerary: $e');
      return 0;
    }
  }

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

  void loadFromHistory(Map<String, dynamic> historyData) {
    _generatedData = historyData;
    notifyListeners();
  }
}
