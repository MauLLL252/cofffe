import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../models/coffee_item.dart';
import '../../models/order_item.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  final List<OrderItem> cart;
  final Function(CoffeeItem, [int]) onAdd;
  final Function(CoffeeItem) onRemove;
  final VoidCallback onOrderSuccess;

  const CartScreen({
    super.key,
    required this.cart,
    required this.onAdd,
    required this.onRemove,
    required this.onOrderSuccess,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _noteController = TextEditingController();
  bool _showNoteField   = false;

  double get _subtotal =>
      widget.cart.fold(0, (s, i) => s + i.subtotal);
  double get _pajak   => _subtotal * 0.1;
  double get _total   => _subtotal + _pajak;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _goToPayment() {
    if (widget.cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Keranjang masih kosong!'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          cart: widget.cart,
          subtotal: _subtotal,
          pajak: _pajak,
          total: _total,
          note: _noteController.text.trim(),
          onOrderSuccess: () {
            widget.onOrderSuccess();
            // Pop sampai ke CustomerShell
            Navigator.of(context)
                .popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          'Titik Kopi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: AppColors.textDark,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Konten scrollable ──────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Text(
                      'Keranjang Pesanan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),

                  // ── List item cart ───────────────────────────
                  if (widget.cart.isEmpty)
                    _buildEmpty()
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20),
                      itemCount: widget.cart.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _buildCartItem(widget.cart[index]),
                    ),

                  const SizedBox(height: 16),

                  // ── Tombol tambah catatan ───────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => setState(
                                () => _showNoteField = !_showNoteField,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit_note,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _showNoteField
                                    ? 'Sembunyikan Catatan'
                                    : 'Tambah Catatan Pesanan',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Field catatan (animasi muncul)
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: TextField(
                              controller: _noteController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText:
                                'Contoh: Tanpa gula, es batu sedikit...',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.border,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          crossFadeState: _showNoteField
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration:
                          const Duration(milliseconds: 200),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom bar total + tombol bayar ─────────────────────
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ── EMPTY STATE ─────────────────────────────────────────────
  Widget _buildEmpty() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            Text('🛒', style: TextStyle(fontSize: 56)),
            SizedBox(height: 12),
            Text(
              'Keranjang Kosong',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Tambahkan menu dulu yuk!',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── ITEM CART ────────────────────────────────────────────────
  Widget _buildCartItem(OrderItem item) {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          // Gambar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: item.coffeeItem.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                width: 60,
                height: 60,
                color: AppColors.border,
                child: const Center(
                  child: Text('☕', style: TextStyle(fontSize: 24)),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Info + kontrol
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
                const SizedBox(height: 4),
                Text(
                  MockData.formatPrice(item.coffeeItem.price),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                  ),
                ),
                const SizedBox(height: 8),

                // Qty control
                Row(
                  children: [
                    _qtyBtn(
                      icon: Icons.remove,
                      onTap: () {
                        widget.onRemove(item.coffeeItem);
                        setState(() {});
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _qtyBtn(
                      icon: Icons.add,
                      onTap: () {
                        widget.onAdd(item.coffeeItem);
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Subtotal
          Text(
            MockData.formatPrice(item.subtotal),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
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
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: AppColors.textDark),
      ),
    );
  }

  // ── BOTTOM BAR ───────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Total pembayaran
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL PEMBAYARAN',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textGrey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    MockData.formatPrice(_total),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Tombol pilih pembayaran
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _goToPayment,
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text('Pilih Pembayaran'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}