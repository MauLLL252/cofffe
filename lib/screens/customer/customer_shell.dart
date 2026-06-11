import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';
import 'customer_home.dart';
import 'customer_menu.dart';             // ← tambah

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

class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});

  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CustomerHome(),
    const CustomerMenu(),                // ← ganti ini
    const _PlaceholderPage(title: '📋 Riwayat'),
    const _PlaceholderPage(title: '👤 Profil'),
  ];

  final List<BottomNavItem> _navItems = const [
    BottomNavItem(
      label: 'Beranda',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    BottomNavItem(
      label: 'Menu',
      icon: Icons.coffee_outlined,
      activeIcon: Icons.coffee,
    ),
    BottomNavItem(
      label: 'Riwayat',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
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