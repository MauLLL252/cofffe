import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}


class _SecurityScreenState extends State<SecurityScreen> {
  bool _biometric = false;
  bool _twoFactor = false;

  void _showChangePassword() {
    final oldCtrl  = TextEditingController();
    final newCtrl  = TextEditingController();
    final confCtrl = TextEditingController();
    bool obscureOld  = true;
    bool obscureNew  = true;
    bool obscureConf = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ubah Password',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 20),
                _passField(
                  label: 'Password Lama',
                  ctrl: oldCtrl,
                  obscure: obscureOld,
                  toggle: () =>
                      setSheet(() => obscureOld = !obscureOld),
                ),
                const SizedBox(height: 12),
                _passField(
                  label: 'Password Baru',
                  ctrl: newCtrl,
                  obscure: obscureNew,
                  toggle: () =>
                      setSheet(() => obscureNew = !obscureNew),
                ),
                const SizedBox(height: 12),
                _passField(
                  label: 'Konfirmasi Password Baru',
                  ctrl: confCtrl,
                  obscure: obscureConf,
                  toggle: () =>
                      setSheet(() => obscureConf = !obscureConf),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                          const Text('✅ Password berhasil diubah'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Simpan Password'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passField({
    required String label,
    required TextEditingController ctrl,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textGrey,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.lock_outline,
                size: 18, color: AppColors.textGrey),
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18,
                color: AppColors.textGrey,
              ),
              onPressed: toggle,
            ),
          ),
        ),
      ],
    );
  }

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
      appBar: _buildAppBar('Keamanan'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Password ─────────────────────────────────────
            _buildSection(
              title: 'Password',
              children: [
                ListTile(
                  onTap: _showChangePassword,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.lock_outline,
                        color: AppColors.primary, size: 18),
                  ),
                  title: const Text(
                    'Ubah Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  subtitle: const Text(
                    'Terakhir diubah 30 hari yang lalu',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textGrey),
                  ),
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.textGrey, size: 18),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Keamanan Tambahan ─────────────────────────────
            _buildSection(
              title: 'Keamanan Tambahan',
              children: [
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.fingerprint,
                        color: AppColors.primary, size: 18),
                  ),
                  title: const Text(
                    'Biometrik / Sidik Jari',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  subtitle: const Text(
                    'Login menggunakan sidik jari',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textGrey),
                  ),
                  value: _biometric,
                  onChanged: (v) =>
                      setState(() => _biometric = v),
                  activeColor: AppColors.primary,
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.verified_user_outlined,
                        color: AppColors.primary, size: 18),
                  ),
                  title: const Text(
                    'Verifikasi 2 Langkah',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  subtitle: const Text(
                    'Kode OTP dikirim ke nomor HP kamu',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textGrey),
                  ),
                  value: _twoFactor,
                  onChanged: (v) =>
                      setState(() => _twoFactor = v),
                  activeColor: AppColors.primary,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Sesi Aktif ───────────────────────────────────
            _buildSection(
              title: 'Sesi Aktif',
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.smartphone,
                        color: AppColors.success, size: 18),
                  ),
                  title: const Text(
                    'Perangkat Ini',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  subtitle: const Text(
                    'Android • Aktif sekarang',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textGrey),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Aktif',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
    required List<Widget> children,
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
          child: Column(children: children),
        ),
      ],
    );
  }
}