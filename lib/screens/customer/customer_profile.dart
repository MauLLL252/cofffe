import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'edit_profile_screen.dart';
import 'account_settings_screen.dart';
import 'notification_screen.dart';
import 'security_screen.dart';
import 'faq_screen.dart';

class CustomerProfile extends StatelessWidget {
  const CustomerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Profil Saya',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ),

              _buildProfileCard(context),
              const SizedBox(height: 12),
              _buildMemberCard(),
              const SizedBox(height: 12),
              _buildMenuSection(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person,
                    size: 40, color: AppColors.primary),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  ),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.edit,
                        size: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Maulana Riski',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'maulana.riski@email.com',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.textGrey),
                ),
                SizedBox(height: 2),
                Text(
                  '+62 812 3456 7890',
                  style: TextStyle(
                      fontSize: 12, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status Member',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7)),
              ),
              const SizedBox(height: 4),
              const Text(
                '🏆 Gold Member',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Poin Tersedia',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7)),
              ),
              const SizedBox(height: 4),
              const Text(
                '1.250',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final items = [
      _MenuItem(
        icon: Icons.settings_outlined,
        label: 'Pengaturan Akun',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const AccountSettingsScreen(),
        )),
      ),
      _MenuItem(
        icon: Icons.notifications_outlined,
        label: 'Notifikasi',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const NotificationScreen(),
        )),
      ),
      _MenuItem(
        icon: Icons.shield_outlined,
        label: 'Keamanan',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const SecurityScreen(),
        )),
      ),
      _MenuItem(
        icon: Icons.help_outline,
        label: 'Bantuan & FAQ',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const FaqScreen(),
        )),
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ...items.map((item) => Column(
            children: [
              ListTile(
                onTap: item.onTap,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item.icon,
                      color: AppColors.primary, size: 20),
                ),
                title: Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right,
                    color: AppColors.textGrey),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
            ],
          )),

          // Logout
          ListTile(
            onTap: () => _confirmLogout(context),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.logout,
                  color: AppColors.error, size: 20),
            ),
            title: const Text(
              'Keluar',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
            trailing: const Icon(Icons.chevron_right,
                color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar?'),
        content: const Text('Kamu akan keluar dari akun ini.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.textGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .pushReplacementNamed('/auth');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}