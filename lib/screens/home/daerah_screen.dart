import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:traveljoy/providers/wisata_provider.dart';

import '../../core/constants/app_colors.dart';

class DaerahScreen extends StatefulWidget {
  const DaerahScreen({super.key});

  @override
  State<DaerahScreen> createState() => _DaerahScreenState();
}

class _DaerahScreenState extends State<DaerahScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _daerahList = [];

  @override
  void initState() {
    super.initState();
    _loadDaerah();
  }

  Future<void> _loadDaerah() async {
    final provider = context.read<WisataProvider>();
    final data = await provider.fetchDaerah();
    setState(() {
      _daerahList = data;
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
        title: const Text(
          'Pilih Daerah',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _daerahList.length,
        itemBuilder: (context, index) {
          final daerah = _daerahList[index];
          return Card(
            elevation: 4,
            color: kWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(
                daerah['nama_daerah'] ?? '-',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                "Provinsi ${daerah['provinsi'] ?? '-'}",
                style: const TextStyle(color: Colors.black54),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.black54),
              onTap: () => context.push('/wisata-daerah/${daerah['id']}'),
            ),
          );
        },
      ),
    );
  }
}
