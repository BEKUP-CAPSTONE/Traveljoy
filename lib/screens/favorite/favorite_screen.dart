import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorite_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Wisata")),
      body: favoriteProvider.favorites.isEmpty
          ? const Center(child: Text("Belum ada wisata favorit"))
          : ListView.builder(
        itemCount: favoriteProvider.favorites.length,
        itemBuilder: (context, index) {
          final wisata = favoriteProvider.favorites[index];
          return ListTile(
            title: Text(wisata),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                favoriteProvider.removeFavorite(wisata);
              },
            ),
          );
        },
      ),
    );
  }
}
