import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/order_item.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({super.key});

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  late List<Order> _orders;
  String _filterStatus = 'Semua';

  final List<String> _statusFilters = [
    'Semua', 'pending', 'process', 'done', 'cancelled'
  ];

  @override
  void initState() {
    super.initState();
    // Tambahkan order dengan status berbeda untuk demo
    _orders = [
      Order(
        id: 'ORD-004',
        customerName: 'Andi Wijaya',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        status: 'pending',
        items: [
          OrderItem(coffeeItem: MockData.menuItems[0], quantity: 2),
        ],
      ),
      Order(
        id: 'ORD-005',
        customerName: 'Siti Rahayu',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        status: 'process',
        items: [
          OrderItem(coffeeItem: MockData.menuItems[2], quantity: 1),
          OrderItem(coffeeItem: MockData.menuItems[8], quantity: 1),
        ],
      ),
      ...MockData.sampleOrders,
    ];
  }

  List<Order> get _filteredOrders {
    if (_filterStatus == 'Semua') return _orders;
    return _orders
        .where((o) => o.status == _filterStatus)
        .toList();
  }

  void _updateStatus(Order order, String newStatus) {
    setState(() {
      final idx = _orders.indexOf(order);
      _orders[idx] = Order(
        id: order.id,
        customerName: order.customerName,
        createdAt: order.createdAt,
        status: newStatus,
        items: order.items,
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✅ ${order.id} → ${MockData.getStatusLabel(newStatus)}',
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kelola Pesanan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_orders.where((o) => o.status == 'pending').length} baru',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Filter status ────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _statusFilters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final status   = _statusFilters[index];
                    final isActive = status == _filterStatus;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _filterStatus = status),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isActive
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            status == 'Semua'
                                ? 'Semua'
                                : MockData.getStatusLabel(status),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isActive
                                  ? Colors.white
                                  : AppColors.textGrey,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── List Order ───────────────────────────────────
            Expanded(
              child: _filteredOrders.isEmpty
                  ? const Center(
                child: Text(
                  'Tidak ada pesanan',
                  style: TextStyle(color: AppColors.textGrey),
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filteredOrders.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _buildOrderCard(_filteredOrders[index]),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
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
          // ID + Badge status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.id,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    order.customerName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
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

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),

          // Item list
          ...order.items.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item.coffeeItem.name} x${item.quantity}',
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
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),

          // Total + tombol aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${MockData.formatPrice(order.total)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              // Tombol aksi sesuai status
              _buildActionButton(order),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(Order order) {
    if (order.status == 'pending') {
      return ElevatedButton(
        onPressed: () => _updateStatus(order, 'process'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          textStyle: const TextStyle(fontSize: 12),
        ),
        child: const Text('Proses'),
      );
    }
    if (order.status == 'process') {
      return ElevatedButton(
        onPressed: () => _updateStatus(order, 'done'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          textStyle: const TextStyle(fontSize: 12),
        ),
        child: const Text('Selesai'),
      );
    }
    return const SizedBox.shrink();
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
}