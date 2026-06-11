import '../models/coffee_item.dart';
import '../models/order_item.dart';

class MockData {
  // ── DAFTAR MENU KOPI ──────────────────────────────────────────
  static const List<CoffeeItem> menuItems = [
    // Espresso Based
    CoffeeItem(
      id: 'c1',
      name: 'Espresso',
      description: 'Shot espresso murni, bold dan intens',
      price: 18000,
      category: 'Espresso',
      imageUrl: 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=400',
      rating: 4.7,
    ),
    CoffeeItem(
      id: 'c2',
      name: 'Americano',
      description: 'Espresso dengan air panas, rasa bersih',
      price: 22000,
      category: 'Espresso',
      imageUrl: 'https://images.unsplash.com/photo-1551030173-122aabc4489c?w=400',
      rating: 4.5,
    ),
    CoffeeItem(
      id: 'c3',
      name: 'Cappuccino',
      description: 'Espresso, susu steam, dan foam susu tebal',
      price: 28000,
      category: 'Espresso',
      imageUrl: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400',
      rating: 4.8,
    ),
    CoffeeItem(
      id: 'c4',
      name: 'Latte',
      description: 'Espresso lembut dengan susu steam creamy',
      price: 30000,
      category: 'Espresso',
      imageUrl: 'https://images.unsplash.com/photo-1561882468-9110e03e0f78?w=400',
      rating: 4.6,
    ),
    CoffeeItem(
      id: 'c5',
      name: 'Flat White',
      description: 'Double shot dengan microfoam susu tipis',
      price: 32000,
      category: 'Espresso',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      rating: 4.7,
    ),

    // Manual Brew
    CoffeeItem(
      id: 'c6',
      name: 'V60',
      description: 'Pour over dengan filter kertas, clean & bright',
      price: 35000,
      category: 'Manual Brew',
      imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400',
      rating: 4.9,
    ),
    CoffeeItem(
      id: 'c7',
      name: 'Chemex',
      description: 'Seduhan lambat dengan clarity rasa tinggi',
      price: 38000,
      category: 'Manual Brew',
      imageUrl: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400',
      rating: 4.8,
    ),
    CoffeeItem(
      id: 'c8',
      name: 'Aeropress',
      description: 'Tekanan udara menghasilkan rasa bold & smooth',
      price: 32000,
      category: 'Manual Brew',
      imageUrl: 'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=400',
      rating: 4.6,
    ),

    // Non Coffee
    CoffeeItem(
      id: 'c9',
      name: 'Matcha Latte',
      description: 'Matcha Jepang premium dengan susu segar',
      price: 32000,
      category: 'Non Coffee',
      imageUrl: 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=400',
      rating: 4.7,
    ),
    CoffeeItem(
      id: 'c10',
      name: 'Chocolate',
      description: 'Dark chocolate rich dengan susu full cream',
      price: 28000,
      category: 'Non Coffee',
      imageUrl: 'https://images.unsplash.com/photo-1542990253-0d0f5be5f0ed?w=400',
      rating: 4.5,
    ),
    CoffeeItem(
      id: 'c11',
      name: 'Teh Tarik',
      description: 'Teh hitam dengan susu kental manis khas',
      price: 20000,
      category: 'Non Coffee',
      imageUrl: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
      rating: 4.4,
    ),
  ];

  // ── KATEGORI ──────────────────────────────────────────────────
  static const List<String> categories = [
    'Semua',
    'Espresso',
    'Manual Brew',
    'Non Coffee',
  ];

  // ── RIWAYAT ORDER DUMMY ───────────────────────────────────────
  static List<Order> get sampleOrders => [
    Order(
      id: 'ORD-001',
      customerName: 'Budi Santoso',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      status: 'done',
      items: [
        OrderItem(coffeeItem: menuItems[2], quantity: 2), // Cappuccino x2
        OrderItem(coffeeItem: menuItems[3], quantity: 1), // Latte x1
      ],
    ),
    Order(
      id: 'ORD-002',
      customerName: 'Budi Santoso',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: 'done',
      items: [
        OrderItem(coffeeItem: menuItems[5], quantity: 1), // V60 x1
      ],
    ),
    Order(
      id: 'ORD-003',
      customerName: 'Budi Santoso',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      status: 'done',
      items: [
        OrderItem(coffeeItem: menuItems[8], quantity: 1),  // Matcha x1
        OrderItem(coffeeItem: menuItems[9], quantity: 2),  // Chocolate x2
      ],
    ),
  ];

  // ── HELPER: format harga ke Rupiah ────────────────────────────
  static String formatPrice(double price) {
    final formatted = price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
          (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }

  // ── HELPER: format status order ───────────────────────────────
  static String getStatusLabel(String status) {
    switch (status) {
      case 'pending':   return 'Menunggu';
      case 'process':   return 'Diproses';
      case 'done':      return 'Selesai';
      case 'cancelled': return 'Dibatalkan';
      default:          return status;
    }
  }
}