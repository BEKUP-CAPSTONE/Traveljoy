import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveljoy/providers/wisata_provider.dart';
import 'package:traveljoy/providers/favorite_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/profile_provider.dart';
import '../main_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  late final ScrollController _scrollController;
  bool _isScrolled = false;

  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  List<String> get _loopedBanners {
    return List.generate(1000, (index) {
      final realIndex = index % _bannerImages.length;
      return _bannerImages[realIndex];
    });
  }

  int _currentBackgroundIndex = 0;

  final List<String> _filters = ['Semua', 'Favorit anda', 'Terbaru'];
  int _selectedFilterIndex = 0;

  late int _currentBannerPage;
  late final PageController _bannerPageController;
  Timer? _bannerTimer;

  final List<String> _bannerImages = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
  ];
  int? _selectedIdDaerah;

  void _scrollListener() {
    if (_scrollController.offset > kToolbarHeight && !_isScrolled) {
      if (mounted) {
        setState(() {
          _isScrolled = true;
        });
      }
    } else if (_scrollController.offset <= kToolbarHeight && _isScrolled) {
      if (mounted) {
        setState(() {
          _isScrolled = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    final userId = context.read<AuthProvider>().userId;
    if (userId != null) {
      context.read<NotificationProvider>().initNotifications(userId);
    }

    _currentBannerPage = 0;
    _bannerPageController = PageController(
      initialPage: _loopedBanners.length ~/ 2,
    );
    _startAutoScroll();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wisataProvider = context.read<WisataProvider>();
      wisataProvider.fetchKategori();
      wisataProvider.fetchRandomWisata();
    });
  }

  void _startAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerImages.isNotEmpty && _bannerPageController.hasClients) {
        final nextPage = _bannerPageController.page!.toInt() + 1;
        _bannerPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
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
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredWisata(
    WisataProvider wP,
    FavoriteProvider fP,
  ) {
    List<Map<String, dynamic>> allWisata = wP.wisata
        .cast<Map<String, dynamic>>();

    if (_selectedIdDaerah != null && _selectedIdDaerah! > 0) {
      allWisata = allWisata
          .where((w) => w['id_daerah'] == _selectedIdDaerah)
          .toList();
    }

    switch (_selectedFilterIndex) {
      case 1:
        final Set<int> favoriteIds = fP.favorites
            .map((f) => f['wisata_id'] as int)
            .toSet();
        return allWisata
            .where((w) => w['id'] != null && favoriteIds.contains(w['id']))
            .toList();
      case 2:
        return allWisata.take(10).toList();
      case 0:
      default:
        return allWisata;
    }
  }

  String _buildDisplayAddress(Map<String, dynamic> wisata) {
    final String namaDaerah = wisata['daerah']?['nama_daerah'] ?? '';

    if (namaDaerah.isNotEmpty) {
      return namaDaerah;
    }
    return 'Lokasi tidak tersedia';
  }

  Widget _buildHeader(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.supabase.auth.currentUser;
    final metadata = user?.userMetadata;
    final profileProvider = Provider.of<ProfileProvider>(context);

    final String displayName =
        (profileProvider.profileName?.trim().isNotEmpty ?? false)
        ? profileProvider.profileName!
        : (metadata?['name'] as String?)?.trim() ??
              user?.email?.split('@').first.toUpperCase() ??
              'Guest User';

    final String? avatarUrl = metadata?['avatar_url'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                final mainNavState = context
                    .findAncestorStateOfType<MainNavigationState>();
                mainNavState?.navigateToProfile();
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: avatarUrl == null
                        ? Icon(Icons.person, color: kWhite.withOpacity(0.8))
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hai ${displayName.split(' ').first},",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: kWhite,
                        ),
                      ),
                      const Text(
                        'Mau jalan-jalan kemana hari ini?',
                        style: TextStyle(fontSize: 14, color: kWhite),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                context.push('/notifications');
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kWhite.withOpacity(0.25),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.notifications_none, color: kWhite),
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
            ),
          ],
        ),
        const SizedBox(height: 20),

        _buildSearchBar(context),
        const SizedBox(height: 20),

        _buildAutoScrollBannerCard(context),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final wisataProvider = context.read<WisataProvider>();

    return Column(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 8.0),
                child: Icon(Icons.search, color: kHintColor),
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari wisata...',
                    hintStyle: TextStyle(color: kHintColor),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (value) async {
                    if (value.isEmpty) {
                      setState(() {
                        _searchResults = [];
                        _isSearching = false;
                      });
                      return;
                    }

                    setState(() => _isSearching = true);

                    final results = await wisataProvider.searchSuggestions(
                      value,
                    );
                    if (mounted) {
                      setState(() {
                        _searchResults = results;
                        _isSearching = false;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),

        if (_searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: _searchResults.map((item) {
                return ListTile(
                  title: Text(item['nama_wisata'] ?? ''),
                  onTap: () {
                    setState(() {
                      _searchController.text = item['nama_wisata'];
                      _searchResults = [];
                    });

                    context.push('/detail-wisata/${item['id']}');
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildAutoScrollBannerCard(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 1,
      child: PageView.builder(
        controller: _bannerPageController,
        itemCount: _loopedBanners.length,
        onPageChanged: (index) {
          setState(() {
            _currentBannerPage = index;
          });
        },
        itemBuilder: (context, index) {
          final bool isActive = index == _currentBannerPage;

          return AnimatedScale(
            scale: isActive ? 1.0 : 0.9,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      _loopedBanners[index],
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
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
                borderRadius: BorderRadius.circular(10),
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

  Widget _buildKategoriGrid(WisataProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori Wisata',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kBlack,
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
                  context.push(
                    '/wisata-kategori/${kategori['id']}/${kategori['nama_kategori']}',
                  );
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: kNeutralGrey.withOpacity(0.25),
                        child: Icon(categoryIcon, color: kBlack, size: 28),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        kategori['nama_kategori'] ?? '',
                        style: const TextStyle(fontSize: 13, color: kBlack),
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
    final List<Map<String, dynamic>> filteredWisata = _getFilteredWisata(
      provider,
      favProvider,
    );

    return Consumer<FavoriteProvider>(
      builder: (context, favProvider, child) {
        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            mainAxisExtent: 220,
          ),
          itemCount: filteredWisata.length,
          itemBuilder: (context, index) {
            final wisata = filteredWisata[index];
            final int wisataId = wisata['id'] ?? 0;
            final bool isFav = favProvider.isFavorite(wisataId);

            final List<dynamic>? gambarList = wisata['gambar_url'] as List?;
            final String gambarUrl =
                (gambarList != null && gambarList.isNotEmpty)
                ? gambarList.first.toString()
                : 'assets/images/wisataDefault.png';

            final String displayAddress = _buildDisplayAddress(wisata);

            return GestureDetector(
              onTap: () => context.push('/detail-wisata/$wisataId'),
              child: Container(
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildImage(gambarUrl, 130, double.infinity),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                if (isFav) {
                                  favProvider.removeFavorite(context, wisataId);
                                } else {
                                  favProvider.addFavorite(context, wisataId);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color: kWhite.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  color: kAccentRed,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wisata['nama_wisata'] ?? '-',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
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
              'Wisata Lainnya',
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
                _selectedIdDaerah != null && _selectedIdDaerah! > 0
                    ? 'Ganti Daerah'
                    : 'Pilih Daerah',
                style: TextStyle(color: kTeal, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: provider.wisata.length > 3 ? 3 : provider.wisata.length,
            itemBuilder: (context, index) {
              final wisata = provider.wisata[index];
              final List<dynamic>? gambarList = wisata['gambar_url'] as List?;
              final String gambarUrl =
                  (gambarList != null && gambarList.isNotEmpty)
                  ? gambarList.first.toString()
                  : 'assets/images/wisataDefault.png';

              final String displayAddress = _buildDisplayAddress(wisata);

              return GestureDetector(
                onTap: () => context.push('/detail-wisata/${wisata['id']}'),
                child: Container(
                  margin: const EdgeInsets.only(right: 16, top: 6, bottom: 6),
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
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: _buildImage(gambarUrl, 100, 100),
                        ),
                      ),
                      SizedBox(
                        width: 170,
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
                      const SizedBox(width: 12),
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
                child: Center(child: CircularProgressIndicator(color: kTeal)),
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
        : Image.asset(url, height: height, width: width, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final wisataProvider = context.watch<WisataProvider>();

    final double statusBarHeight = MediaQuery.of(context).padding.top;

    final SystemUiOverlayStyle currentStyle = _isScrolled
        ? SystemUiOverlayStyle(
            statusBarColor: kWhite,
            statusBarIconBrightness: Brightness.dark,
          )
        : const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: currentStyle,
      child: Scaffold(
        backgroundColor: kWhite,
        body: Stack(
          children: [
            SafeArea(
              top: false,
              child: wisataProvider.isLoading
                  ? Center(child: CircularProgressIndicator(color: kTeal))
                  : ListView(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(seconds: 2),
                          child: Container(
                            key: ValueKey<int>(_currentBackgroundIndex),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/onboarding1.jpeg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.center,
                                  colors: [
                                    Colors.white,
                                    Colors.white.withOpacity(0.0),
                                    Colors.black.withOpacity(0.4),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: statusBarHeight + 16),
                                    _buildHeader(context),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              _buildKategoriGrid(wisataProvider),
                              const SizedBox(height: 10),
                              _buildFilterTabs(),
                              const SizedBox(height: 20),
                              _buildPopularWisata(
                                context,
                                wisataProvider,
                                context.watch<FavoriteProvider>(),
                              ),
                              const SizedBox(height: 30),
                              _buildSpecialForYou(context, wisataProvider),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: statusBarHeight,
                color: _isScrolled ? kWhite : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
