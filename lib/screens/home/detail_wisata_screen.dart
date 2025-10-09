import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traveljoy/providers/wisata_provider.dart';
import 'package:go_router/go_router.dart';

class DetailWisataScreen extends StatefulWidget {
  final int id;
  const DetailWisataScreen({super.key, required this.id});

  @override
  State<DetailWisataScreen> createState() => _DetailWisataScreenState();
}

class _DetailWisataScreenState extends State<DetailWisataScreen> {
  Map<String, dynamic>? wisata;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    final provider = context.read<WisataProvider>();
    final data = await provider.fetchWisataById(widget.id);
    setState(() {
      wisata = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Detail Wisata'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : wisata == null
          ? const Center(child: Text('Data wisata tidak ditemukan.'))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar utama
            wisata!['gambar_url'] != null &&
                (wisata!['gambar_url'] as List).isNotEmpty
                ? Image.network(
              (wisata!['gambar_url'] as List).first,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/wisataDefault.png',
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            )
                : Image.asset(
              'assets/images/wisataDefault.png',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wisata!['nama_wisata'] ?? 'Tanpa Nama',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (wisata!['alamat'] != null)
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            wisata!['alamat'],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  if (wisata!['harga_tiket'] != null)
                    Text(
                      'Harga Tiket: Rp${wisata!['harga_tiket']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  if (wisata!['jam_buka'] != null)
                    Text(
                      'Jam Buka: ${wisata!['jam_buka']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    wisata!['deskripsi_wisata'] ??
                        'Belum ada deskripsi.',
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
