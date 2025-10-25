import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileProvider extends ChangeNotifier {
  final SupabaseClient supabase;

  ProfileProvider(this.supabase);

  String? _profileName;
  int _favoriteCount = 0;
  int _itineraryCount = 0;

  String? get profileName => _profileName;
  int get favoriteCount => _favoriteCount;
  int get itineraryCount => _itineraryCount;

  void setFavoriteCount(int count) {
    _favoriteCount = count;
    notifyListeners();
  }

  Future<void> fetchProfileName() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await supabase
          .from('profiles')
          .select('name')
          .eq('id', userId)
          .maybeSingle();

      _profileName = response?['name'] ?? '';
      debugPrint('👤 [ProfileProvider] Nama profil: $_profileName');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ [ProfileProvider] Gagal ambil profil: $e');
    }
  }

  Future<void> fetchItineraryCount() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await supabase
          .from('history')
          .select('id')
          .eq('user_id', userId);

      _itineraryCount = (response as List).length;
      debugPrint('📊 [ProfileProvider] Total itinerary: $_itineraryCount');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ [ProfileProvider] Gagal ambil count itinerary: $e');
    }
  }

  Future<void> loadCurrentProfileName(TextEditingController controller) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await supabase
          .from('profiles')
          .select('name')
          .eq('id', userId)
          .maybeSingle();

      controller.text = response?['name'] ?? '';
      debugPrint('🟢 [ProfileProvider] Berhasil load nama profil');
    } catch (e) {
      debugPrint('❌ [ProfileProvider] Gagal load nama profil: $e');
    }
  }

  Future<bool> updateProfileName(String newName) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return false;

      await supabase.from('profiles').upsert({
        'id': userId,
        'name': newName.trim(),
      });

      // Update nama di provider biar langsung muncul di UI
      _profileName = newName.trim();
      notifyListeners();

      debugPrint('✅ [ProfileProvider] Nama profil diperbarui: $_profileName');
      return true;
    } catch (e) {
      debugPrint('❌ [ProfileProvider] Gagal update profil: $e');
      return false;
    }
  }

  Future<void> loadProfileData() async {
    await Future.wait([fetchProfileName(), fetchItineraryCount()]);
  }
}
