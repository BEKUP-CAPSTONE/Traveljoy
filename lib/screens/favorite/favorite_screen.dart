import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveljoy/providers/favorite_provider.dart';
import '../../core/constants/app_colors.dart';

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

  Widget _buildImage(String url, double height, double width) {
    return url.startsWith('http')
        ? Image.network(
            url,
            height: height,
            width: width,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/images/wisataDefault.png',
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
          )
        : Image.asset(url, height: height, width: width, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoriteProvider>();

    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text(
                'Wisata Favorit',
                style: TextStyle(
                  color: kBlack,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: favProvider.favorites.isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada wisata favorit',
                        style: TextStyle(color: kHintColor),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: favProvider.favorites.length,
                      itemBuilder: (context, index) {
                        final fav = favProvider.favorites[index];
                        final wisata = fav['wisata'];

                        final gambarList =
                            (wisata['gambar_url'] as List?) ?? [];
                        final gambarUrl = gambarList.isNotEmpty
                            ? gambarList.first
                            : 'assets/images/wisataDefault.png';

                        final int wisataId = fav['wisata_id'] ?? 0;
                        final String lokasi = wisata['lokasi'] ?? '';
                        final String namaDaerah = wisata['nama_daerah'] ?? '';
                        final String alamatLengkap = wisata['alamat'] ?? '';

                        String displayAddress;
                        if (alamatLengkap.isNotEmpty) {
                          displayAddress = alamatLengkap;
                        } else if (lokasi.isNotEmpty || namaDaerah.isNotEmpty) {
                          displayAddress =
                              "${lokasi.isNotEmpty ? lokasi : ''}${lokasi.isNotEmpty && namaDaerah.isNotEmpty ? ', ' : ''}${namaDaerah.isNotEmpty ? namaDaerah : ''}";
                        } else {
                          displayAddress = '';
                        }

                        final bool hasLocation = displayAddress.isNotEmpty;

                        return GestureDetector(
                          // Navigasi ke detail wisata
                          onTap: () {
                            if (wisataId > 0) {
                              context.push('/detail-wisata/$wisataId');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'ID wisata tidak valid untuk navigasi.',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: kWhite,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: kNeutralGrey.withOpacity(0.5),
                                width: 0.8,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: kNeutralGrey.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: _buildImage(
                                    gambarUrl,
                                    160,
                                    double.infinity,
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              wisata['nama_wisata'] ??
                                                  'Nama Wisata',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: kPrimaryDark,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),

                                            if (hasLocation)
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    color: kTeal,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      displayAddress,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: kNeutralGrey,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),

                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: kAccentRed,
                                          size: 28,
                                        ),
                                        onPressed: () =>
                                            favProvider.removeFavorite(
                                              context,
                                              fav['wisata_id'],
                                            ),
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
            ),
          ],
        ),
      ),
    );
  }
}
