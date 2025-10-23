// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:traveljoy/providers/history_provider.dart';
//
// class ItineraryScreen extends StatefulWidget {
//   const ItineraryScreen({super.key});
//
//   @override
//   State<ItineraryScreen> createState() => _ItineraryScreenState();
// }
//
// class _ItineraryScreenState extends State<ItineraryScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<HistoryProvider>().fetchHistory();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final historyProvider = context.watch<HistoryProvider>();
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Itinerary'), centerTitle: true),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ElevatedButton.icon(
//               onPressed: () {
//                 context.push('/itinerary/input');
//               },
//               icon: const Icon(Icons.add),
//               label: const Text('Buat Itinerary Baru'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Riwayat Itinerary',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 12),
//             Expanded(
//               child: historyProvider.isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : historyProvider.histories.isEmpty
//                   ? const Center(child: Text('Belum ada itinerary tersimpan'))
//                   : ListView.builder(
//                       itemCount: historyProvider.histories.length,
//                       itemBuilder: (context, index) {
//                         final item = historyProvider.histories[index];
//                         return Card(
//                           margin: const EdgeInsets.only(bottom: 12),
//                           child: ListTile(
//                             title: Text(item['judul'] ?? 'Tanpa judul'),
//                             subtitle: Text(
//                               item['created_at'] != null
//                                   ? item['created_at'].toString().substring(
//                                       0,
//                                       10,
//                                     )
//                                   : '-',
//                             ),
//                             trailing: const Icon(
//                               Icons.arrow_forward_ios,
//                               size: 16,
//                             ),
//                             onTap: () {
//                               context.push(
//                                 '/itinerary/result',
//                                 extra: {'isFromHistory': true},
//                               );
//                             },
//                           ),
//                         );
//                       },ub
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveljoy/providers/history_provider.dart';
import 'package:traveljoy/providers/itinerary_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/helper.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      textStyle: const TextStyle(
        fontSize: 16,
      ),
    );

    final cardShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: kHintColor, width: 1),
    );

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text(
          'Itinerary',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryDark,
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
                      title: Text(
                        item['judul'] ?? 'Tanpa judul',
                      ),
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

                        if (historyData != null && historyData is Map<String, dynamic>) {

                          context.read<ItineraryProvider>().loadFromHistory(historyData);

                          context.push(
                            '/itinerary/result',
                            extra: {'isFromHistory': true},
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Gagal memuat data riwayat')),
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