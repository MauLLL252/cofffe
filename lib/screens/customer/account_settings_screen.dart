import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'payment_method_screen.dart';
import 'location_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  String _selectedPayment  = 'QRIS / E-Wallet';
  String _selectedLocation = 'Lokasi Outlet';

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
      appBar: _buildAppBar('Pengaturan Akun'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Metode Pembayaran ────────────────────────────
            _buildSection(
              title: 'Pembayaran',
              items: [
                _SettingItem(
                  icon: Icons.payment_outlined,
                  label: 'Metode Pembayaran',
                  value: _selectedPayment,
                  onTap: () async {
                    final result = await Navigator.of(context).push<String>(
                      MaterialPageRoute(
                        builder: (_) => PaymentMethodScreen(
                          selected: _selectedPayment,
                        ),
                      ),
                    );
                    if (result != null) {
                      setState(() => _selectedPayment = result);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Lokasi ───────────────────────────────────────
            _buildSection(
              title: 'Lokasi',
              items: [
                _SettingItem(
                  icon: Icons.location_on_outlined,
                  label: 'Lokasi',
                  value: _selectedLocation,
                  onTap: () async {
                    final result = await Navigator.of(context).push<String>(
                      MaterialPageRoute(
                        builder: (_) => LocationScreen(
                          selected: _selectedLocation,
                        ),
                      ),
                    );
                    if (result != null) {
                      setState(() => _selectedLocation = result);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Preferensi ───────────────────────────────────
            _buildSection(
              title: 'Preferensi',
              items: [
                _SettingItem(
                  icon: Icons.language_outlined,
                  label: 'Bahasa',
                  value: 'Indonesia',
                  onTap: () {},
                ),
                _SettingItem(
                  icon: Icons.dark_mode_outlined,
                  label: 'Tema Aplikasi',
                  value: 'Terang',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<_SettingItem> items,
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
              final item = items[i];
              final isLast = i == items.length - 1;
              return Column(
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.value,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textGrey,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right,
                            color: AppColors.textGrey, size: 18),
                      ],
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

class _SettingItem {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  const _SettingItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });
}

