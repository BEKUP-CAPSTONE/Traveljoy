import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/itinerary_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final itineraryProvider = Provider.of<ItineraryProvider>(context);

    // sinkronisasi jumlah favorit dan itinerary
    profileProvider.setFavoriteCount(favoriteProvider.favorites.length);

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("User: ${authProvider.userEmail.isNotEmpty ? authProvider.userEmail : "Guest"}"),
            const SizedBox(height: 16),
            Text("Itinerary dibuat: ${itineraryProvider.history.length}"),
            Text("Wisata favorit: ${profileProvider.favoriteCount}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authProvider.logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logout berhasil")),
                );
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
