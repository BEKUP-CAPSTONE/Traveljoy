import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/main_navigation.dart';
import '../screens/home/detail_wisata_screen.dart';
import '../screens/itinerary/itinerary_result_screen.dart';
import '../screens/itinerary/itinerary_history_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    GoRoute(
      path: '/',
      builder: (context, state) => const MainNavigation(),
    ),

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
  ],
);
