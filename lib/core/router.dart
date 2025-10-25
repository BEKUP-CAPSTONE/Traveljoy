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
import '../screens/home/notification_screen.dart';
import '../screens/home/wisata_kategori_screen.dart';
import '../screens/main_navigation.dart';
import '../screens/home/detail_wisata_screen.dart';
import '../screens/itinerary/itinerary_result_screen.dart';
import '../screens/itinerary/itinerary_input_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/tentang_app.dart';

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
          pageBuilder: (context, state) =>
              _buildSlideTransitionPage(state, const MainNavigation()),
          routes: [
            GoRoute(
              path: 'itinerary/input',
              pageBuilder: (context, state) => _buildSlideTransitionPage(
                state,
                const ItineraryInputScreen(),
              ),
            ),
            GoRoute(
              path: '/itinerary/result',
              pageBuilder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final isFromHistory = extra?['isFromHistory'] ?? false;
                return _buildSlideTransitionPage(
                  state,
                  ItineraryResultScreen(isFromHistory: isFromHistory),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/onboarding',
          pageBuilder: (context, state) =>
              _buildSlideTransitionPage(state, const OnboardingScreen()),
        ),
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) =>
              _buildSlideTransitionPage(state, const LoginScreen()),
        ),
        GoRoute(
          path: '/register',
          pageBuilder: (context, state) =>
              _buildSlideTransitionPage(state, const RegisterScreen()),
        ),
        GoRoute(
          path: '/terms',
          pageBuilder: (context, state) =>
              _buildSlideTransitionPage(state, const TermsScreen()),
        ),
        GoRoute(
          path: '/tentang-app',
          pageBuilder: (context, state) =>
              _buildSlideTransitionPage(state, const AboutAppScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) =>
              _buildSlideTransitionPage(state, const ProfileScreen()),
        ),
        GoRoute(
          path: '/daerah',
          pageBuilder: (context, state) =>
              _buildSlideTransitionPage(state, const DaerahScreen()),
        ),
        GoRoute(
          path: '/wisata-daerah/:id',
          pageBuilder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return _buildSlideTransitionPage(
              state,
              WisataDaerahScreen(idDaerah: id),
            );
          },
        ),
        GoRoute(
          path: '/wisata-kategori/:id/:nama',
          pageBuilder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            final nama = state.pathParameters['nama']!;
            return _buildSlideTransitionPage(
              state,
              WisataKategoriScreen(idKategori: id, namaKategori: nama),
            );
          },
        ),
        GoRoute(
          path: '/edit-profile',
          pageBuilder: (context, state) =>
              _buildSlideTransitionPage(state, const EditProfileScreen()),
        ),
        GoRoute(
          path: '/detail-wisata/:id',
          pageBuilder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return _buildSlideTransitionPage(state, DetailWisataScreen(id: id));
          },
        ),
        GoRoute(
          path: '/favorites',
          pageBuilder: (context, state) =>
              _buildSlideTransitionPage(state, const FavoriteScreen()),
        ),
        GoRoute(
          path: '/notifications',
          pageBuilder: (context, state) =>
              _buildSlideTransitionPage(state, const NotificationScreen()),
        ),
      ],
      redirect: (context, state) {
        final loggedIn = authProvider.isLoggedIn;
        final hasSeenOnboarding = onboardingProvider.hasSeenOnboarding;
        final loggingIn =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';
        final onboarding = state.matchedLocation == '/onboarding';
        final publicRoutes = ['/terms'];

        if (!hasSeenOnboarding && !onboarding) {
          return '/onboarding';
        }
        if (!loggedIn &&
            !loggingIn &&
            hasSeenOnboarding &&
            !publicRoutes.contains(state.matchedLocation)) {
          return '/login';
        }
        if (loggedIn && loggingIn) {
          return '/';
        }
        return null;
      },
    );
  }

  static CustomTransitionPage _buildSlideTransitionPage(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
