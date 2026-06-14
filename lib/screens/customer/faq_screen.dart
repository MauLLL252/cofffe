import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final List<_FaqItem> _faqs = const [
    _FaqItem(
      question: 'Bagaimana cara memesan kopi?',
      answer: 'Buka menu, pilih kopi yang kamu inginkan, '
          'tap "+ Tambah", lalu lanjut ke keranjang dan '
          'pilih metode pembayaran.',
    ),
    _FaqItem(
      question: 'Berapa lama estimasi pesanan siap?',
      answer: 'Estimasi waktu adalah 10–15 menit tergantung '
          'tingkat kesibukan barista. Kamu bisa pantau '
          'status pesanan di menu Riwayat.',
    ),
    _FaqItem(
      question: 'Apakah bisa bayar di kasir?',
      answer: 'Ya, kamu bisa memilih metode "Bayar di Kasir" '
          'saat checkout. Pesanan akan tetap diproses '
          'dan kamu bisa bayar langsung ke kasir.',
    ),
    _FaqItem(
      question: 'Bagaimana cara mendapatkan poin reward?',
      answer: 'Setiap pembelian akan memberikan poin. '
          '1 poin = Rp 1.000 pembelian. '
          'Kumpulkan poin untuk ditukar dengan diskon.',
    ),
    _FaqItem(
      question: 'Apakah bisa mengubah pesanan setelah dipesan?',
      answer: 'Pesanan tidak bisa diubah setelah status '
          '"Sedang Disiapkan". Segera hubungi barista '
          'di kasir jika ada perubahan.',
    ),
    _FaqItem(
      question: 'Bagaimana cara menghubungi customer service?',
      answer: 'Kamu bisa menghubungi kami melalui tombol '
          '"Butuh Bantuan?" di halaman status pesanan, '
          'atau langsung ke kasir.',
    ),
    _FaqItem(
      question: 'Apakah ada promo untuk member?',
      answer: 'Ya! Member Gold mendapatkan diskon 10% setiap '
          'hari Rabu. Member Platinum mendapat gratis 1 kopi '
          'setiap 10 pembelian.',
    ),
  ];

  int? _expandedIndex;

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
      appBar: _buildAppBar('Bantuan & FAQ'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Banner bantuan ───────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
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
                  const Text('☕', style: TextStyle(fontSize: 36)),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ada yang bisa kami bantu?',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Temukan jawaban di bawah ini atau\nhubungi barista kami.',
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

            const Text(
              'Pertanyaan Umum',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 12),

            // ── FAQ Accordion ────────────────────────────────
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

            // ── Tombol hubungi kami ──────────────────────────
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
                    'Masih butuh bantuan?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tim kami siap membantu kamu',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.headset_mic_outlined,
                          size: 18),
                      label: const Text('Hubungi Customer Service'),
                      style: ElevatedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
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
}

class _FaqItem {
  final String question, answer;
  const _FaqItem({required this.question, required this.answer});
}