import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AdminHelpScreen extends StatefulWidget {
  const AdminHelpScreen({super.key});

  @override
  State<AdminHelpScreen> createState() => _AdminHelpScreenState();
}

class _AdminHelpScreenState extends State<AdminHelpScreen> {
  int? _expandedIndex;

  final List<_FaqItem> _faqs = const [
    _FaqItem(
      question: 'Bagaimana cara menambah menu baru?',
      answer: 'Buka tab "Menu" di navbar bawah, lalu tap tombol '
          '"+ Tambah" di pojok kanan atas. Isi nama, harga, '
          'kategori, dan deskripsi menu.',
    ),
    _FaqItem(
      question: 'Bagaimana cara memproses pesanan masuk?',
      answer: 'Buka tab "Pesanan", temukan pesanan dengan status '
          '"Menunggu", lalu tap tombol "Proses". Setelah selesai '
          'dibuat, tap "Selesai" untuk mengkonfirmasi.',
    ),
    _FaqItem(
      question: 'Cara melihat laporan penjualan?',
      answer: 'Buka tab "Laporan" di navbar bawah. '
          'Di sana tersedia ringkasan pendapatan, '
          'menu terlaris, dan grafik penjualan per kategori.',
    ),
    _FaqItem(
      question: 'Bagaimana cara menutup/membuka toko sementara?',
      answer: 'Buka Profil → Pengaturan Toko → toggle "Toko Buka" '
          'untuk mengaktifkan atau menonaktifkan penerimaan pesanan.',
    ),
    _FaqItem(
      question: 'Cara mengelola akun customer?',
      answer: 'Buka Profil → Kelola Pengguna → pilih tab Customer. '
          'Tap nama customer untuk melihat detail dan '
          'menonaktifkan akun jika diperlukan.',
    ),
    _FaqItem(
      question: 'Bagaimana cara mengubah pajak?',
      answer: 'Buka Profil → Pengaturan Toko → scroll ke bagian '
          '"Keuangan" → ubah nilai pajak (%) sesuai kebutuhan.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              size: 18, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bantuan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Banner ──────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Text('🛠️', style: TextStyle(fontSize: 36)),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pusat Bantuan Admin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Panduan penggunaan aplikasi\nuntuk admin Titik Kopi.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Panduan Cepat ────────────────────────────────
            const Text(
              'Panduan Cepat',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 12),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _buildGuideCard(
                  icon: Icons.restaurant_menu,
                  title: 'Kelola Menu',
                  color: AppColors.primary,
                  onTap: () {},
                ),
                _buildGuideCard(
                  icon: Icons.shopping_bag,
                  title: 'Proses Pesanan',
                  color: AppColors.success,
                  onTap: () {},
                ),
                _buildGuideCard(
                  icon: Icons.bar_chart,
                  title: 'Laporan',
                  color: AppColors.accent,
                  onTap: () {},
                ),
                _buildGuideCard(
                  icon: Icons.people,
                  title: 'Kelola User',
                  color: AppColors.warning,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── FAQ ──────────────────────────────────────────
            const Text(
              'Pertanyaan Umum',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 12),

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
                children: List.generate(_faqs.length, (index) {
                  final faq        = _faqs[index];
                  final isExpanded = _expandedIndex == index;
                  final isLast     = index == _faqs.length - 1;

                  return Column(
                    children: [
                      InkWell(
                        onTap: () => setState(() {
                          _expandedIndex =
                          isExpanded ? null : index;
                        }),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                margin: const EdgeInsets.only(
                                    right: 12, top: 2),
                                decoration: BoxDecoration(
                                  color: isExpanded
                                      ? AppColors.primary
                                      : AppColors.primary
                                      .withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    'Q',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isExpanded
                                          ? Colors.white
                                          : AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      faq.question,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isExpanded
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    AnimatedCrossFade(
                                      firstChild:
                                      const SizedBox.shrink(),
                                      secondChild: Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            top: 8),
                                        child: Text(
                                          faq.answer,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textGrey,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                      crossFadeState: isExpanded
                                          ? CrossFadeState.showSecond
                                          : CrossFadeState.showFirst,
                                      duration: const Duration(
                                          milliseconds: 200),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppColors.textGrey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!isLast)
                        const Divider(
                            height: 1, indent: 16, endIndent: 16),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // ── Kontak Support ───────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
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
                children: [
                  const Text(
                    'Butuh Bantuan Lebih Lanjut?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Hubungi tim support Titik Kopi',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.email_outlined,
                              size: 16),
                          label: const Text('Email'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(
                                color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.headset_mic_outlined,
                              size: 16),
                          label: const Text('Live Chat'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem {
  final String question, answer;
  const _FaqItem({required this.question, required this.answer});
}