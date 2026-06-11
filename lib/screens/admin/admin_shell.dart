import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _PlaceholderPage(title: '📋 Kelola Menu'),
    const _PlaceholderPage(title: '🛒 Pesanan'),
    const _PlaceholderPage(title: '📊 Laporan'),
    const _PlaceholderPage(title: '👤 Profil Admin'),
  ];

  final List<BottomNavItem> _navItems = const [
    BottomNavItem(
      label: 'Menu',
      icon: Icons.restaurant_menu_outlined,
      activeIcon: Icons.restaurant_menu,
    ),
    BottomNavItem(
      label: 'Pesanan',
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag,
    ),
    BottomNavItem(
      label: 'Laporan',
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart,
    ),
    BottomNavItem(
      label: 'Profil',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _navItems,
      ),
    );
  }
}