import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/itinerary_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _getUserName(AuthProvider authProvider) {
    final user = authProvider.supabase.auth.currentUser;
    final metadata = user?.userMetadata;

    String? name = metadata?['name'] as String?;

    if (name != null && name.isNotEmpty) {
      return name;
    }
    return user?.email?.split('@').first.toUpperCase() ?? "GUEST USER";
  }

  // Untuk mendapatkan URL avatar
  String? _getUserAvatarUrl(AuthProvider authProvider) {
    final user = authProvider.supabase.auth.currentUser;
    final metadata = user?.userMetadata;
    return metadata?['avatar_url'] as String?;
  }

  @override
  void initState() {
    super.initState();
    final profileProvider = context.read<ProfileProvider>();
    profileProvider.loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final itineraryProvider = Provider.of<ItineraryProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileProvider.setFavoriteCount(favoriteProvider.favorites.length);
    });

    final String userEmail = authProvider.userEmail.isNotEmpty
        ? authProvider.userEmail
        : "guest@example.com";

    final String userNameDisplay =
        profileProvider.profileName?.isNotEmpty == true
        ? profileProvider.profileName!
        : userEmail.split('@').first.toUpperCase();

    final String? avatarUrl = _getUserAvatarUrl(authProvider);

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: kPrimaryColor.withOpacity(0.1),
                  backgroundImage: avatarUrl != null
                      ? NetworkImage(avatarUrl)
                      : const NetworkImage(
                              'https://via.placeholder.com/150/3F52B4/FFFFFF?text=Profile',
                            )
                            as ImageProvider,
                  child: avatarUrl == null
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: kPrimaryColor.withOpacity(0.7),
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              userNameDisplay,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: kPrimaryDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(userEmail, style: TextStyle(fontSize: 16, color: kHintColor)),
            const SizedBox(height: 30),

            _buildStatCounts(
              itineraryCount: profileProvider.itineraryCount,
              favoriteCount: profileProvider.favoriteCount,
            ),

            const SizedBox(height: 30),

            // Daftar menu
            _buildProfileOption(
              context,
              icon: Icons.person_outline,
              title: 'Edit Profil',
              onTap: () {
                context.push('/edit-profile');
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.edit_note,
              title: 'Syarat Ketentuan',
              onTap: () {
                context.push('/terms');
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.info_outline,
              title: 'Tentang App',
              onTap: () {
                context.push('/tentang-app');
              },
            ),

            // Logout Button
            _buildLogoutButton(context, authProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCounts({
    required int itineraryCount,
    required int favoriteCount,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          value: itineraryCount.toString(),
          label: 'Itinerary dibuat',
          icon: Icons.calendar_month,
        ),
        Container(height: 50, width: 1, color: kNeutralGrey.withOpacity(0.5)),
        _buildStatItem(
          value: favoriteCount.toString(),
          label: 'Wisata favorit',
          icon: Icons.favorite,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: kTeal, size: 18),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kPrimaryDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: kHintColor)),
      ],
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kBlack.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: kPrimaryDark, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: kHintColor, size: 18),
          ],
        ),
      ),
    );
  }

  // Widget tombol Logout
  Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kBlack.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Konfirmasi Logout'),
                backgroundColor: Colors.white,
                content: const Text(
                  'Apakah kamu yakin ingin keluar dari akun ini?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentRed,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              );
            },
          );

          if (confirm == true) {
            await authProvider.logout();
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Logout berhasil")));
              context.go('/login');
            }
          }
        },
        child: Row(
          children: [
            Icon(Icons.logout, color: kAccentRed, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                  color: kAccentRed,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: kAccentRed, size: 18),
          ],
        ),
      ),
    );
  }
}
