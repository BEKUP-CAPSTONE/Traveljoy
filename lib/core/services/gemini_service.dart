import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static String? _apiKey;
  static GenerativeModel? _model;

  /// Inisialisasi Gemini
  static Future<void> init() async {
    if (_model != null) return;

    final data = await rootBundle.loadString('assets/secrets.json');
    final jsonData = json.decode(data);
    _apiKey = jsonData['GEMINI_API_KEY'];

    _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: _apiKey!);
  }

  /// Fungsi utama: buat itinerary dan tambahkan cuaca
  static Future<Map<String, dynamic>?> generateItinerary({
    required String daerah,
    required int lamaHari,
    required String kategori,
    required String tanggal,
  }) async {
    await init();

    final prompt =
        '''
Buatkan itinerary perjalanan wisata selama $lamaHari hari di $daerah 
dengan tema "$kategori", berangkat tanggal $tanggal.
Format hasil dalam JSON seperti ini (tanpa teks tambahan di luar JSON):

{
  "judul": "Liburan ke $daerah",
  "rencana": [
    {
      "hari": 1,
      "tanggal": "YYYY-MM-DD",
      "kegiatan": [
        {
          "waktu": "08:00 - 10:00",
          "aktivitas": "Deskripsi aktivitas"
        }
      ]
    }
  ]
}
''';

    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';
      final cleanText = text
          .trim()
          .replaceAll('```json', '')
          .replaceAll('```', '');

      final jsonMap = jsonDecode(
        RegExp(r'\{[\s\S]*\}').firstMatch(cleanText)?.group(0) ?? cleanText,
      );

      // tambahkan cuaca berdasarkan tanggal di itinerary
      if (jsonMap['rencana'] != null) {
        for (var hari in jsonMap['rencana']) {
          final cuaca = await generateWeatherInfo(
            daerah: daerah,
            tanggal: hari['tanggal'],
          );
          hari['cuaca'] = cuaca;
        }
      }

      return jsonMap;
    } catch (e) {
      print('❌ Gemini error: $e');
      return null;
    }
  }

  /// 🔹 Fungsi tambahan untuk dapatkan cuaca dari Gemini
  static Future<String> generateWeatherInfo({
    required String daerah,
    required String tanggal,
  }) async {
    await init();
    try {
      final prompt =
          '''
Berikan prakiraan cuaca singkat untuk wilayah $daerah pada tanggal $tanggal.
Contoh format jawaban (hanya satu kalimat pendek tanpa tambahan lain):
"Cerah berawan, suhu sekitar 31°C".
''';

      final response = await _model!.generateContent([Content.text(prompt)]);
      final text = response.text?.trim() ?? '-';
      return text.replaceAll('"', '');
    } catch (e) {
      print('⚠️ Gagal ambil cuaca: $e');
      return '-';
    }
  }
}
