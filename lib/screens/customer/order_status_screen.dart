import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/order_item.dart';

class OrderStatusScreen extends StatefulWidget {
  final String orderId;
  final double total;
  final String paymentMethod;
  final List<OrderItem> cart;
  final VoidCallback onDone;

  const OrderStatusScreen({
    super.key,
    required this.orderId,
    required this.total,
    required this.paymentMethod,
    required this.cart,
    required this.onDone,
  });

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  int _currentStep = 0;
  final List<String?> _stepTimes = [null, null, null];

  final List<_StatusStep> _steps = const [
    _StatusStep(
      icon: Icons.coffee,
      title: 'Pesanan Diterima',
      subtitle: 'Barista kami telah menerima pesanan Anda.',
    ),
    _StatusStep(
      icon: Icons.blender,
      title: 'Sedang Disiapkan',
      subtitle: 'Pesanan sedang diracik dengan sepenuh hati.',
    ),
    _StatusStep(
      icon: Icons.room_service,
      title: 'Pesanan Siap Diantarkan',
      subtitle: 'Pesanan Anda sedang diantarkan.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _stepTimes[0] = _formatTime(DateTime.now());

    // Simulasi update status otomatis
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _currentStep = 1;
          _stepTimes[1] = _formatTime(DateTime.now());
        });
      }
    });

    Future.delayed(const Duration(seconds: 12), () {
      if (mounted) {
        setState(() {
          _currentStep = 2;
          _stepTimes[2] = _formatTime(DateTime.now());
        });
      }
    });
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m ${dt.hour < 12 ? 'AM' : 'PM'}';
  }

  String get _paymentLabel {
    switch (widget.paymentMethod) {
      case 'qris':     return 'QRIS / E-Wallet';
      case 'transfer': return 'Transfer Bank';
      case 'kasir':    return 'Bayar di Kasir';
      default:         return widget.paymentMethod;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            SizedBox(width: 8),
            Text(
              'Titik Kopi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Judul ──────────────────────────────────────
            const Text(
              'Status Pesanan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pantau pesanan Anda di sini.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textGrey,
              ),
            ),

            const SizedBox(height: 20),

            // ── Kartu Info Order ────────────────────────────
            _buildOrderInfoCard(),

            const SizedBox(height: 16),

            // ── Tombol Bantuan ──────────────────────────────
            _buildHelpButton(),

            const SizedBox(height: 24),

            // ── Timeline Status ─────────────────────────────
            _buildTimeline(),

            const SizedBox(height: 32),

            // ── Tombol Selesai (muncul di step terakhir) ────
            if (_currentStep == 2) _buildDoneButton(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── KARTU INFO ORDER ────────────────────────────────────────
  Widget _buildOrderInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          // No pesanan + lokasi meja
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'No. Pesanan',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.orderId,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),

            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),

          // Estimasi waktu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estimasi Waktu',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                ),
              ),
              Text(
                _currentStep == 2 ? 'Siap!' : '10 – 15 Menit',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _currentStep == 2
                      ? AppColors.success
                      : AppColors.textDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Total pembayaran
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                ),
              ),
              Text(
                MockData.formatPrice(widget.total),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Metode pembayaran
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Metode Bayar',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                ),
              ),
              Text(
                _paymentLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── TOMBOL BANTUAN ──────────────────────────────────────────
  Widget _buildHelpButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Butuh Bantuan?'),
              content: const Text(
                'Silakan hubungi barista kami di kasir atau '
                    'tekan tombol panggil pelayan.',
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(
          Icons.help_outline,
          size: 16,
          color: AppColors.textDark,
        ),
        label: const Text(
          'Butuh Bantuan?',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textDark,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ── TIMELINE STATUS ─────────────────────────────────────────
  Widget _buildTimeline() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Perjalanan Pesanan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 20),

          // Steps
          ...List.generate(_steps.length, (index) {
            final isDone    = index <= _currentStep;
            final isActive  = index == _currentStep;
            final isLast    = index == _steps.length - 1;
            final step      = _steps[index];
            final time      = _stepTimes[index];

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kolom kiri: icon + garis
                Column(
                  children: [
                    // Icon bulat
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppColors.primaryDark
                            : AppColors.border,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        step.icon,
                        size: 18,
                        color: isDone
                            ? Colors.white
                            : AppColors.textGrey,
                      ),
                    ),

                    // Garis vertikal (kecuali step terakhir)
                    if (!isLast)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: 2,
                        height: 52,
                        color: index < _currentStep
                            ? AppColors.primaryDark
                            : AppColors.border,
                      ),
                  ],
                ),

                const SizedBox(width: 16),

                // Kolom kanan: teks
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: isLast ? 0 : 32,
                      top: 8,
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isDone
                                      ? AppColors.textDark
                                      : AppColors.textGrey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                step.subtitle,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDone
                                      ? AppColors.textGrey
                                      : AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Waktu step
                        Text(
                          time ?? '--:--',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDone
                                ? AppColors.textDark
                                : AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ── TOMBOL SELESAI ───────────────────────────────────────────
  Widget _buildDoneButton() {
    return Column(
      children: [
        // Pesan sukses
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.success.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Pesanan Anda sudah siap!\nSelamat menikmati kopi Anda',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              widget.onDone();
              Navigator.of(context)
                  .popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Kembali ke Beranda'),
          ),
        ),
      ],
    );
  }
}

// Model step status
class _StatusStep {
  final IconData icon;
  final String title;
  final String subtitle;

  const _StatusStep({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}