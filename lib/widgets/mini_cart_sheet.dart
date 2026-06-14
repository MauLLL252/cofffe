import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme/app_theme.dart';
import '../data/mock_data.dart';
import '../models/coffee_item.dart';
import '../models/order_item.dart';

class MiniCartSheet extends StatefulWidget {
  final List<OrderItem> cart;
  final Function(CoffeeItem) onAdd;
  final Function(CoffeeItem) onRemove;
  final VoidCallback onLanjutKeranjang;

  const MiniCartSheet({
    super.key,
    required this.cart,
    required this.onAdd,
    required this.onRemove,
    required this.onLanjutKeranjang,
  });

  @override
  State<MiniCartSheet> createState() => _MiniCartSheetState();
}

class _MiniCartSheetState extends State<MiniCartSheet> {
  double get _subtotal =>
      widget.cart.fold(0, (s, i) => s + i.subtotal);
  double get _pajak => _subtotal * 0.1;
  double get _total => _subtotal + _pajak;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pesanan Saya',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: AppColors.textGrey),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // List item
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.35,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final item = widget.cart[index];
                return _buildCartItem(item);
              },
            ),
          ),

          const Divider(height: 1),

          // Subtotal, pajak, total
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              children: [
                _buildPriceRow('Subtotal', _subtotal),
                const SizedBox(height: 6),
                _buildPriceRow('Pajak (10%)', _pajak),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      MockData.formatPrice(_total),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tombol lanjut
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onLanjutKeranjang();
                },
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const Text('Lanjut ke Keranjang'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Gambar kecil
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.coffeeItem.imageUrl,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                width: 52,
                height: 52,
                color: AppColors.border,
                child: const Center(
                  child: Text('☕', style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Nama & qty control
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.coffeeItem.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {});
                        widget.onRemove(item.coffeeItem);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Qty control
                    Row(
                      children: [
                        _smallQtyBtn(
                          icon: Icons.remove,
                          onTap: () {
                            setState(() {});
                            widget.onRemove(item.coffeeItem);
                          },
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _smallQtyBtn(
                          icon: Icons.add,
                          onTap: () {
                            setState(() {});
                            widget.onAdd(item.coffeeItem);
                          },
                        ),
                      ],
                    ),
                    // Subtotal item
                    Text(
                      MockData.formatPrice(item.subtotal),
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
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
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
          MockData.formatPrice(amount),
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _smallQtyBtn({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: AppColors.textDark),
      ),
    );
  }
}