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

  Future<List<Map<String, dynamic>>> fetchWisataByKategori(
    int idKategori,
  ) async {
    try {
      debugPrint(
        '🔍 [WisataProvider] Ambil wisata untuk kategori ID: $idKategori',
      );
      _isLoading = true;
      notifyListeners();

      final response = await supabase
          .from('wisata')
          .select('id, nama_wisata, deskripsi_wisata, gambar_url, alamat')
          .eq('id_kategori', idKategori)
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response,
      );

      debugPrint(
        '✅ [WisataProvider] Berhasil ambil ${data.length} data wisata.',
      );
      return data;
    } catch (e) {
      debugPrint('❌ [WisataProvider] Gagal ambil wisata by kategori: $e');
      return [];
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
          .select(
            'id, nama_wisata, deskripsi_wisata, gambar_url, daerah(nama_daerah)',
          )
          .limit(6);

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

  Future<List<Map<String, dynamic>>> searchSuggestions(String keyword) async {
    if (keyword.isEmpty) return [];
    try {
      final response = await supabase
          .from('wisata')
          .select('id, nama_wisata')
          .ilike('nama_wisata', '%$keyword%')
          .limit(5);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('❌ [WisataProvider] Gagal ambil suggestions: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchDaerah() async {
    try {
      final response = await supabase
          .from('daerah')
          .select('*')
          .order('nama_daerah');
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
