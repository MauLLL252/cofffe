import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/theme/app_theme.dart';
import '../data/mock_data.dart';
import '../models/coffee_item.dart';
import '../models/order_item.dart';

class ItemDetailSheet extends StatefulWidget {
  final CoffeeItem item;
  final int initialQty;
  final Function(CoffeeItem, int) onAddToCart;

  const ItemDetailSheet({
    super.key,
    required this.item,
    required this.initialQty,
    required this.onAddToCart,
  });

  @override
  State<ItemDetailSheet> createState() => _ItemDetailSheetState();
}

class _ItemDetailSheetState extends State<ItemDetailSheet> {
  late int _qty;

  @override
  void initState() {
    super.initState();
    _qty = widget.initialQty < 1 ? 1 : widget.initialQty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Gambar item ──────────────────────────────────
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
            child: CachedNetworkImage(
              imageUrl: widget.item.imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                height: 220,
                color: AppColors.border,
                child: const Center(
                  child: Text('☕', style: TextStyle(fontSize: 64)),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama & harga
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.item.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    Text(
                      MockData.formatPrice(widget.item.price),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  widget.item.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                  ),
                ),

                const SizedBox(height: 24),

                // ── Kontrol qty & total ──────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Kontrol qty
                    Row(
                      children: [
                        _qtyBtn(
                          icon: Icons.remove,
                          onTap: () {
                            if (_qty > 1) setState(() => _qty--);
                          },
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            '$_qty',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        _qtyBtn(
                          icon: Icons.add,
                          onTap: () => setState(() => _qty++),
                        ),
                      ],
                    ),

                    // Total harga
                    Text(
                      MockData.formatPrice(widget.item.price * _qty),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Tombol tambah ke pesanan ─────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onAddToCart(widget.item, _qty);
                      Navigator.pop(context);
                    },
                    child: const Text('Masukkan ke Pesanan'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}