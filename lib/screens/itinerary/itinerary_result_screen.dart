import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ItineraryResultScreen extends StatelessWidget {
  const ItineraryResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Itinerary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    title: Text('Hari 1'),
                    subtitle: Text('08:00 - 10:00: Kunjungan ke Candi Borobudur\n'
                        '11:00 - 13:00: Makan siang di restoran lokal'),
                  ),
                  ListTile(
                    title: Text('Hari 2'),
                    subtitle: Text('09:00 - 11:00: Wisata alam di Kaliurang'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // nanti simpan ke database
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Itinerary berhasil disimpan')),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text('Simpan Itinerary'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
