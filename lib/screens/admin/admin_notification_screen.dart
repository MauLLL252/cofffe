import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AdminNotificationScreen extends StatefulWidget {
  const AdminNotificationScreen({super.key});

  @override
  State<AdminNotificationScreen> createState() =>
      _AdminNotificationScreenState();
}

class _AdminNotificationScreenState
    extends State<AdminNotificationScreen> {
  bool _newOrder     = true;
  bool _orderDone    = true;
  bool _lowStock     = true;
  bool _newUser      = false;
  bool _dailyReport  = true;
  bool _sound        = true;
  bool _vibrate      = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _appBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSection(
              title: 'Notifikasi Pesanan',
              items: [
                _Item(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Pesanan Baru Masuk',
                  subtitle: 'Notif setiap ada pesanan baru',
                  value: _newOrder,
                  onChanged: (v) => setState(() => _newOrder = v),
                ),
                _Item(
                  icon: Icons.check_circle_outline,
                  label: 'Pesanan Selesai',
                  subtitle: 'Notif saat pesanan selesai dikerjakan',
                  value: _orderDone,
                  onChanged: (v) => setState(() => _orderDone = v),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildSection(
              title: 'Notifikasi Toko',
              items: [
                _Item(
                  icon: Icons.inventory_2_outlined,
                  label: 'Stok Menipis',
                  subtitle: 'Peringatan saat bahan baku hampir habis',
                  value: _lowStock,
                  onChanged: (v) => setState(() => _lowStock = v),
                ),
                _Item(
                  icon: Icons.person_add_outlined,
                  label: 'Pengguna Baru',
                  subtitle: 'Notif saat ada customer baru daftar',
                  value: _newUser,
                  onChanged: (v) => setState(() => _newUser = v),
                ),
                _Item(
                  icon: Icons.bar_chart_outlined,
                  label: 'Laporan Harian',
                  subtitle: 'Ringkasan penjualan setiap hari pukul 23:00',
                  value: _dailyReport,
                  onChanged: (v) =>
                      setState(() => _dailyReport = v),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildSection(
              title: 'Suara & Getar',
              items: [
                _Item(
                  icon: Icons.volume_up_outlined,
                  label: 'Suara Notifikasi',
                  subtitle: 'Aktifkan suara saat ada notifikasi',
                  value: _sound,
                  onChanged: (v) => setState(() => _sound = v),
                ),
                _Item(
                  icon: Icons.vibration_outlined,
                  label: 'Getar',
                  subtitle: 'Aktifkan getar saat ada notifikasi',
                  value: _vibrate,
                  onChanged: (v) => setState(() => _vibrate = v),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Riwayat notif
            _buildNotifHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<_Item> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textGrey,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(items.length, (i) {
              final item   = items[i];
              final isLast = i == items.length - 1;
              return Column(
                children: [
                  SwitchListTile(
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(item.icon,
                          color: AppColors.primary, size: 18),
                    ),
                    title: Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                    subtitle: Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textGrey,
                      ),
                    ),
                    value: item.value,
                    onChanged: item.onChanged,
                    activeColor: AppColors.primary,
                  ),
                  if (!isLast)
                    const Divider(
                        height: 1, indent: 56, endIndent: 16),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildNotifHistory() {
    final notifs = [
      _Notif(
        icon: Icons.shopping_bag,
        color: AppColors.primary,
        title: 'Pesanan Baru',
        body: 'ORD-005 dari Siti Rahayu masuk',
        time: '2 menit lalu',
      ),
      _Notif(
        icon: Icons.check_circle,
        color: AppColors.success,
        title: 'Pesanan Selesai',
        body: 'ORD-004 berhasil diselesaikan',
        time: '15 menit lalu',
      ),
      _Notif(
        icon: Icons.bar_chart,
        color: AppColors.accent,
        title: 'Laporan Harian',
        body: 'Total pendapatan hari ini Rp 1.250.000',
        time: 'Kemarin 23:00',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'Riwayat Notifikasi',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textGrey,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(notifs.length, (i) {
              final notif  = notifs[i];
              final isLast = i == notifs.length - 1;
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: notif.color.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(notif.icon,
                          color: notif.color, size: 20),
                    ),
                    title: Text(
                      notif.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    subtitle: Text(
                      notif.body,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textGrey,
                      ),
                    ),
                    trailing: Text(
                      notif.time,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                  if (!isLast)
                    const Divider(
                        height: 1, indent: 56, endIndent: 16),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios,
            size: 18, color: AppColors.textDark),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Notifikasi',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      centerTitle: true,
    );
  }
}

class _Item {
  final IconData icon;
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Item({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
}

class _Notif {
  final IconData icon;
  final Color color;
  final String title, body, time;
  const _Notif({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
  });
}