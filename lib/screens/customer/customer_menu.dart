import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/coffee_item.dart';
import '../../models/order_item.dart';
import '../../widgets/item_detail_sheet.dart';
import '../../widgets/mini_cart_sheet.dart';
import 'cart_screen.dart';

class CustomerMenu extends StatefulWidget {
  const CustomerMenu({super.key});

  @override
  State<CustomerMenu> createState() => _CustomerMenuState();
}

class _CustomerMenuState extends State<CustomerMenu> {
  String _selectedCategory = 'Semua';
  final List<OrderItem> _cart = [];

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

  void _addToCart(CoffeeItem item, [int qty = 1]) {
    setState(() {
      final idx = _cart.indexWhere((e) => e.coffeeItem.id == item.id);
      if (idx >= 0) {
        _cart[idx].quantity += qty;
      } else {
        _cart.add(OrderItem(coffeeItem: item, quantity: qty));
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

  // Buka detail item
  void _showItemDetail(CoffeeItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ItemDetailSheet(
        item: item,
        initialQty: _getQty(item.id),
        onAddToCart: (item, qty) {
          // Reset dulu lalu set qty
          final idx = _cart.indexWhere((e) => e.coffeeItem.id == item.id);
          setState(() {
            if (idx >= 0) {
              _cart[idx].quantity = qty;
            } else {
              _cart.add(OrderItem(coffeeItem: item, quantity: qty));
            }
          });
        },
      ),
    );
  }

  // Buka mini cart
  void _showMiniCart() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MiniCartSheet(
        cart: _cart,
        onAdd: (item) {
          _addToCart(item);
          setState(() {});
        },
        onRemove: (item) {
          _removeFromCart(item);
          setState(() {});
        },
        onLanjutKeranjang: _goToCart,
      ),
    );
  }

  // Navigasi ke halaman keranjang
  void _goToCart() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CartScreen(
          cart: _cart,
          onAdd: _addToCart,
          onRemove: _removeFromCart,
          onOrderSuccess: () => setState(() => _cart.clear()),
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
            _buildHeader(),
            _buildCategories(),
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
      floatingActionButton:
      _totalItems > 0 ? _buildCartButton() : null,
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
    );
  }

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
                padding:
                const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.border,
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
    );
  }

  Widget _buildMenuRow(CoffeeItem item) {
    final qty = _getQty(item.id);

    return GestureDetector(
      onTap: () => _showItemDetail(item),
      child: Container(
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
                errorWidget: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: AppColors.border,
                  child: const Center(
                    child: Text('☕', style: TextStyle(fontSize: 32)),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

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
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        MockData.formatPrice(item.price),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      // Tombol tambah / qty
                      qty == 0
                          ? GestureDetector(
                        onTap: () => _showItemDetail(item),
                        child: Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius:
                            BorderRadius.circular(8),
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
                          _qtyBtn(
                            icon: Icons.remove,
                            onTap: () =>
                                _removeFromCart(item),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: Text(
                              '$qty',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _qtyBtn(
                            icon: Icons.add,
                            onTap: () =>
                                _addToCart(item),
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

  Widget _buildCartButton() {
    return GestureDetector(
      onTap: _showMiniCart,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 14),
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
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 2),
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
                'Lihat Pesanan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
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