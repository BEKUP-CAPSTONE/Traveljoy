import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:traveljoy/providers/wisata_provider.dart';

class WisataDaerahScreen extends StatefulWidget {
  final int idDaerah;
  const WisataDaerahScreen({super.key, required this.idDaerah});

  @override
  State<WisataDaerahScreen> createState() => _WisataDaerahScreenState();
}

class _WisataDaerahScreenState extends State<WisataDaerahScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _wisataList = [];

  @override
  void initState() {
    super.initState();
    _loadWisata();
  }

  Future<void> _loadWisata() async {
    final provider = context.read<WisataProvider>();
    final data = await provider.fetchWisataByDaerah(widget.idDaerah);
    setState(() {
      _wisataList = data;
      _isLoading = false;
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
        title: const Text('Wisata di Daerah Ini'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wisataList.isEmpty
          ? const Center(child: Text('Belum ada wisata di daerah ini'))
          : ListView.builder(
        itemCount: _wisataList.length,
        itemBuilder: (context, index) {
          final wisata = _wisataList[index];
          final gambar = (wisata['gambar_url'] as List?)?.isNotEmpty == true
              ? wisata['gambar_url'][0]
              : 'assets/images/wisataDefault.png';
          return GestureDetector(
            onTap: () => context.push('/detail-wisata/${wisata['id']}'),
            child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  gambar,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Image.asset('assets/images/wisataDefault.png', width: 70, height: 70, fit: BoxFit.cover),
                ),
              ),
              title: Text(wisata['nama_wisata'] ?? '-'),
              subtitle: Text(
                wisata['kategori']?['nama_kategori'] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          );
        },
      ),
    );
  }
}
