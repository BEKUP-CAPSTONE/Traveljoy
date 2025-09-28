import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wisata_provider.dart';
import '../../providers/favorite_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wisataProvider = Provider.of<WisataProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: ListView.builder(
        itemCount: wisataProvider.wisataList.length,
        itemBuilder: (context, index) {
          final wisata = wisataProvider.wisataList[index];
          final isFavorite = favoriteProvider.favorites.contains(wisata);

          return ListTile(
            title: Text(wisata),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                if (isFavorite) {
                  favoriteProvider.removeFavorite(wisata);
                } else {
                  favoriteProvider.addFavorite(wisata);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
