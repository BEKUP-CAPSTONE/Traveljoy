import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final String _defaultImgAsset = 'assets/images/wisataDefault.png';

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _loadWisata();
    }
  }

  Future<void> _loadWisata() async {
    final provider = context.read<WisataProvider>();
    final data = await provider.fetchWisataByKategori(widget.idKategori);
    if (mounted) {
      setState(() {
        _wisataList = data;
        _isLoading = false;
      });
    }
  }

  Widget _buildDefaultImage() {
    return Image.asset(
      _defaultImgAsset,
      width: 70,
      height: 70,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: kWhite,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kPrimaryDark),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Wisata ${widget.namaKategori}',
          style: TextStyle(
            color: kBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: kTeal))
            : _wisataList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 80,
                      color: kNeutralGrey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada wisata untuk kategori ini',
                      style: TextStyle(fontSize: 16, color: kNeutralGrey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                itemCount: _wisataList.length,
                itemBuilder: (context, index) {
                  final wisata = _wisataList[index];

                  final List<dynamic>? gambarList =
                      wisata['gambar_url'] as List?;
                  final String? gambarUrl =
                      (gambarList != null && gambarList.isNotEmpty)
                      ? gambarList.first as String?
                      : null;
                  final bool hasUrl =
                      gambarUrl != null && gambarUrl.startsWith('http');

                  return Card(
                    elevation: 3,
                    shadowColor: kNeutralGrey.withOpacity(0.2),
                    color: kWhite,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: kNeutralGrey.withOpacity(0.5),
                        width: 0.8,
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () =>
                          context.push('/detail-wisata/${wisata['id']}'),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: hasUrl
                                  ? Image.network(
                                      gambarUrl!,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _buildDefaultImage(),
                                    )
                                  : _buildDefaultImage(),
                            ),
                            const SizedBox(width: 12),
                            // Teks
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    wisata['nama_wisata'] ?? '-',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: kPrimaryDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    wisata['alamat'] ?? '-',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: kNeutralGrey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.chevron_right,
                              color: kNeutralGrey.withOpacity(0.8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
