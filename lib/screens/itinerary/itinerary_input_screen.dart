import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/itinerary_provider.dart';
import '../../providers/wisata_provider.dart';
import '../../core/constants/app_colors.dart';

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

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: kTeal,
      foregroundColor: kWhite,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      textStyle: const TextStyle(fontSize: 16),
    );

    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: kNeutralGrey.withOpacity(0.5)),
    );

    final focusedOutlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: kTeal, width: 2),
    );

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text(
          'Buat Itinerary',
          style: TextStyle(
            color: kBlack,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryDark),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: kTeal),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Field Daerah ---
                  const Text(
                    'Daerah / Wilayah',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: daerahController,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Yogyakarta',
                      hintStyle: TextStyle(color: kHintColor.withOpacity(0.5)),
                      border: outlineBorder,
                      enabledBorder: outlineBorder,
                      focusedBorder: focusedOutlineBorder,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Lama perjalanan (hari)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: hariController,
                    decoration: InputDecoration(
                      hintText: 'Contoh: 3',
                      hintStyle: TextStyle(color: kHintColor.withOpacity(0.5)),
                      border: outlineBorder,
                      enabledBorder: outlineBorder,
                      focusedBorder: focusedOutlineBorder,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  // --- Field Kategori ---
                  const Text(
                    'Kategori wisata',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedKategori,
                    items: wisataProvider.kategori
                        .map<DropdownMenuItem<String>>((item) {
                          return DropdownMenuItem<String>(
                            value: item['nama_kategori']?.toString(),
                            child: Text(item['nama_kategori'] ?? '-'),
                          );
                        })
                        .toList(),
                    onChanged: (val) {
                      setState(() => _selectedKategori = val);
                    },
                    decoration: InputDecoration(
                      hintText: 'Pilih kategori',
                      hintStyle: TextStyle(color: kHintColor.withOpacity(0.5)),
                      border: outlineBorder,
                      enabledBorder: outlineBorder,
                      focusedBorder: focusedOutlineBorder,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Wajib dipilih' : null,
                  ),
                  const SizedBox(height: 16),

                  // --- Field Tanggal ---
                  const Text(
                    'Tanggal berangkat',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: tanggalController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Pilih tanggal',
                      hintStyle: TextStyle(color: kHintColor.withOpacity(0.5)),
                      border: outlineBorder,
                      enabledBorder: outlineBorder,
                      focusedBorder: focusedOutlineBorder,
                      suffixIcon: const Icon(Icons.calendar_today),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
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
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: kTeal,
                                onPrimary: kWhite,
                                onSurface: kBlack,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: kTeal,
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        tanggalController.text = DateFormat(
                          'yyyy-MM-dd',
                        ).format(pickedDate);
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Tombol Submit
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: itineraryProvider.isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;

                            final success = await itineraryProvider
                                .generateItinerary(
                                  daerah: daerahController.text,
                                  lamaHari:
                                      int.tryParse(hariController.text) ?? 1,
                                  kategori: _selectedKategori ?? '',
                                  tanggal: tanggalController.text,
                                );

                            if (success && context.mounted) {
                              context.push('/itinerary/result');
                            } else if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Gagal membuat itinerary'),
                                ),
                              );
                            }
                          },
                    child: itineraryProvider.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: kWhite,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text('Buat Itinerary'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
