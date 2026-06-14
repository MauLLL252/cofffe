import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'store_settings_screen.dart';
import 'manage_users_screen.dart';
import 'admin_notification_screen.dart';
import 'admin_help_screen.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header ────────────────────────────────────
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Profil Admin',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ),

              // ── Kartu Admin ──────────────────────────────
              _buildAdminCard(),
              const SizedBox(height: 16),

              // ── Statistik Cepat ──────────────────────────
              _buildQuickStats(),
              const SizedBox(height: 16),

              // ── Menu ─────────────────────────────────────
              _buildMenuSection(context),
              const SizedBox(height: 24),

              const Text(
                'Titik Kopi v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard() {
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
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person,
                size: 36, color: Colors.white),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Titik Kopi',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'admin@titikkopi.com',
                style: TextStyle(
                    fontSize: 13, color: Colors.white70),
              ),
              SizedBox(height: 4),
              Text(
                '👑 Super Admin',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _statCard('Total Menu', '11'),
          const SizedBox(width: 12),
          _statCard('Total Order', '5'),
          const SizedBox(width: 12),
          _statCard('Hari Aktif', '30'),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final items = [
      _MenuItem(
        icon: Icons.store_outlined,
        label: 'Pengaturan Toko',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const StoreSettingsScreen(),
        )),
      ),
      _MenuItem(
        icon: Icons.people_outline,
        label: 'Kelola Pengguna',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const ManageUsersScreen(),
        )),
      ),
      _MenuItem(
        icon: Icons.notifications_outlined,
        label: 'Notifikasi',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const AdminNotificationScreen(),
        )),
      ),
      _MenuItem(
        icon: Icons.help_outline,
        label: 'Bantuan',
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const AdminHelpScreen(),
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
          ...items.map(
                (item) => Column(
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
            ),
          ),

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
        content: const Text('Kamu akan keluar dari akun admin.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.textGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/auth');
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