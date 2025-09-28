import 'dart:convert';
import 'package:flutter/services.dart';

class Secrets {
  static late String supabaseUrl;
  static late String supabaseAnonKey;
  static late String geminiAPIKey;

  static Future<void> load() async {
    final data = await rootBundle.loadString('assets/secrets.json');
    final json = jsonDecode(data);
    supabaseUrl = json['SUPABASE_URL'];
    supabaseAnonKey = json['SUPABASE_ANON_KEY'];
    geminiAPIKey = json['GEMINI_API_KEY'];
  }
}
