// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/history_provider.dart';
// import '../../providers/itinerary_provider.dart';
// import 'package:go_router/go_router.dart';
//
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import '../../providers/itinerary_provider.dart';
// import '../../providers/history_provider.dart';
//
// class ItineraryResultScreen extends StatelessWidget {
//   final bool isFromHistory;
//
//   const ItineraryResultScreen({super.key, this.isFromHistory = false});
//
//   @override
//   Widget build(BuildContext context) {
//     final itineraryProvider = context.watch<ItineraryProvider>();
//     final historyProvider = context.read<HistoryProvider>();
//     final data = itineraryProvider.generatedData;
//
//     if (data == null) {
//       return const Scaffold(
//         body: Center(child: Text('Tidak ada data itinerary')),
//       );
//     }
//
//     final judul = data['judul'] ?? 'Itinerary Perjalanan';
//     final rencana = List<Map<String, dynamic>>.from(data['rencana'] ?? []);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(judul),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => context.pop(),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: rencana.length,
//                 itemBuilder: (context, i) {
//                   final hari = rencana[i];
//                   final kegiatan = List<Map<String, dynamic>>.from(
//                     hari['kegiatan'],
//                   );
//                   final cuaca = hari['cuaca'] ?? '-';
//
//                   return Card(
//                     margin: const EdgeInsets.only(bottom: 12),
//                     child: ExpansionTile(
//                       title: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('Hari ${hari['hari']} - ${hari['tanggal']}'),
//                           Text(
//                             cuaca,
//                             style: const TextStyle(
//                               fontSize: 13,
//                               color: Colors.blueGrey,
//                             ),
//                           ),
//                         ],
//                       ),
//                       children: kegiatan.map((k) {
//                         return ListTile(
//                           title: Text(k['aktivitas']),
//                           subtitle: Text(k['waktu']),
//                         );
//                       }).toList(),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (!isFromHistory)
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   final success = await historyProvider.saveHistory(
//                     judul: judul,
//                     preferensi: data,
//                     narasi: rencana.toString(),
//                   );
//
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           success
//                               ? 'Itinerary disimpan 🎉'
//                               : 'Gagal menyimpan itinerary',
//                         ),
//                       ),
//                     );
//                     if (success) context.go('/itinerary');
//                   }
//                 },
//                 icon: const Icon(Icons.save),
//                 label: const Text('Simpan Itinerary'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/history_provider.dart';
import '../../providers/itinerary_provider.dart';
import '../../core/constants/app_colors.dart';

class ItineraryResultScreen extends StatelessWidget {
  final bool isFromHistory;

  const ItineraryResultScreen({super.key, this.isFromHistory = false});

  @override
  Widget build(BuildContext context) {
    final itineraryProvider = context.watch<ItineraryProvider>();
    final historyProvider = context.read<HistoryProvider>();
    final data = itineraryProvider.generatedData;

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


    if (data == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: kPrimaryDark),
            onPressed: () => context.pop(),
          ),
          backgroundColor: Colors.transparent,
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
        title: Text(judul, style: const TextStyle(color: kPrimaryDark, fontSize: 18, fontWeight: FontWeight.bold,)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryDark),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(hari['tanggal']),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cuaca,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey.shade700,
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
                style: buttonStyle,
              ),
          ],
        ),
      ),
    );
  }
}