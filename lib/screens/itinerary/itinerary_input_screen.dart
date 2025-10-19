import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/itinerary_provider.dart';
import '../../providers/wisata_provider.dart';
import 'package:intl/intl.dart';

class ItineraryInputScreen extends StatefulWidget {
  const ItineraryInputScreen({super.key});

  @override
  State<ItineraryInputScreen> createState() => _ItineraryInputScreenState();
}

class _ItineraryInputScreenState extends State<ItineraryInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final daerahController = TextEditingController();
  final hariController = TextEditingController();
  final tanggalController = TextEditingController();

  String? _selectedKategori;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<WisataProvider>().fetchKategori());
  }

  @override
  Widget build(BuildContext context) {
    final itineraryProvider = context.watch<ItineraryProvider>();
    final wisataProvider = context.watch<WisataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Itinerary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: daerahController,
                decoration: const InputDecoration(
                  labelText: 'Daerah / Wilayah',
                ),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: hariController,
                decoration: const InputDecoration(
                  labelText: 'Lama perjalanan (hari)',
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedKategori,
                items: wisataProvider.kategori.map<DropdownMenuItem<String>>((
                  item,
                ) {
                  return DropdownMenuItem<String>(
                    value: item['nama_kategori']?.toString(),
                    child: Text(item['nama_kategori'] ?? '-'),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => _selectedKategori = val);
                },
                decoration: const InputDecoration(labelText: 'Kategori wisata'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Wajib dipilih' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: tanggalController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Tanggal berangkat',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final now = DateTime.now();
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: now,
                    lastDate: DateTime(now.year + 1),
                  );
                  if (pickedDate != null) {
                    tanggalController.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(pickedDate);
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: itineraryProvider.isLoading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;

                        final success = await itineraryProvider
                            .generateItinerary(
                              daerah: daerahController.text,
                              lamaHari: int.tryParse(hariController.text) ?? 1,
                              kategori: _selectedKategori ?? '',
                              tanggal: tanggalController.text,
                            );

                        if (success && context.mounted) {
                          context.push('/itinerary/result');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gagal membuat itinerary'),
                            ),
                          );
                        }
                      },
                child: itineraryProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Buat Itinerary'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
