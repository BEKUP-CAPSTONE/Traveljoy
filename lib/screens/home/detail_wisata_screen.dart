// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:traveljoy/providers/favorite_provider.dart';
// import 'package:traveljoy/providers/wisata_provider.dart';
// import 'package:go_router/go_router.dart';
//
// class DetailWisataScreen extends StatefulWidget {
//   final int id;
//   const DetailWisataScreen({super.key, required this.id});
//
//   @override
//   State<DetailWisataScreen> createState() => _DetailWisataScreenState();
// }
//
// class _DetailWisataScreenState extends State<DetailWisataScreen> {
//   Map<String, dynamic>? wisata;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadDetail();
//   }
//
//   Future<void> _loadDetail() async {
//     try {
//       final provider = context.read<WisataProvider>();
//       final data = await provider.fetchWisataById(widget.id);
//
//       if (mounted) {
//         setState(() {
//           wisata = data;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       debugPrint('❌ Gagal load detail wisata: $e');
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   leading: IconButton(
//       //     icon: const Icon(Icons.arrow_back),
//       //     onPressed: () => context.pop(),
//       //   ),
//       //   title: const Text('Detail Wisata'),
//       // ),
//       appBar: AppBar(
//         title: Text(wisata?['nama_wisata'] ?? 'Detail Wisata'),
//         leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () => context.pop(),
//             ),
//         actions: [
//           if (!isLoading && wisata != null)
//             Consumer<FavoriteProvider>(
//               builder: (context, favProvider, _) {
//                 final int id = wisata!['id'];
//                 final bool isFav = favProvider.isFavorite(id);
//                 return IconButton(
//                   icon: Icon(
//                     isFav ? Icons.favorite : Icons.favorite_border,
//                     color: Colors.redAccent,
//                   ),
//                   onPressed: () {
//                     if (isFav) {
//                       favProvider.removeFavorite(context, id);
//                     } else {
//                       favProvider.addFavorite(context, id);
//                     }
//                   },
//                 );
//               },
//             ),
//         ],
//       ),
//
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : wisata == null
//           ? const Center(child: Text('Data wisata tidak ditemukan.'))
//           : SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Gambar utama
//             wisata!['gambar_url'] != null &&
//                 (wisata!['gambar_url'] as List).isNotEmpty
//                 ? Image.network(
//               (wisata!['gambar_url'] as List).first,
//               height: 220,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return Image.asset(
//                   'assets/images/wisataDefault.png',
//                   height: 220,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 );
//               },
//             )
//                 : Image.asset(
//               'assets/images/wisataDefault.png',
//               height: 220,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     wisata!['nama_wisata'] ?? 'Tanpa Nama',
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   if (wisata!['alamat'] != null)
//                     Row(
//                       children: [
//                         const Icon(Icons.location_on, size: 18),
//                         const SizedBox(width: 6),
//                         Expanded(
//                           child: Text(
//                             wisata!['alamat'],
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ),
//                       ],
//                     ),
//                   const SizedBox(height: 10),
//                   if (wisata!['harga_tiket'] != null)
//                     Text(
//                       'Harga Tiket: Rp${wisata!['harga_tiket']}',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   if (wisata!['jam_buka'] != null)
//                     Text(
//                       'Jam Buka: ${wisata!['jam_buka']}',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Deskripsi',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     wisata!['deskripsi_wisata'] ??
//                         'Belum ada deskripsi.',
//                     textAlign: TextAlign.justify,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveljoy/providers/favorite_provider.dart';
import 'package:traveljoy/providers/wisata_provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class DetailWisataScreen extends StatefulWidget {
  final int id;
  const DetailWisataScreen({super.key, required this.id});

  @override
  State<DetailWisataScreen> createState() => _DetailWisataScreenState();
}

class _DetailWisataScreenState extends State<DetailWisataScreen> {
  Map<String, dynamic>? wisata;
  bool isLoading = true;

  int _selectedTab = 0;

  final List<String> _tabs = ['Ringkasan', 'Detail', 'Ulasan'];

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final provider = context.read<WisataProvider>();
      final data = await provider.fetchWisataById(widget.id);

      if (mounted) {
        setState(() {
          wisata = data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Gagal load detail wisata: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (wisata == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Wisata')),
        body: const Center(child: Text('Data wisata tidak ditemukan.')),
      );
    }

    final String gambarUrl = (wisata!['gambar_url'] as List?)?.isNotEmpty == true
        ? (wisata!['gambar_url'] as List).first
        : 'assets/images/wisataDefault.png';

    final wisataData = wisata!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // GAMBAR LATAR BELAKANG (FULL SCREEN)
          Positioned.fill(
            child: Image.network(
              gambarUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/wisataDefault.png',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),

          // GRADIENT di bagian atas untuk AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).padding.top + kToolbarHeight,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kBlack.withOpacity(0.4), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // APP BAR
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: kWhite),
                onPressed: () => context.pop(),
              ),
              actions: [
                _buildFavoriteButton(wisataData['id']),
                const SizedBox(width: 8),
              ],
            ),
          ),

          // DETAIL WISATA
          _buildDetailSheet(context, wisataData),
        ],
      ),

      // BOTTOM ACTION
      bottomNavigationBar: _buildBottomActionButton(context, wisataData['id']),
    );
  }


  Widget _buildFavoriteButton(int wisataId) {
    return Consumer<FavoriteProvider>(
      builder: (context, favProvider, _) {
        final bool isFav = favProvider.isFavorite(wisataId);
        return IconButton(
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: isFav ? kAccentRed : kWhite,
          ),
          onPressed: () {
            if (isFav) {
              favProvider.removeFavorite(context, wisataId);
            } else {
              favProvider.addFavorite(context, wisataId);
            }
          },
        );
      },
    );
  }

  Widget _buildDetailSheet(BuildContext context, Map<String, dynamic> data) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double sheetHeight = screenHeight * 0.55;

    final String harga = 'Rp${data['harga_tiket'] ?? '0'}';

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: sheetHeight,
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: kBlack.withOpacity(0.1),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER NAMA DAN HARGA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data['nama_wisata'] ?? 'Nama Wisata',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  harga,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kTeal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // RATING (Simulasi) dan Estimated Cost
            Row(
              children: [
                Icon(Icons.star, color: kWarningColor, size: 16),
                const SizedBox(width: 4),
                Text('4.9 (2.7K)', style: TextStyle(color: kHintColor, fontSize: 14)),
                const Spacer(),
                Text('*Estimated Cost', style: TextStyle(color: kHintColor, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 24),

            // TAB BAR (Overview, Details, Reviews)
            _buildSelectableTabBar(),
            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                child: _buildTabContent(data),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Tab Bar
  Widget _buildSelectableTabBar() {
    return Row(
      children: List.generate(_tabs.length, (index) {
        final isSelected = index == _selectedTab;

        const EdgeInsets tabPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedTab = index;
              });
            },
            child: Container(
              padding: tabPadding,
              decoration: BoxDecoration(
                color: isSelected ? kTeal : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _tabs[index],
                style: TextStyle(
                  color: isSelected ? kWhite : kHintColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTabContent(Map<String, dynamic> data) {
    switch (_selectedTab) {
      case 0:
        return _buildOverviewContent(data);
      case 1:
        return _buildDetailsContent(data);
      case 2:
        return _buildReviewsContent(data);
      default:
        return const Center(child: Text("Tab tidak valid."));
    }
  }

  Widget _buildOverviewContent(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Deskripsi
        Text(
          data['deskripsi_wisata'] ?? 'Belum ada deskripsi untuk wisata ini.',
          textAlign: TextAlign.justify,
          style: TextStyle(color: kBlack, fontSize: 14),
        ),
        const SizedBox(height: 24),

        // DETAIL METRIK (Duration, Distance, Temperature)
        _buildMetricRow(data),
      ],
    );
  }

  Widget _buildDetailsContent(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Detail (${data['nama_wisata']})',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryDark),
        ),
        const SizedBox(height: 12),
        if (data['alamat'] != null)
          _buildDetailRow(Icons.location_on_outlined, 'Alamat', data['alamat']),
        if (data['jam_buka'] != null)
          _buildDetailRow(Icons.access_time_outlined, 'Jam Operasional', data['jam_buka']),
        if (data['harga_tiket'] != null)
          _buildDetailRow(Icons.money_outlined, 'Harga Tiket', 'Rp${data['harga_tiket']}'),
      ],
    );
  }

  Widget _buildReviewsContent(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ulasan Pengunjung',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryDark),
        ),
        const SizedBox(height: 12),
        const Text("Belum ada ulasan terbaru untuk wisata ini.", style: TextStyle(color: kHintColor)),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kTeal, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: kBlack)),
              const SizedBox(height: 2),
              SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                child: Text(value, style: TextStyle(color: kBlack)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(Map<String, dynamic> data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMetricItem(
          icon: Icons.access_time_filled,
          color: kAccentRed,
          title: 'Duration',
          value: data['jam_buka'] ?? '6 Days',
        ),
        _buildMetricItem(
          icon: Icons.location_on,
          color: kTeal,
          title: 'Distance',
          value: '100 KM',
        ),
        _buildMetricItem(
          icon: Icons.wb_sunny,
          color: kWarningColor,
          title: 'Sunny',
          value: '24°C',
        ),
      ],
    );
  }

  Widget _buildMetricItem({required IconData icon, required Color color, required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 4),
            Text(value, style: TextStyle(color: kPrimaryDark, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(color: kHintColor, fontSize: 12)),
      ],
    );
  }

  Widget _buildBottomActionButton(BuildContext context, int wisataId) {
    return Container(
      color: kWhite,
      padding: EdgeInsets.fromLTRB(24, 0, 24, MediaQuery.of(context).padding.bottom + 16),
      child: Consumer<FavoriteProvider>(
        builder: (context, favProvider, child) {
          final bool isFav = favProvider.isFavorite(wisataId);

          return ElevatedButton(
            onPressed: () {
              if (isFav) {
                favProvider.removeFavorite(context, wisataId);
              } else {
                favProvider.addFavorite(context, wisataId);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kTeal,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: kTeal.withOpacity(0.5),
            ),
            child: Text(
              isFav ? 'Remove From Favorite' : 'Add To Favorite',
              style: TextStyle(
                color: kWhite,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}