import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    if (mounted) {
      _loadDaerah();
    }
  }

  Future<void> _loadDaerah() async {
    final provider = context.read<WisataProvider>();
    final data = await provider.fetchDaerah();
    if (mounted) {
      setState(() {
        _daerahList = data;
        _isLoading = false;
      });
    }
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
          'Pilih Daerah',
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
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                itemCount: _daerahList.length,
                itemBuilder: (context, index) {
                  final daerah = _daerahList[index];

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
                          context.push('/wisata-daerah/${daerah['id']}'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    daerah['nama_daerah'] ?? '-',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: kPrimaryDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Provinsi ${daerah['provinsi'] ?? '-'}",
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
