import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/coffee_item.dart';
import '../../models/order_item.dart';

class CustomerMenu extends StatefulWidget {
  const CustomerMenu({super.key});

  @override
  State<CustomerMenu> createState() => _CustomerMenuState();
}

class _CustomerMenuState extends State<CustomerMenu> {
  String _selectedCategory = 'Semua';
  final List<OrderItem> _cart = [];

  // ── Helper cart ─────────────────────────────────────────────
  List<CoffeeItem> get _filteredItems {
    if (_selectedCategory == 'Semua') return MockData.menuItems;
    return MockData.menuItems
        .where((item) => item.category == _selectedCategory)
        .toList();
  }

  double get _totalPrice =>
      _cart.fold(0, (sum, item) => sum + item.subtotal);

  int get _totalItems =>
      _cart.fold(0, (sum, item) => sum + item.quantity);

  int _getQty(String id) {
    try {
      return _cart.firstWhere((e) => e.coffeeItem.id == id).quantity;
    } catch (_) {
      return 0;
    }
  }

  void _addToCart(CoffeeItem item) {
    setState(() {
      final idx = _cart.indexWhere((e) => e.coffeeItem.id == item.id);
      if (idx >= 0) {
        _cart[idx].quantity++;
      } else {
        _cart.add(OrderItem(coffeeItem: item));
      }
    });
  }

  void _removeFromCart(CoffeeItem item) {
    setState(() {
      final idx = _cart.indexWhere((e) => e.coffeeItem.id == item.id);
      if (idx >= 0) {
        if (_cart[idx].quantity > 1) {
          _cart[idx].quantity--;
        } else {
          _cart.removeAt(idx);
        }
      }
    });
  }

  // ── Bottom sheet keranjang ───────────────────────────────────
  void _showCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CartSheet(
        cart: _cart,
        totalPrice: _totalPrice,
        onAdd: _addToCart,
        onRemove: _removeFromCart,
        onCheckout: _handleCheckout,
      ),
    );
  }

  void _handleCheckout() {
    Navigator.pop(context);
    setState(() => _cart.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✅ Pesanan berhasil dikirim!'),
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
            // ── Header ────────────────────────────────────────
            _buildHeader(),

            // ── Kategori ─────────────────────────────────────
            _buildCategories(),

            // ── List Menu ─────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                itemCount: _filteredItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _buildMenuRow(_filteredItems[index]),
              ),
            ),
          ],
        ),
      ),

      // ── Tombol keranjang floating ──────────────────────────
      floatingActionButton: _totalItems > 0
          ? _buildCartButton()
          : null,
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
    );
  }

  // ── HEADER ──────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Menu Kami',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Text(
            '${MockData.menuItems.length} item',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  // ── KATEGORI ────────────────────────────────────────────────
  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: MockData.categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final cat      = MockData.categories[index];
            final isActive = cat == _selectedCategory;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Center(
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color:
                      isActive ? Colors.white : AppColors.textGrey,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── ROW MENU ────────────────────────────────────────────────
  Widget _buildMenuRow(CoffeeItem item) {
    final qty = _getQty(item.id);

    return Container(
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          // Gambar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: AppColors.border,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.border,
                child: const Center(
                  child: Text('☕', style: TextStyle(fontSize: 32)),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      MockData.formatPrice(item.price),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    // Kontrol qty
                    qty == 0
                        ? GestureDetector(
                      onTap: () => _addToCart(item),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '+ Tambah',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                        : Row(
                      children: [
                        _qtyButton(
                          icon: Icons.remove,
                          onTap: () => _removeFromCart(item),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10),
                          child: Text(
                            '$qty',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        _qtyButton(
                          icon: Icons.add,
                          onTap: () => _addToCart(item),
                        ),
                      ],
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

  Widget _qtyButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }

  // ── TOMBOL CART FLOATING ─────────────────────────────────────
  Widget _buildCartButton() {
    return GestureDetector(
      onTap: _showCart,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Badge jumlah item
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$_totalItems item',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Lihat Keranjang',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Total harga
            Text(
              MockData.formatPrice(_totalPrice),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// CART BOTTOM SHEET
// ════════════════════════════════════════════════════════════════
class _CartSheet extends StatelessWidget {
  final List<OrderItem> cart;
  final double totalPrice;
  final Function(CoffeeItem) onAdd;
  final Function(CoffeeItem) onRemove;
  final VoidCallback onCheckout;

  const _CartSheet({
    required this.cart,
    required this.totalPrice,
    required this.onAdd,
    required this.onRemove,
    required this.onCheckout,
  });

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

          // Judul
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Text(
                  'Keranjang',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // List item cart
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              itemCount: cart.length,
              separatorBuilder: (_, __) => const Divider(height: 20),
              itemBuilder: (context, index) {
                final item = cart[index];
                return Row(
                  children: [
                    // Nama & harga satuan
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.coffeeItem.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            MockData.formatPrice(item.coffeeItem.price),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Kontrol qty
                    Row(
                      children: [
                        _cartQtyBtn(
                          icon: Icons.remove,
                          onTap: () => onRemove(item.coffeeItem),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _cartQtyBtn(
                          icon: Icons.add,
                          onTap: () => onAdd(item.coffeeItem),
                        ),
                      ],
                    ),

                    const SizedBox(width: 12),

                    // Subtotal
                    SizedBox(
                      width: 80,
                      child: Text(
                        MockData.formatPrice(item.subtotal),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const Divider(height: 1),

          // Total & tombol pesan
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      MockData.formatPrice(totalPrice),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onCheckout,
                    child: const Text('Pesan & Bayar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartQtyBtn({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}