import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:traveljoy/providers/auth_provider.dart';
import 'package:traveljoy/providers/onboarding_provider.dart';
import 'package:traveljoy/screens/auth/login_screen.dart';
import 'package:traveljoy/screens/auth/register_screen.dart';
import 'package:traveljoy/screens/auth/terms_screen.dart';
import 'package:traveljoy/screens/favorite/favorite_screen.dart';
import 'package:traveljoy/screens/home/daerah_screen.dart';
import 'package:traveljoy/screens/home/wisata_daerah_screen.dart';
import 'package:traveljoy/screens/onboarding/onboarding_screen.dart';
import '../screens/home/wisata_kategori_screen.dart';
import '../screens/itinerary/itinerary_screen.dart';
import '../screens/main_navigation.dart';
import '../screens/home/detail_wisata_screen.dart';
import '../screens/itinerary/itinerary_result_screen.dart';
import '../screens/itinerary/itinerary_input_screen.dart';
import '../screens/profile/edit_profile_screen.dart';

class AppRouter {
  static GoRouter createRouter(
    AuthProvider authProvider,
    OnboardingProvider onboardingProvider,
  ) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: Listenable.merge([authProvider, onboardingProvider]),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const MainNavigation(),
          routes: [
            GoRoute(
              path: 'itinerary/input',
              builder: (context, state) => const ItineraryInputScreen(),
            ),
            GoRoute(
              path: '/itinerary/result',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final isFromHistory = extra?['isFromHistory'] ?? false;
                return ItineraryResultScreen(isFromHistory: isFromHistory);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/terms',
          builder: (context, state) => const TermsScreen(),
        ),
        GoRoute(
          path: '/daerah',
          builder: (context, state) => const DaerahScreen(),
        ),
        GoRoute(
          path: '/wisata-daerah/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return WisataDaerahScreen(idDaerah: id);
          },
        ),
        GoRoute(
          path: '/wisata-kategori/:id/:nama',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            final nama = state.pathParameters['nama']!;
            return WisataKategoriScreen(idKategori: id, namaKategori: nama);
          },
        ),
        GoRoute(
          path: '/edit-profile',
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: '/detail-wisata/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return DetailWisataScreen(id: id);
          },
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoriteScreen(),
        ),
      ],
      redirect: (context, state) {
        final loggedIn = authProvider.isLoggedIn;
        final hasSeenOnboarding = onboardingProvider.hasSeenOnboarding;
        final loggingIn =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';
        final onboarding = state.matchedLocation == '/onboarding';

        if (!hasSeenOnboarding && !onboarding) {
          return '/onboarding';
        }
        if (!loggedIn && !loggingIn && hasSeenOnboarding) {
          return '/login';
        }
        if (loggedIn && loggingIn) {
          return '/';
        }
        return null;
      },
    );
  }
}

// GoRoute(
//   path: '/detail-wisata',
//   builder: (context, state) => const DetailWisataScreen(),
// ),
//
// GoRoute(
//   path: '/itinerary-result',
//   builder: (context, state) => const ItineraryResultScreen(),
// ),
//
// GoRoute(
//   path: '/itinerary-history',
//   builder: (context, state) => const ItineraryHistoryScreen(),
// ),
