import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ItineraryInputScreen extends StatefulWidget {
  const ItineraryInputScreen({super.key});

  @override
  State<ItineraryInputScreen> createState() => _ItineraryInputScreenState();
}

class _ItineraryInputScreenState extends State<ItineraryInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _wilayahController = TextEditingController();
  final TextEditingController _lamaController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  String? _kategori;

  @override
  Widget build(BuildContext context) {
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
          child: ListView(
            children: [
              TextFormField(
                controller: _wilayahController,
                decoration: const InputDecoration(
                  labelText: 'Daerah / Wilayah',
                ),
                validator: (value) =>
                value!.isEmpty ? 'Masukkan daerah atau wilayah' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lamaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Lama Perjalanan (hari)',
                ),
                validator: (value) =>
                value!.isEmpty ? 'Masukkan lama perjalanan' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _kategori,
                items: const [
                  DropdownMenuItem(value: 'Alam', child: Text('Alam')),
                  DropdownMenuItem(value: 'Budaya', child: Text('Budaya')),
                  DropdownMenuItem(value: 'Kuliner', child: Text('Kuliner')),
                  DropdownMenuItem(value: 'Sejarah', child: Text('Sejarah')),
                ],
                onChanged: (val) => setState(() => _kategori = val),
                decoration: const InputDecoration(labelText: 'Kategori Wisata'),
                validator: (value) =>
                value == null ? 'Pilih kategori wisata' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tanggalController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Berangkat',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    _tanggalController.text =
                    '${picked.day}/${picked.month}/${picked.year}';
                  }
                },
                validator: (value) =>
                value!.isEmpty ? 'Pilih tanggal berangkat' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.push('/itinerary/result');
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Buat Itinerary'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
