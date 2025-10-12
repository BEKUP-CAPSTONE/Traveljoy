// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:traveljoy/providers/wisata_provider.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   int _currentPage = 0;
//   late final PageController _pageController;
//   Timer? _timer;
//
//   final List<String> bannerImages = [
//     'assets/images/onboarding1.jpg',
//     'assets/images/onboarding2.jpg',
//     'assets/images/onboarding3.jpg',
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _startAutoScroll();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final wisataProvider = context.read<WisataProvider>();
//       wisataProvider.fetchKategori();
//       wisataProvider.fetchRandomWisata();
//     });
//   }
//
//   void _startAutoScroll() {
//     _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
//       if (_pageController.hasClients) {
//         int nextPage = (_currentPage + 1) % bannerImages.length;
//         _pageController.animateToPage(
//           nextPage,
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pageController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final wisataProvider = context.watch<WisataProvider>();
//     final supabase = Supabase.instance.client;
//
//     // Ambil nama dari session user
//     final user = supabase.auth.currentUser;
//     final displayName = user?.userMetadata?['name'] ?? 'Hai kamu 👋';
//
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: SafeArea(
//         child: wisataProvider.isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : ListView(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//                 children: [
//                   // Header
//                   Text(
//                     displayName,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Search bar (belum aktif)
//                   TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Cari wisata...',
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Banner
//                   SizedBox(
//                     height: 180,
//                     child: PageView.builder(
//                       controller: _pageController,
//                       itemCount: bannerImages.length,
//                       onPageChanged: (index) {
//                         setState(() {
//                           _currentPage = index;
//                         });
//                       },
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: const EdgeInsets.only(right: 8),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(16),
//                             image: DecorationImage(
//                               image: AssetImage(bannerImages[index]),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(bannerImages.length, (index) {
//                       return AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         margin: const EdgeInsets.symmetric(horizontal: 4),
//                         width: _currentPage == index ? 12 : 8,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           color: _currentPage == index
//                               ? Colors.blue
//                               : Colors.grey,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                       );
//                     }),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Kategori
//                   const Text(
//                     'Kategori Wisata',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 12),
//
//                   GridView.builder(
//                     itemCount: wisataProvider.kategori.length,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 4,
//                           mainAxisExtent: 90,
//                         ),
//                     itemBuilder: (context, index) {
//                       final kategori = wisataProvider.kategori[index];
//                       return Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircleAvatar(
//                             radius: 28,
//                             backgroundColor: Colors.blueAccent.withOpacity(0.1),
//                             child: const Icon(
//                               Icons.place,
//                               color: Colors.blueAccent,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             kategori['nama_kategori'],
//                             style: const TextStyle(fontSize: 13),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Wisata
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Rekomendasi untuk Anda',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () => context.push('/daerah'),
//                         child: const Text('Lihat Daerah'),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//
//                   Column(
//                     children: wisataProvider.wisata.map((wisata) {
//                       final List<dynamic>? gambarList =
//                           wisata['gambar_url'] as List?;
//                       final String gambarUrl =
//                           (gambarList != null && gambarList.isNotEmpty)
//                           ? gambarList.first.toString()
//                           : 'assets/images/wisataDefault.png';
//
//                       return GestureDetector(
//                         onTap: () =>
//                             context.push('/detail-wisata/${wisata['id']}'),
//                         child: Container(
//                           margin: const EdgeInsets.only(bottom: 12),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 6,
//                                 offset: const Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: const BorderRadius.vertical(
//                                   top: Radius.circular(16),
//                                 ),
//                                 child: gambarUrl.startsWith('http')
//                                     ? Image.network(
//                                         gambarUrl,
//                                         height: 160,
//                                         width: double.infinity,
//                                         fit: BoxFit.cover,
//                                         loadingBuilder:
//                                             (context, child, loadingProgress) {
//                                               if (loadingProgress == null)
//                                                 return child;
//                                               return Container(
//                                                 height: 160,
//                                                 width: double.infinity,
//                                                 color: Colors.grey[200],
//                                                 child: const Center(
//                                                   child:
//                                                       CircularProgressIndicator(),
//                                                 ),
//                                               );
//                                             },
//                                         errorBuilder:
//                                             (context, error, stackTrace) {
//                                               return Image.asset(
//                                                 'assets/images/wisataDefault.png',
//                                                 height: 160,
//                                                 width: double.infinity,
//                                                 fit: BoxFit.cover,
//                                               );
//                                             },
//                                       )
//                                     : Image.asset(
//                                         gambarUrl,
//                                         height: 160,
//                                         width: double.infinity,
//                                         fit: BoxFit.cover,
//                                       ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(12),
//                                 child: Text(
//                                   wisata['nama_wisata'] ?? '-',
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }



import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveljoy/providers/wisata_provider.dart';
import 'package:traveljoy/providers/favorite_provider.dart';
import '../../core/constants/app_colors.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['Semua', 'Terfavorit', 'Untuk Anda'];
  int _selectedFilterIndex = 0;

  late int _currentBannerPage;
  late final PageController _bannerPageController;
  Timer? _bannerTimer;
  final List<String> _bannerImages = [
    'assets/images/onboarding1.jpeg',
    'assets/images/onboarding2.jpeg',
    'assets/images/onboarding3.jpeg',
  ];

  int? _selectedIdDaerah;

  @override
  void initState() {
    super.initState();

    _currentBannerPage = 0;
    _bannerPageController = PageController();
    _startAutoScroll();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wisataProvider = context.read<WisataProvider>();
      wisataProvider.fetchKategori();
      wisataProvider.fetchRandomWisata();
    });
  }

  void _startAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerPageController.hasClients) {
        int nextPage = (_currentBannerPage + 1) % _bannerImages.length;
        _bannerPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerPageController.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredWisata(WisataProvider wP, FavoriteProvider fP) {
    List<Map<String, dynamic>> allWisata = wP.wisata.cast<Map<String, dynamic>>();

    if (_selectedIdDaerah != null && _selectedIdDaerah! > 0) {
      allWisata = allWisata.where((w) => w['id_daerah'] == _selectedIdDaerah).toList();
    }

    switch (_selectedFilterIndex) {
      case 1:
        final Set<int> favoriteIds = fP.favorites.map((f) => f['wisata_id'] as int).toSet();
        return allWisata.where((w) => w['id'] != null && favoriteIds.contains(w['id'])).toList();
      case 2:
        return allWisata.take(10).toList();
      case 0:
      default:
        return allWisata;
    }
  }

  String _buildDisplayAddress(Map<String, dynamic> wisata) {
    final String lokasi = wisata['lokasi'] ?? '';
    final String namaDaerah = wisata['nama_daerah'] ?? '';
    final String alamatLengkap = wisata['alamat'] ?? '';

    if (alamatLengkap.isNotEmpty) {
      return alamatLengkap;
    }
    else if (lokasi.isNotEmpty || namaDaerah.isNotEmpty) {
      final parts = [if (lokasi.isNotEmpty) lokasi, if (namaDaerah.isNotEmpty) namaDaerah];
      return parts.join(', ');
    }
    return 'Lokasi tidak tersedia';
  }


  Widget _buildHeader(BuildContext context, String displayName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kWhite,
                        ),
                      ),
                      const Text(
                        'Where do you want to go?',
                        style: TextStyle(
                          fontSize: 14,
                          color: kHintColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kWhite.withOpacity(0.25),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.notifications_none, color: kPrimaryDark),
                  const Positioned(
                    top: 12,
                    right: 12,
                    child: SizedBox(
                      width: 8,
                      height: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kAccentRed,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        _buildSearchBar(context),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kNeutralGrey.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 8.0),
            child: Icon(Icons.search, color:kPrimaryDark),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari wisata...',
                hintStyle: TextStyle(color: kPrimaryDark),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: kNeutralGrey.withOpacity(0.5))),
            ),
            child: Icon(Icons.filter_list, color: kPrimaryDark),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedFilterIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? kTeal : kWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? kTeal : kNeutralGrey.withOpacity(0.3),
                ),
              ),
              child: Text(
                _filters[index],
                style: TextStyle(
                  color: isSelected ? kWhite : kBlack,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAutoScrollBanner(BuildContext context) {

    const double newBannerHeight = 295.0;

    return SizedBox(
      height: newBannerHeight,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: Stack(
          children: [
            PageView.builder(
              controller: _bannerPageController,
              itemCount: _bannerImages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentBannerPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          _bannerImages[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color.fromRGBO(0, 0, 0, 0.2), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildKategoriGrid(WisataProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori Wisata',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kWhite,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.kategori.length,
            itemBuilder: (context, index) {
              final kategori = provider.kategori[index];

              IconData categoryIcon;
              switch (kategori['nama_kategori']?.toLowerCase()) {
                case 'alam':
                  categoryIcon = Icons.eco_outlined;
                  break;
                case 'kuliner':
                  categoryIcon = Icons.restaurant_menu_outlined;
                  break;
                case 'religi':
                  categoryIcon = Icons.mosque_outlined;
                  break;
                case 'budaya':
                  categoryIcon = Icons.museum_outlined;
                  break;
                case 'sejarah':
                  categoryIcon = Icons.history_edu_outlined;
                  break;
                default:
                  categoryIcon = Icons.place;
              }

              return GestureDetector(
                onTap: () {
                  context.push('/wisata-daerah/${kategori['id']}');
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:kWhite.withOpacity(0.25),
                        child: Icon(
                          categoryIcon,
                          color: kPrimaryDark,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        kategori['nama_kategori'] ?? '',
                        style: const TextStyle(fontSize: 13, color: kWhite),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  Widget _buildPopularWisata(
      BuildContext context,
      WisataProvider provider,
      FavoriteProvider favProvider,
      ) {
    final List<Map<String, dynamic>> filteredWisata =
    _getFilteredWisata(provider, favProvider);

    return Consumer<FavoriteProvider>(
      builder: (context, favProvider, child) {
        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            mainAxisExtent: 230,
          ),
          itemCount: filteredWisata.length,
          itemBuilder: (context, index) {
            final wisata = filteredWisata[index];
            final int wisataId = wisata['id'] ?? 0;
            final bool isFav = favProvider.isFavorite(wisataId);

            final List<dynamic>? gambarList = wisata['gambar_url'] as List?;
            final String gambarUrl = (gambarList != null && gambarList.isNotEmpty)
                ? gambarList.first.toString()
                : 'assets/images/wisataDefault.png';

            final String displayAddress = _buildDisplayAddress(wisata);

            return GestureDetector(
              onTap: () => context.push('/detail-wisata/$wisataId'),
              child: Container(
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(16),
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
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: _buildImage(gambarUrl, 130, double.infinity),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: kWhite.withOpacity(0.8),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_outline,
                                color: kAccentRed,
                                size: 22,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                if (isFav) {
                                  favProvider.removeFavorite(context, wisataId);
                                } else {
                                  favProvider.addFavorite(context, wisataId);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        wisata['nama_wisata'] ?? '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: kPrimaryDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: kTeal, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              displayAddress,
                              style: const TextStyle(
                                fontSize: 12,
                                color: kNeutralGrey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
        );
      },
    );
  }

  Widget _buildSpecialForYou(BuildContext context, WisataProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Special For you',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kBlack,
              ),
            ),
            TextButton(
              onPressed: () async {
                final selectedId = await context.push('/daerah');
                if (selectedId != null && selectedId is int) {
                  setState(() {
                    _selectedIdDaerah = selectedId;
                  });
                }
              },
              child: Text(
                _selectedIdDaerah != null && _selectedIdDaerah! > 0 ? 'Ganti Daerah' : 'Pilih Daerah',
                style: TextStyle(color: kTeal, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.wisata.length > 3 ? 3 : provider.wisata.length,
            itemBuilder: (context, index) {
              final wisata = provider.wisata[index];
              final List<dynamic>? gambarList = wisata['gambar_url'] as List?;
              final String gambarUrl = (gambarList != null && gambarList.isNotEmpty)
                  ? gambarList.first.toString()
                  : 'assets/images/wisataDefault.png';

              final String displayAddress = _buildDisplayAddress(wisata);

              return GestureDetector(
                onTap: () => context.push('/detail-wisata/${wisata['id']}'),
                child: Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: kNeutralGrey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                        child: _buildImage(gambarUrl, 100, 80),
                      ),
                      const SizedBox(width: 12),
                      // Nama dan Lokasi
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              wisata['nama_wisata'] ?? '-',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: kPrimaryDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on, color: kTeal, size: 14),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    displayAddress,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: kNeutralGrey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
    );
  }


  Widget _buildImage(String url, double height, double width) {
    return url.startsWith('http')
        ? Image.network(
      url,
      height: height,
      width: width,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: height,
          width: width,
          color: kNeutralGrey.withOpacity(0.2),
          child: Center(
            child: CircularProgressIndicator(color: kTeal),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/wisataDefault.png',
          height: height,
          width: width,
          fit: BoxFit.cover,
        );
      },
    )
        : Image.asset(
      url,
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final wisataProvider = context.watch<WisataProvider>();
    final displayName = 'Esther Howard';

    const double overlapAmount = 20.0;

    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: wisataProvider.isLoading
            ? Center(child: CircularProgressIndicator(color: kTeal))
            : ListView(
          padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -overlapAmount,
                  left: -16,
                  right: -16,
                  child: _buildAutoScrollBanner(context),
                ),

                _buildHeader(context, displayName),
              ],
            ),

            _buildKategoriGrid(wisataProvider),
            const SizedBox(height: 30),

            _buildFilterTabs(),
            const SizedBox(height: 20),

            _buildPopularWisata(context, wisataProvider, context.watch<FavoriteProvider>()),
            const SizedBox(height: 30),

            _buildSpecialForYou(context, wisataProvider),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}