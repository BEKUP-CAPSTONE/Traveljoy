import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveljoy/providers/history_provider.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Itinerary'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                context.push('/itinerary/input');
              },
              icon: const Icon(Icons.add),
              label: const Text('Buat Itinerary Baru'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
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
                  ? const Center(child: CircularProgressIndicator())
                  : historyProvider.histories.isEmpty
                  ? const Center(child: Text('Belum ada itinerary tersimpan'))
                  : ListView.builder(
                      itemCount: historyProvider.histories.length,
                      itemBuilder: (context, index) {
                        final item = historyProvider.histories[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
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
                            ),
                            onTap: () {
                              context.push(
                                '/itinerary/result',
                                extra: {'isFromHistory': true},
                              );
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
