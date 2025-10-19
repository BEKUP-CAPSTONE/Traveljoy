import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/wisata_provider.dart';

class WisataKategoriScreen extends StatefulWidget {
  final int idKategori;
  final String namaKategori;

  const WisataKategoriScreen({
    super.key,
    required this.idKategori,
    required this.namaKategori,
  });

  @override
  State<WisataKategoriScreen> createState() => _WisataKategoriScreenState();
}

class _WisataKategoriScreenState extends State<WisataKategoriScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _wisataList = [];

  @override
  void initState() {
    super.initState();
    _loadWisata();
  }

  Future<void> _loadWisata() async {
    final provider = context.read<WisataProvider>();
    final data = await provider.fetchWisataByKategori(widget.idKategori);
    setState(() {
      _wisataList = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kTeal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Wisata ${widget.namaKategori}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _wisataList.isEmpty
          ? const Center(
        child: Text(
          'Belum ada wisata untuk kategori ini',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _wisataList.length,
        itemBuilder: (context, index) {
          final wisata = _wisataList[index];
          final gambar = (wisata['gambar_url'] as List?)?.isNotEmpty == true
              ? wisata['gambar_url'][0]
              : 'assets/images/wisataDefault.png';

          return Card(
            elevation: 4,
            color: kWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.push('/detail-wisata/${wisata['id']}'),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    gambar,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      'assets/images/wisataDefault.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  wisata['nama_wisata'] ?? '-',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  wisata['alamat'] ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.black54),
              ),
            ),
          );
        },
      ),
    );
  }
}
