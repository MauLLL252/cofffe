import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String selected;
  const PaymentMethodScreen({super.key, required this.selected});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  late String _selected;

  final List<_PayMethod> _methods = const [
    _PayMethod(
      id: 'QRIS / E-Wallet',
      icon: Icons.qr_code_2,
      title: 'QRIS / E-Wallet',
      subtitle: 'GoPay, OVO, Dana, ShopeePay',
      tags: ['GPY', 'OVO', 'DANA'],
    ),
    _PayMethod(
      id: 'Transfer Bank',
      icon: Icons.account_balance,
      title: 'Transfer Bank',
      subtitle: 'Virtual Account semua bank',
      tags: [],
    ),
    _PayMethod(
      id: 'Bayar di Kasir',
      icon: Icons.point_of_sale,
      title: 'Bayar di Kasir',
      subtitle: 'Tunai atau Kartu Debit/Kredit',
      tags: [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

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
          'Metode Pembayaran',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _selected),
            child: const Text(
              'Simpan',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih metode pembayaran default kamu',
              style: TextStyle(fontSize: 13, color: AppColors.textGrey),
            ),
            const SizedBox(height: 16),
            ..._methods.map((m) => _buildMethodCard(m)),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodCard(_PayMethod m) {
    final isSelected = _selected == m.id;
    return GestureDetector(
      onTap: () => setState(() => _selected = m.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.border.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(m.icon,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textGrey,
                  size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    m.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                  if (m.tags.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: m.tags.map((tag) => Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(tag,
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textGrey)),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _PayMethod {
  final String id, title, subtitle;
  final IconData icon;
  final List<String> tags;
  const _PayMethod({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tags,
  });
}