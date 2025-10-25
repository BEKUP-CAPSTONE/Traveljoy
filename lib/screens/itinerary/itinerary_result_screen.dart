import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/history_provider.dart';
import '../../providers/itinerary_provider.dart';
import '../../core/constants/app_colors.dart';

class ItineraryResultScreen extends StatelessWidget {
  final bool isFromHistory;

  const ItineraryResultScreen({super.key, this.isFromHistory = false});

  Icon _getWeatherIcon(String cuaca) {
    final cuacaLower = cuaca.toLowerCase();
    IconData iconData;
    Color iconColor;

    if (cuacaLower.contains('cerah')) {
      iconData = Icons.wb_sunny_rounded;
      iconColor = kWarningColor;
    } else if (cuacaLower.contains('hujan')) {
      iconData = Icons.umbrella_rounded;
      iconColor = kTeal;
    } else if (cuacaLower.contains('berawan') || cuacaLower.contains('awan')) {
      iconData = Icons.cloud_rounded;
      iconColor = Colors.grey.shade600;
    } else {
      iconData = Icons.thermostat_rounded;
      iconColor = Colors.grey.shade600;
    }

    return Icon(iconData, color: iconColor, size: 18);
  }

  @override
  Widget build(BuildContext context) {
    final itineraryProvider = context.watch<ItineraryProvider>();
    final historyProvider = context.read<HistoryProvider>();
    final data = itineraryProvider.generatedData;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: kTeal,
      foregroundColor: kWhite,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      textStyle: const TextStyle(fontSize: 16),
    );

    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: kHintColor.withOpacity(0.5), width: 1),
    );

    if (data == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: kPrimaryDark),
            onPressed: () => context.pop(),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(child: Text('Tidak ada data itinerary')),
      );
    }

    final judul = data['judul'] ?? 'Itinerary Perjalanan';
    final rencana = List<Map<String, dynamic>>.from(data['rencana'] ?? []);

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: Text(
          judul,
          style: const TextStyle(
            color: kBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryDark),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: rencana.length,
                  itemBuilder: (context, i) {
                    final hari = rencana[i];
                    final kegiatan = List<Map<String, dynamic>>.from(
                      hari['kegiatan'] ?? [],
                    );
                    final cuaca = hari['cuaca'] ?? '-';

                    return Card(
                      color: kWhite,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: cardShape,
                      elevation: 0,
                      clipBehavior: Clip.antiAlias,
                      child: ExpansionTile(
                        title: Text(
                          'Hari ${hari['hari']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(hari['tanggal']),
                            const SizedBox(height: 4),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _getWeatherIcon(cuaca),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    cuaca,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey.shade700,
                        ),

                        children: kegiatan.map((k) {
                          return ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    "•",
                                    style: TextStyle(
                                      color: kTeal,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(k['aktivitas']),
                                      const SizedBox(height: 2),
                                      Text(
                                        k['waktu'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: kHintColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                      if (success) {
                        context.pop();
                        context.pop();
                      }
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan Itinerary'),
                  style: buttonStyle,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
