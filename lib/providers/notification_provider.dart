import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  Future<void> initNotifications(String userId) async {
    // Inisialisasi Firebase
    await Firebase.initializeApp();

    // Minta izin (opsional)
    await FirebaseMessaging.instance.requestPermission();

    // Dapatkan token FCM
    final token = await FirebaseMessaging.instance.getToken();
    print('📱 FCM Token: $token');

    // Listener pesan saat app foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final data = message.data;
      final title = message.notification?.title ?? 'Notifikasi';
      final body = message.notification?.body ?? '';

      // Simpan ke Supabase
      await supabase.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'body': body,
        'data': data,
      });
    });
  }
}
