import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveljoy/providers/history_provider.dart';
import 'package:traveljoy/providers/itinerary_provider.dart';
import '../../core/constants/app_colors.dart';

class ItineraryScreen extends StatefulWidget {
  const ItineraryScreen({super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().fetchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();

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

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text(
          'Itinerary',
          style: TextStyle(
            color: kBlack,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryDark,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                context.read<ItineraryProvider>().clear();
                context.push('/itinerary/input');
              },
              icon: const Icon(Icons.add),
              label: const Text('Buat Itinerary Baru'),
              style: buttonStyle,
            ),
            const SizedBox(height: 24),

            // Disclaimer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kTeal.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kTeal.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, color: kTeal, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Itinerary ini dibuat oleh AI 🤖. Selalu periksa kembali detail seperti jam buka dan harga tiket untuk memastikan akurasinya ya!",
                      style: TextStyle(
                        color: kPrimaryDark.withOpacity(0.8),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Riwayat Itinerary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: historyProvider.isLoading
                  ? const Center(child: CircularProgressIndicator(color: kTeal))
                  : historyProvider.histories.isEmpty
                  ? const Center(child: Text('Belum ada itinerary tersimpan'))
                  : ListView.builder(
                      itemCount: historyProvider.histories.length,
                      itemBuilder: (context, index) {
                        final item = historyProvider.histories[index];

                        return Card(
                          color: kWhite,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: cardShape,
                          elevation: 0,
                          child: ListTile(
                            title: Text(item['judul'] ?? 'Tanpa judul'),
                            subtitle: Text(
                              item['created_at'] != null
                                  ? item['created_at'].toString().substring(
                                      0,
                                      10,
                                    )
                                  : '-',
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: kPrimaryDark,
                            ),
                            onTap: () {
                              final historyData = item['preferensi'];

                              if (historyData != null &&
                                  historyData is Map<String, dynamic>) {
                                context
                                    .read<ItineraryProvider>()
                                    .loadFromHistory(historyData);

                                context.push(
                                  '/itinerary/result',
                                  extra: {'isFromHistory': true},
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Gagal memuat data riwayat'),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
