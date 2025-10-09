import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveljoy/providers/favorite_provider.dart';
import 'package:traveljoy/screens/home/detail_wisata_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteProvider>().fetchFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Wisata'),
      ),
      body: favProvider.favorites.isEmpty
          ? const Center(child: Text('Belum ada wisata favorit'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: favProvider.favorites.length,
        itemBuilder: (context, index) {
          final fav = favProvider.favorites[index];
          final wisata = fav['wisata'];
          final gambarList = (wisata['gambar_url'] as List?) ?? [];
          final gambarUrl = gambarList.isNotEmpty
              ? gambarList.first
              : 'assets/images/wisataDefault.png';

          return GestureDetector(
              onTap: () {
                context.push('/detail-wisata/${wisata['id']}');
              },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: gambarUrl.startsWith('http')
                        ? Image.network(
                      gambarUrl,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/wisataDefault.png',
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Image.asset(
                      gambarUrl,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            wisata['nama_wisata'] ?? '-',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => favProvider.removeFavorite(context, fav['wisata_id']),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
