import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/announcement_model.dart';

class AnnouncementProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<AnnouncementModel> _announcements = [];
  List<AnnouncementModel> get announcements => _announcements;

  Set<String> _readAnnouncements = {};

  Future<void> fetchAnnouncements() async {
    try {
      final response = await supabase
          .from('announcements')
          .select()
          .order('created_at', ascending: false);

      _announcements = (response as List)
          .map((e) => AnnouncementModel.fromJson(e))
          .toList();

      await _loadReadStatus();
      notifyListeners();
      debugPrint(
        '🟢 [AnnouncementProvider] Berhasil ambil ${_announcements.length} data announcement',
      );
    } catch (e) {
      debugPrint('❌ [AnnouncementProvider] Gagal fetch announcements: $e');
    }
  }

  Future<void> _loadReadStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _readAnnouncements =
          prefs.getStringList('read_announcements')?.toSet() ?? {};
      debugPrint(
        '🟢 [AnnouncementProvider] Status read loaded: ${_readAnnouncements.length} item',
      );
    } catch (e) {
      debugPrint('❌ [AnnouncementProvider] Gagal load read status: $e');
    }
  }

  bool isRead(String id) {
    try {
      return _readAnnouncements.contains(id);
    } catch (e) {
      debugPrint('🟢 [AnnouncementProvider] Gagal cek status read: $e');
      return false;
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      if (!_readAnnouncements.contains(id)) {
        _readAnnouncements.add(id);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(
          'read_announcements',
          _readAnnouncements.toList(),
        );
        notifyListeners();
        debugPrint('✅ [AnnouncementProvider] Marked "$id" as read');
      }
    } catch (e) {
      debugPrint('❌ [AnnouncementProvider] Gagal mark as read: $e');
    }
  }
}
