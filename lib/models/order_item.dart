import 'coffee_item.dart';

class OrderItem {
  final CoffeeItem coffeeItem;
  int quantity;
  String? note;

  OrderItem({
    required this.coffeeItem,
    this.quantity = 1,
    this.note,
  });

  double get subtotal => coffeeItem.price * quantity;
}

class Order {
  final String id;
  final List<OrderItem> items;
  final DateTime createdAt;
  final String status; // 'pending', 'process', 'done', 'cancelled'
  final String customerName;

  const Order({
    required this.id,
    required this.items,
    required this.createdAt,
    required this.status,
    required this.customerName,
  });

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}