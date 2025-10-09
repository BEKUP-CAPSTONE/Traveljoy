import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WisataProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _kategori = [];
  List<Map<String, dynamic>> get kategori => _kategori;

  List<Map<String, dynamic>> _wisata = [];
  List<Map<String, dynamic>> get wisata => _wisata;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchKategori() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await supabase.from('kategori').select('*');
      _kategori = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('❌ [WisataProvider] Gagal ambil kategori: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRandomWisata() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await supabase
          .from('wisata')
          .select('id, nama_wisata, deskripsi_wisata, gambar_url')
          .limit(10);

      _wisata = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('❌ [WisataProvider] Gagal ambil wisata: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchWisata(String keyword) async {
    if (keyword.isEmpty) return;
    try {
      _isLoading = true;
      notifyListeners();

      final response = await supabase
          .from('wisata')
          .select('id, nama_wisata, deskripsi_wisata, gambar_url')
          .ilike('nama_wisata', '%$keyword%');

      _wisata = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('❌ [WisataProvider] Gagal cari wisata: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> fetchDaerah() async {
    try {
      final response = await supabase.from('daerah').select('*').order('nama_daerah');
      return response;
    } catch (e) {
      debugPrint('❌ [Daerah] Error fetching daerah: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchWisataByDaerah(int idDaerah) async {
    try {
      final response = await supabase
          .from('wisata')
          .select('*, kategori(nama_kategori)')
          .eq('id_daerah', idDaerah);
      return response;
    } catch (e) {
      debugPrint('❌ [WisataDaerah] Error fetching wisata by daerah: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchWisataById(int id) async {
    try {
      final response = await supabase
          .from('wisata')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return response;
    } catch (e) {
      debugPrint('Error fetchWisataById: $e');
      return null;
    }
  }


}
