import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _histories = [];
  List<Map<String, dynamic>> get histories => _histories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Ambil data history milik user saat ini
  Future<void> fetchHistory() async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response = await _supabase
          .from('history')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      _histories = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetch history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Simpan hasil itinerary
  Future<bool> saveHistory({
    required String judul,
    required Map<String, dynamic> preferensi,
    required String narasi,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase.from('history').insert({
        'user_id': user.id,
        'judul': judul,
        'preferensi': preferensi,
        'narasi': narasi,
      });

      await fetchHistory();
      return true;
    } catch (e) {
      debugPrint('Error save history: $e');
      return false;
    }
  }
}
