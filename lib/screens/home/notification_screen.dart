import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final user = context.read<AuthProvider>().supabase.auth.currentUser;
    if (user != null) {
      await context.read<NotificationProvider>().fetchNotifications(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifProvider = context.watch<NotificationProvider>();
    final notifications = notifProvider.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadNotifications,
        child: notifications.isEmpty
            ? const Center(child: Text('Belum ada notifikasi'))
            : ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notif = notifications[index];
            return ListTile(
              leading: Icon(
                notif.isRead ? Icons.notifications : Icons.notifications_active,
                color: notif.isRead ? Colors.grey : Colors.blue,
              ),
              title: Text(
                notif.title,
                style: TextStyle(
                  fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Text(
                notif.body ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                _timeAgo(notif.createdAt),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () => _showNotificationDetail(context, notif),
            );
          },
        ),
      ),
    );
  }

  void _showNotificationDetail(BuildContext context, NotificationModel notif) {
    context.read<NotificationProvider>().markAsRead(notif.id);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notif.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              notif.body ?? 'Tidak ada isi pesan',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              'Dikirim pada: ${notif.createdAt}',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return '${date.day}/${date.month}/${date.year}';
  }
}
