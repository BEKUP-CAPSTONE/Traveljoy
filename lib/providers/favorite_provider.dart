import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> favorites = [];

  /// Ambil semua wisata favorit berdasarkan user yang sedang login
  Future<void> fetchFavorites() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('bookmark')
        .select(
          'id, wisata_id, wisata(nama_wisata, gambar_url, deskripsi_wisata, harga_tiket, alamat)',
        )
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    favorites = List<Map<String, dynamic>>.from(response);
    notifyListeners();
  }

  /// Tambah ke favorit
  Future<void> addFavorite(BuildContext context, int wisataId) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print('❌ User belum login');
      return;
    }

    try {
      await supabase.from('bookmark').insert({
        'user_id': user.id,
        'wisata_id': wisataId,
      });

      print('✅ Insert bookmark success');
      print('user_id: ${user.id}');
      print('wisata_id: $wisataId');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Telah ditambahkan ke favorite')),
      );
      await fetchFavorites();
    } catch (e) {
      print('❌ Error insert bookmark: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sudah ada di favorite')));
    }
  }

  /// Hapus dari favorit
  Future<void> removeFavorite(BuildContext context, int wisataId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    await supabase
        .from('bookmark')
        .delete()
        .eq('user_id', user.id)
        .eq('wisata_id', wisataId);

    favorites.removeWhere((item) => item['wisata_id'] == wisataId);
    notifyListeners();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Dihapus dari favorite')));
  }

  bool isFavorite(int wisataId) {
    return favorites.any((item) => item['wisata_id'] == wisataId);
  }
}
