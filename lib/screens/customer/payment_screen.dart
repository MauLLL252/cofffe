import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/order_item.dart';
import 'order_status_screen.dart';

class PaymentScreen extends StatefulWidget {
  final List<OrderItem> cart;
  final double subtotal;
  final double pajak;
  final double total;
  final String note;
  final VoidCallback onOrderSuccess;

  const PaymentScreen({
    super.key,
    required this.cart,
    required this.subtotal,
    required this.pajak,
    required this.total,
    required this.note,
    required this.onOrderSuccess,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedMethod;
  bool _isLoading = false;

  // Daftar metode pembayaran
  final List<_PaymentMethod> _methods = [
    _PaymentMethod(
      id: 'qris',
      title: 'QRIS / E-Wallet',
      subtitle: 'Scan QR code menggunakan aplikasi GoPay, OVO, Dana, '
          'atau mobile banking lainnya.',
      icon: Icons.qr_code_2,
      tags: ['GPY', 'OVO', 'DNA'],
    ),
    _PaymentMethod(
      id: 'transfer',
      title: 'Transfer Bank (Virtual Account)',
      subtitle: '',
      icon: Icons.account_balance,
      tags: [],
    ),
    _PaymentMethod(
      id: 'kasir',
      title: 'Bayar di Kasir',
      subtitle: 'Tunai atau Kartu Debit/Kredit.',
      icon: Icons.point_of_sale,
      tags: [],
    ),
  ];

  // Generate nomor order
  String get _orderId {
    final now = DateTime.now();
    final rand = (900 + (now.millisecond % 100)).toString();
    return 'TK-${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}-$rand';
  }

  void _bayarSekarang() async {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pilih metode pembayaran dulu!'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi proses pembayaran
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    final orderId = _orderId;

    // Navigasi ke status pesanan
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OrderStatusScreen(
          orderId: orderId,
          total: widget.total,
          paymentMethod: _selectedMethod!,
          cart: widget.cart,
          onDone: widget.onOrderSuccess,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: AppColors.textDark,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kembali ke Keranjang',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textGrey,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Judul ──────────────────────────────────────
            const Text(
              'Pilih Metode\nPembayaran',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Pilih cara pembayaran yang paling nyaman untuk Anda.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textGrey,
              ),
            ),

            const SizedBox(height: 24),

            // ── Pilihan metode ──────────────────────────────
            ..._methods.map(
                  (method) => _buildMethodCard(method),
            ),

            const SizedBox(height: 24),

            // ── Ringkasan pesanan ───────────────────────────
            _buildOrderSummary(),

            const SizedBox(height: 24),

            // ── Tombol bayar ────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _bayarSekarang,
                icon: _isLoading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.arrow_forward, size: 18),
                label: Text(
                  _isLoading ? 'Memproses...' : 'Bayar Sekarang',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Disclaimer ──────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppColors.textGrey,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Dengan menekan tombol bayar, Anda menyetujui '
                        'syarat & ketentuan yang berlaku di Warkop Titik Kopi.',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textGrey,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── KARTU METODE PEMBAYARAN ──────────────────────────────────
  Widget _buildMethodCard(_PaymentMethod method) {
    final isSelected = _selectedMethod == method.id;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method.id),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon metode
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.border.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                method.icon,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textGrey,
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            // Judul + subtitle + tags
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.textDark
                          : AppColors.textDark,
                    ),
                  ),
                  if (method.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      method.subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                  if (method.tags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: method.tags.map((tag) {
                        return Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textGrey,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),

            // Radio button
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

  // ── RINGKASAN PESANAN ────────────────────────────────────────
  Widget _buildOrderSummary() {
    final now = DateTime.now();
    final orderId =
        'Order TK-${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}-938';

    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          const Text(
            'Ringkasan Pesanan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            '$orderId • Meja 06',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textGrey,
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),

          // List item
          ...widget.cart.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.coffeeItem.name}  x${item.quantity}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    MockData.formatPrice(item.subtotal),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1),
          ),

          // Subtotal
          _summaryRow('Subtotal', MockData.formatPrice(widget.subtotal)),
          const SizedBox(height: 6),
          _summaryRow('Pajak & Layanan', 'Termasuk'),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    'Tagihan',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
              Text(
                MockData.formatPrice(widget.total),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textGrey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}

// Model metode pembayaran
class _PaymentMethod {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> tags;

  const _PaymentMethod({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tags,
  });
}