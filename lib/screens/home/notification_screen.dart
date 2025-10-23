import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
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
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text('Notification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: kWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: kPrimaryDark),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: kPrimaryDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadNotifications,
        child: notifications.isEmpty
            ? _buildEmptyState()
            : _buildNotificationList(notifications),
      ),
    );
  }

  Widget _buildEmptyState() {
    final lightBg = Colors.grey.shade100;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Container(
          height: MediaQuery.of(context).size.height -
              kToolbarHeight -
              MediaQuery.of(context).padding.top,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: lightBg,
                child: const Icon(
                  Icons.notifications_none_outlined,
                  size: 32,
                  color: kPrimaryDark,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Ups! Belum ada notifikasi",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Sepertinya status anda kosong. Kami akan memberi tahu Anda saat pembaruan tiba!", // Teks dari desain
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kHintColor,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationList(List<NotificationModel> notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, color: kNeutralGrey),
              children: [
                const TextSpan(text: 'You have '),
                TextSpan(
                  text: '${notifications.length} Notifications',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kTeal,
                  ),
                ),
                const TextSpan(text: ' today'),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];

              final iconData = notif.isRead
                  ? Icons.chat_bubble_outline
                  : Icons.chat_bubble;

              return Card(
                elevation: 0,
                color: kWhite,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: kHintColor, width: 1),
                ),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: kHintColor.withOpacity(0.15),
                    child: Icon(
                      iconData,
                      color: kNeutralGrey,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    notif.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryDark,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    notif.body ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: kHintColor, fontSize: 14),
                  ),
                  trailing: Text(
                    _timeAgo(notif.createdAt),
                    style: const TextStyle(fontSize: 12, color: kHintColor),
                  ),
                  onTap: () => _showNotificationDetail(context, notif),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showNotificationDetail(BuildContext context, NotificationModel notif) {
    context.read<NotificationProvider>().markAsRead(notif.id);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: kWhite,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notif.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kPrimaryDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              notif.body ?? 'Tidak ada isi pesan',
              style: const TextStyle(
                fontSize: 16,
                color: kPrimaryDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Dikirim pada: ${notif.createdAt}',
              style: const TextStyle(
                fontSize: 13,
                color: kHintColor,
              ),
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