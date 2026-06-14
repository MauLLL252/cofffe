import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _orderUpdate   = true;
  bool _promo         = true;
  bool _pointReward   = false;
  bool _newsletter    = false;
  bool _sound         = true;
  bool _vibrate       = true;

  AppBar _buildAppBar(String title) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios,
            size: 18, color: AppColors.textDark),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar('Notifikasi'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildToggleSection(
              title: 'Notifikasi Pesanan',
              items: [
                _ToggleItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Update Status Pesanan',
                  subtitle: 'Notif saat pesanan diproses & siap',
                  value: _orderUpdate,
                  onChanged: (v) =>
                      setState(() => _orderUpdate = v),
                ),
                _ToggleItem(
                  icon: Icons.local_offer_outlined,
                  label: 'Promo & Diskon',
                  subtitle: 'Penawaran spesial dan voucher',
                  value: _promo,
                  onChanged: (v) =>
                      setState(() => _promo = v),
                ),
                _ToggleItem(
                  icon: Icons.stars_outlined,
                  label: 'Reward & Poin',
                  subtitle: 'Info penambahan dan penukaran poin',
                  value: _pointReward,
                  onChanged: (v) =>
                      setState(() => _pointReward = v),
                ),
                _ToggleItem(
                  icon: Icons.newspaper_outlined,
                  label: 'Newsletter',
                  subtitle: 'Berita & update dari Titik Kopi',
                  value: _newsletter,
                  onChanged: (v) =>
                      setState(() => _newsletter = v),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildToggleSection(
              title: 'Suara & Getar',
              items: [
                _ToggleItem(
                  icon: Icons.volume_up_outlined,
                  label: 'Suara Notifikasi',
                  subtitle: 'Aktifkan suara saat ada notifikasi',
                  value: _sound,
                  onChanged: (v) => setState(() => _sound = v),
                ),
                _ToggleItem(
                  icon: Icons.vibration_outlined,
                  label: 'Getar',
                  subtitle: 'Aktifkan getar saat ada notifikasi',
                  value: _vibrate,
                  onChanged: (v) =>
                      setState(() => _vibrate = v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSection({
    required String title,
    required List<_ToggleItem> items,
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
                  ListTile(
                    leading: Container(
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
                    trailing: Switch(
                      value: item.value,
                      onChanged: item.onChanged,
                      activeColor: AppColors.primary,
                    ),
                  ),
                  if (!isLast)
                    const Divider(height: 1, indent: 56, endIndent: 16),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ToggleItem {
  final IconData icon;
  final String label, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
}