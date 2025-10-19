import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/history_provider.dart';
import '../../providers/itinerary_provider.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/itinerary_provider.dart';
import '../../providers/history_provider.dart';

class ItineraryResultScreen extends StatelessWidget {
  final bool isFromHistory;

  const ItineraryResultScreen({super.key, this.isFromHistory = false});

  @override
  Widget build(BuildContext context) {
    final itineraryProvider = context.watch<ItineraryProvider>();
    final historyProvider = context.read<HistoryProvider>();
    final data = itineraryProvider.generatedData;

    if (data == null) {
      return const Scaffold(
        body: Center(child: Text('Tidak ada data itinerary')),
      );
    }

    final judul = data['judul'] ?? 'Itinerary Perjalanan';
    final rencana = List<Map<String, dynamic>>.from(data['rencana'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
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
              child: ListView.builder(
                itemCount: rencana.length,
                itemBuilder: (context, i) {
                  final hari = rencana[i];
                  final kegiatan = List<Map<String, dynamic>>.from(
                    hari['kegiatan'],
                  );
                  final cuaca = hari['cuaca'] ?? '-';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Hari ${hari['hari']} - ${hari['tanggal']}'),
                          Text(
                            cuaca,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                      children: kegiatan.map((k) {
                        return ListTile(
                          title: Text(k['aktivitas']),
                          subtitle: Text(k['waktu']),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (!isFromHistory)
              ElevatedButton.icon(
                onPressed: () async {
                  final success = await historyProvider.saveHistory(
                    judul: judul,
                    preferensi: data,
                    narasi: rencana.toString(),
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? 'Itinerary disimpan 🎉'
                              : 'Gagal menyimpan itinerary',
                        ),
                      ),
                    );
                    if (success) context.go('/itinerary');
                  }
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
