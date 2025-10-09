import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:traveljoy/providers/wisata_provider.dart';

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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Pilih Daerah'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _daerahList.length,
        itemBuilder: (context, index) {
          final daerah = _daerahList[index];
          return ListTile(
            title: Text(daerah['nama_daerah'] ?? '-'),
            subtitle: Text(daerah['provinsi'] ?? ''),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/wisata-daerah/${daerah['id']}'),
          );
        },
      ),
    );
  }
}
