// import 'package:flutter/material.dart';
// import 'home/home_screen.dart';
// import 'itinerary/itinerary_screen.dart';
// import 'favorite/favorite_screen.dart';
// import 'profile/profile_screen.dart';
//
// class MainNavigation extends StatefulWidget {
//   const MainNavigation({super.key});
//
//   @override
//   State<MainNavigation> createState() => _MainNavigationState();
// }
//
// class _MainNavigationState extends State<MainNavigation> {
//   int _currentIndex = 0;
//
//   final List<Widget> _screens = const [
//     HomeScreen(),
//     ItineraryScreen(),
//     FavoriteScreen(),
//     ProfileScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.map),
//             label: "Itinerary",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: "Favorite",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: "Profile",
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'home/home_screen.dart';
// import 'itinerary/itinerary_screen.dart';
// import 'favorite/favorite_screen.dart';
// import 'profile/profile_screen.dart';
// import '../core/constants/app_colors.dart';
//
// class MainNavigation extends StatefulWidget {
//   const MainNavigation({super.key});
//
//   @override
//   State<MainNavigation> createState() => _MainNavigationState();
// }
//
// class _MainNavigationState extends State<MainNavigation> {
//   int _currentIndex = 0;
//
//   final List<Widget> _screens = const [
//     HomeScreen(),
//     ItineraryScreen(),
//     FavoriteScreen(),
//     ProfileScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     // Ambil nilai padding bawah sistem (untuk area gesture bar/notch)
//     final double bottomPadding = MediaQuery.of(context).padding.bottom;
//
//     return Scaffold(
//       body: _screens[_currentIndex],
//
//       // === CUSTOM BOTTOM NAVIGATION BAR (DIBUNGKUS DENGAN PADDING) ===
//       bottomNavigationBar: Padding(
//         // Menambahkan padding di bagian bawah (melayang) dan padding HORIZONTAL (kiri-kanan)
//         padding: EdgeInsets.only(
//           bottom: bottomPadding + 10,
//           left: 16, // Padding horizontal 16px
//           right: 16, // Padding horizontal 16px
//         ),
//         child: Container(
//           height: 80,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//           // HAPUS color: kWhite di sini
//           decoration: BoxDecoration(
//             // === PERUBAHAN: Warna diletakkan di DECORATION ===
//             color: kWhite,
//             // ===============================================
//             // Menggunakan All untuk rounded
//             borderRadius: const BorderRadius.all(Radius.circular(25)),
//             boxShadow: [
//               BoxShadow(
//                 color: kBlack.withOpacity(0.1),
//                 blurRadius: 15,
//                 offset: const Offset(0, 5), // Offset positif agar shadow ke bawah
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildNavItem(0, Icons.home),
//               _buildNavItem(1, Icons.location_on_outlined),
//               _buildNavItem(2, Icons.notifications_none_outlined),
//               _buildNavItem(3, Icons.settings_outlined),
//             ],
//           ),
//         ),
//       ),
//       // ====================================
//     );
//   }
//
//   // Widget Item Navigasi Kustom
//   Widget _buildNavItem(int index, IconData icon) {
//     final bool isActive = index == _currentIndex;
//     final Color activeColor = kTeal;
//     final Color inactiveColor = kNeutralGrey;
//
//     // Penentuan Ikon: Ikon Penuh jika aktif
//     final IconData displayIcon = (isActive && index == 0)
//         ? Icons.home
//         : (isActive && index == 1)
//         ? Icons.location_on
//         : (isActive && index == 2)
//         ? Icons.notifications
//         : (isActive && index == 3)
//         ? Icons.settings
//         : icon;
//
//     return Expanded(
//       child: InkWell(
//         borderRadius: BorderRadius.circular(10),
//         onTap: () {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         child: SizedBox(
//           height: double.infinity,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 10), // Padding atas
//
//               // Ikon Utama
//               Container(
//                 padding: const EdgeInsets.only(bottom: 4),
//                 child: Icon(
//                   displayIcon,
//                   color: isActive ? activeColor : inactiveColor,
//                   size: 28,
//                 ),
//               ),
//
//               // DOT Indikator Aktif
//               if (isActive)
//                 Container(
//                   width: 6,
//                   height: 6,
//                   decoration: BoxDecoration(
//                     color: activeColor,
//                     shape: BoxShape.circle,
//                   ),
//                 )
//               else
//                 const SizedBox(height: 6), // Spacer untuk menjaga ketinggian
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'itinerary/itinerary_screen.dart';
import 'favorite/favorite_screen.dart';
import 'profile/profile_screen.dart';
import '../core/constants/app_colors.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ItineraryScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      extendBody: true,

      backgroundColor: Colors.transparent,

      body: _screens[_currentIndex],

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: 16,
          left: 16,
          right: 16,
        ),
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: kBlack.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home),
              _buildNavItem(1, Icons.location_on_outlined),
              _buildNavItem(2, Icons.favorite_border_outlined),
              _buildNavItem(3, Icons.settings_outlined),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Item Navigasi Kustom
  Widget _buildNavItem(int index, IconData icon) {
    final bool isActive = index == _currentIndex;
    final Color activeColor = kTeal;
    final Color inactiveColor = kNeutralGrey;

    // Ikon
    final IconData displayIcon = (isActive && index == 0)
        ? Icons.home
        : (isActive && index == 1)
        ? Icons.location_on
        : (isActive && index == 2)
        ? Icons.favorite
        : (isActive && index == 3)
        ? Icons.settings
        : icon;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10), // Padding atas

              // Ikon Utama
              Container(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(
                  displayIcon,
                  color: isActive ? activeColor : inactiveColor,
                  size: 28,
                ),
              ),

              // DOT Indikator Aktif
              if (isActive)
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: activeColor,
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(height: 6), // Spacer untuk menjaga ketinggian
            ],
          ),
        ),
      ),
    );
  }
}
