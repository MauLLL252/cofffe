import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';
import 'admin_menu.dart';
import 'admin_orders.dart';
import 'admin_reports.dart';
import 'admin_profile.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AdminMenu(),
    const AdminOrders(),
    const AdminReports(),
    const AdminProfile(),
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