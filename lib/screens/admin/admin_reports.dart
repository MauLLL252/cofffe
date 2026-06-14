import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';

class AdminReports extends StatelessWidget {
  const AdminReports({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = MockData.sampleOrders;
    final totalRevenue = orders.fold(0.0, (sum, o) => sum + o.total);
    final totalOrders  = orders.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────
              const Text(
                'Laporan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Ringkasan performa hari ini',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                ),
              ),

              const SizedBox(height: 20),

              // ── Kartu Statistik ──────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.receipt_long,
                      label: 'Total Pesanan',
                      value: '$totalOrders',
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.payments_outlined,
                      label: 'Pendapatan',
                      value: MockData.formatPrice(totalRevenue),
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.coffee,
                      label: 'Menu Aktif',
                      value: '${MockData.menuItems.length}',
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.star_outline,
                      label: 'Rating Rata-rata',
                      value: '4.7 ⭐',
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Menu Terlaris ────────────────────────────────
              const Text(
                'Menu Terlaris',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 12),

              ..._getTopMenus().asMap().entries.map(
                    (entry) => _buildTopMenuRow(
                  rank: entry.key + 1,
                  name: entry.value['name'] as String,
                  sold: entry.value['sold'] as int,
                  revenue: entry.value['revenue'] as double,
                ),
              ),

              const SizedBox(height: 24),

              // ── Grafik Batang Sederhana ───────────────────────
              const Text(
                'Penjualan per Kategori',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 16),
              _buildBarChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopMenuRow({
    required int rank,
    required String name,
    required int sold,
    required double revenue,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Nomor urut
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rank == 1
                  ? AppColors.accent.withOpacity(0.2)
                  : AppColors.border,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: rank == 1
                      ? AppColors.accent
                      : AppColors.textGrey,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Nama
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),

          // Terjual
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$sold terjual',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),
              Text(
                MockData.formatPrice(revenue),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final data = [
      {'label': 'Espresso',     'value': 0.85},
      {'label': 'Manual Brew',  'value': 0.60},
      {'label': 'Non Coffee',   'value': 0.45},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: data.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['label'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      '${((item['value'] as double) * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item['value'] as double,
                    backgroundColor: AppColors.border,
                    color: AppColors.primary,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Map<String, dynamic>> _getTopMenus() {
    return [
      {'name': 'Cappuccino',  'sold': 48, 'revenue': 48 * 28000.0},
      {'name': 'Latte',       'sold': 36, 'revenue': 36 * 30000.0},
      {'name': 'V60',         'sold': 29, 'revenue': 29 * 35000.0},
      {'name': 'Americano',   'sold': 24, 'revenue': 24 * 22000.0},
      {'name': 'Matcha Latte','sold': 20, 'revenue': 20 * 32000.0},
    ];
  }
}