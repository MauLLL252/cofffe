import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class StoreSettingsScreen extends StatefulWidget {
  const StoreSettingsScreen({super.key});

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  final _nameCtrl    = TextEditingController(text: 'Warkop Titik Kopi');
  final _addressCtrl = TextEditingController(
      text: 'Jl. Jend. Sudirman No. 12, Jakarta Pusat');
  final _phoneCtrl   = TextEditingController(text: '+62 21 5555 1234');
  final _emailCtrl   = TextEditingController(text: 'admin@titikkopi.com');
  final _taxCtrl     = TextEditingController(text: '10');
  final _descCtrl    = TextEditingController(
      text: 'Warkop dengan suasana nyaman dan kopi terbaik.');

  bool _isOpen          = true;
  bool _acceptOnline    = true;
  bool _autoConfirm     = false;
  String _openTime      = '07:00';
  String _closeTime     = '22:00';
  bool _isSaving        = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _taxCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _save() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✅ Pengaturan toko berhasil disimpan'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> _pickTime(bool isOpen) async {
    final initial = TimeOfDay(
      hour: int.parse(isOpen
          ? _openTime.split(':')[0]
          : _closeTime.split(':')[0]),
      minute: int.parse(isOpen
          ? _openTime.split(':')[1]
          : _closeTime.split(':')[1]),
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      final formatted =
          '${picked.hour.toString().padLeft(2, '0')}:'
          '${picked.minute.toString().padLeft(2, '0')}';
      setState(() {
        if (isOpen) {
          _openTime = formatted;
        } else {
          _closeTime = formatted;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _appBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Logo Toko ──────────────────────────────────
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Text('☕', style: TextStyle(fontSize: 40)),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border:
                          Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Ubah Logo Toko',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Status Toko ────────────────────────────────
            _buildSection(
              title: 'Status Toko',
              children: [
                _buildSwitch(
                  icon: Icons.store,
                  label: 'Toko Buka',
                  subtitle: _isOpen
                      ? 'Pelanggan bisa memesan sekarang'
                      : 'Toko sedang tutup',
                  value: _isOpen,
                  onChanged: (v) => setState(() => _isOpen = v),
                  activeColor: AppColors.success,
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _buildSwitch(
                  icon: Icons.wifi,
                  label: 'Terima Pesanan Online',
                  subtitle: 'Aktifkan pemesanan via aplikasi',
                  value: _acceptOnline,
                  onChanged: (v) =>
                      setState(() => _acceptOnline = v),
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _buildSwitch(
                  icon: Icons.check_circle_outline,
                  label: 'Konfirmasi Otomatis',
                  subtitle: 'Pesanan langsung diproses tanpa konfirmasi',
                  value: _autoConfirm,
                  onChanged: (v) =>
                      setState(() => _autoConfirm = v),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Jam Operasional ────────────────────────────
            _buildSection(
              title: 'Jam Operasional',
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Jam Buka',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textGrey,
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () => _pickTime(true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  border: Border.all(
                                      color: AppColors.border),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        size: 16,
                                        color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      _openTime,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '–',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Jam Tutup',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textGrey,
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () => _pickTime(false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  border: Border.all(
                                      color: AppColors.border),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        size: 16,
                                        color: AppColors.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      _closeTime,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Info Toko ──────────────────────────────────
            _buildSection(
              title: 'Informasi Toko',
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildField(
                        label: 'Nama Toko',
                        ctrl: _nameCtrl,
                        icon: Icons.store_outlined,
                      ),
                      const SizedBox(height: 14),
                      _buildField(
                        label: 'Alamat',
                        ctrl: _addressCtrl,
                        icon: Icons.location_on_outlined,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 14),
                      _buildField(
                        label: 'No. Telepon',
                        ctrl: _phoneCtrl,
                        icon: Icons.phone_outlined,
                        keyboard: TextInputType.phone,
                      ),
                      const SizedBox(height: 14),
                      _buildField(
                        label: 'Email',
                        ctrl: _emailCtrl,
                        icon: Icons.email_outlined,
                        keyboard: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),
                      _buildField(
                        label: 'Deskripsi Toko',
                        ctrl: _descCtrl,
                        icon: Icons.description_outlined,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Keuangan ───────────────────────────────────
            _buildSection(
              title: 'Keuangan',
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pajak (%)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _taxCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Contoh: 10',
                          prefixIcon: Icon(Icons.percent,
                              size: 18, color: AppColors.textGrey),
                          suffixText: '%',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pajak akan otomatis ditambahkan ke total pesanan',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSaving
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text('Simpan Pengaturan'),
              ),
            ),

            const SizedBox(height: 24),
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

  Widget _buildSwitch({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color activeColor = AppColors.primary,
  }) {
    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 18),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textDark,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.textGrey,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController ctrl,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
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
          keyboardType: keyboard,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: maxLines == 1
                ? Icon(icon, size: 18, color: AppColors.textGrey)
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
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
        'Pengaturan Toko',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: _isSaving ? null : _save,
          child: Text(
            'Simpan',
            style: TextStyle(
              color: _isSaving ? AppColors.textGrey : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}