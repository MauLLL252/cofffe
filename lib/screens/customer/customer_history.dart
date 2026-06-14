import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/order_item.dart';
import 'order_status_screen.dart';



class CustomerHistory extends StatelessWidget {
  const CustomerHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = MockData.sampleOrders;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                'Riwayat Pesanan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),

            const SizedBox(height: 4),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${orders.length} pesanan',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── List Riwayat ─────────────────────────────────
            Expanded(
              child: orders.isEmpty
                  ? _buildEmpty()
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: orders.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _buildOrderCard(context, orders[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── EMPTY STATE ─────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('☕', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Pesanan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yuk pesan kopi favoritmu sekarang!',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  // ── CARD ORDER ──────────────────────────────────────────────
  Widget _buildOrderCard(BuildContext context, Order order) {
    final statusColor = _getStatusColor(order.status);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Baris atas: ID + badge status ─────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  MockData.getStatusLabel(order.status),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Tanggal
          Text(
            _formatDate(order.createdAt),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textGrey,
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),

          // ── Daftar item ───────────────────────────────────
          ...order.items.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.coffeeItem.name,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        ' x${item.quantity}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    MockData.formatPrice(item.subtotal),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),

          // ── Total ─────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.totalItems} item',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Total: ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textGrey,
                    ),
                  ),
                  Text(
                    MockData.formatPrice(order.total),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ── Tombol pesan lagi ─────────────────────────────
          // Ganti bagian if (order.status == 'done') di bawah card
          if (order.status == 'done') ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text(
                  'Pesan Lagi',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ] else if (order.status == 'pending' ||
              order.status == 'process') ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrderStatusScreen(
                        orderId: order.id,
                        total: order.total,
                        paymentMethod: 'kasir',
                        cart: order.items,
                        onDone: () {},
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.track_changes, size: 16),
                label: const Text(
                  'Pantau Pesanan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':   return AppColors.warning;
      case 'process':   return Colors.blue;
      case 'done':      return AppColors.success;
      case 'cancelled': return AppColors.error;
      default:          return AppColors.textGrey;
    }
  }

  String _formatDate(DateTime date) {
    final now   = DateTime.now();
    final diff  = now.difference(date);

    if (diff.inMinutes < 60) return '${diff.inMinutes} menit yang lalu';
    if (diff.inHours < 24)   return '${diff.inHours} jam yang lalu';
    if (diff.inDays == 1)    return 'Kemarin';
    return '${diff.inDays} hari yang lalu';
  }
}