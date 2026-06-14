import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  final List<_UserData> _customers = [
    _UserData(
      id: 'u1',
      name: 'Budi Santoso',
      email: 'budi.santoso@email.com',
      phone: '+62 812 3456 7890',
      role: 'customer',
      status: 'active',
      joinDate: '12 Jan 2024',
      totalOrder: 15,
      memberLevel: 'Gold',
    ),
    _UserData(
      id: 'u2',
      name: 'Siti Rahayu',
      email: 'siti.rahayu@email.com',
      phone: '+62 813 9876 5432',
      role: 'customer',
      status: 'active',
      joinDate: '5 Mar 2024',
      totalOrder: 8,
      memberLevel: 'Silver',
    ),
    _UserData(
      id: 'u3',
      name: 'Andi Wijaya',
      email: 'andi.wijaya@email.com',
      phone: '+62 857 1234 5678',
      role: 'customer',
      status: 'inactive',
      joinDate: '20 Feb 2024',
      totalOrder: 3,
      memberLevel: 'Bronze',
    ),
    _UserData(
      id: 'u4',
      name: 'Maya Putri',
      email: 'maya.putri@email.com',
      phone: '+62 878 5678 9012',
      role: 'customer',
      status: 'active',
      joinDate: '1 Apr 2024',
      totalOrder: 22,
      memberLevel: 'Gold',
    ),
    _UserData(
      id: 'u5',
      name: 'Reza Firmansyah',
      email: 'reza.f@email.com',
      phone: '+62 821 3456 7890',
      role: 'customer',
      status: 'active',
      joinDate: '15 Apr 2024',
      totalOrder: 5,
      memberLevel: 'Bronze',
    ),
  ];

  final List<_UserData> _admins = [
    _UserData(
      id: 'a1',
      name: 'Admin Titik Kopi',
      email: 'admin@titikkopi.com',
      phone: '+62 21 5555 1234',
      role: 'admin',
      status: 'active',
      joinDate: '1 Jan 2024',
      totalOrder: 0,
      memberLevel: 'Super Admin',
    ),
    _UserData(
      id: 'a2',
      name: 'Barista Manager',
      email: 'manager@titikkopi.com',
      phone: '+62 21 5555 5678',
      role: 'admin',
      status: 'active',
      joinDate: '15 Jan 2024',
      totalOrder: 0,
      memberLevel: 'Manager',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_UserData> get _filteredCustomers => _customers
      .where((u) =>
  u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      u.email.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  List<_UserData> get _filteredAdmins => _admins
      .where((u) =>
  u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      u.email.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  void _showUserDetail(_UserData user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UserDetailSheet(
        user: user,
        onToggleStatus: () {
          setState(() {
            final list =
            user.role == 'customer' ? _customers : _admins;
            final idx = list.indexWhere((u) => u.id == user.id);
            if (idx >= 0) {
              list[idx] = _UserData(
                id: user.id,
                name: user.name,
                email: user.email,
                phone: user.phone,
                role: user.role,
                status:
                user.status == 'active' ? 'inactive' : 'active',
                joinDate: user.joinDate,
                totalOrder: user.totalOrder,
                memberLevel: user.memberLevel,
              );
            }
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAddAdminDialog() {
    final nameCtrl  = TextEditingController();
    final emailCtrl = TextEditingController();
    final roleCtrl  = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Tambah Admin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                hintText: 'Nama lengkap',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: roleCtrl,
              decoration: const InputDecoration(
                hintText: 'Role (Manager / Barista)',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.textGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('✅ Admin berhasil ditambahkan'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: const Text('Tambah'),
          ),
        ],
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
          icon: const Icon(Icons.arrow_back_ios,
              size: 18, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kelola Pengguna',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined,
                color: AppColors.primary),
            onPressed: _showAddAdminDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textGrey,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: 'Customer (${_customers.length})'),
            Tab(text: 'Admin (${_admins.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Cari nama atau email...',
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.textGrey, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.close,
                      color: AppColors.textGrey, size: 18),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _searchQuery = '');
                  },
                )
                    : null,
              ),
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUserList(_filteredCustomers),
                _buildUserList(_filteredAdmins),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(List<_UserData> users) {
    if (users.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada pengguna ditemukan',
          style: TextStyle(color: AppColors.textGrey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) =>
          _buildUserCard(users[index]),
    );
  }

  Widget _buildUserCard(_UserData user) {
    final isActive = user.status == 'active';
    final memberColor = _getMemberColor(user.memberLevel);

    return GestureDetector(
      onTap: () => _showUserDetail(user),
      child: Container(
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
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  user.name[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      // Badge member
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: memberColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          user.memberLevel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: memberColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Status dot
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.success
                              : AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isActive ? 'Aktif' : 'Nonaktif',
                        style: TextStyle(
                          fontSize: 11,
                          color: isActive
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (user.role == 'customer') ...[
                        const SizedBox(width: 10),
                        const Icon(Icons.shopping_bag_outlined,
                            size: 12, color: AppColors.textGrey),
                        const SizedBox(width: 3),
                        Text(
                          '${user.totalOrder} pesanan',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right,
                color: AppColors.textGrey, size: 18),
          ],
        ),
      ),
    );
  }

  Color _getMemberColor(String level) {
    switch (level) {
      case 'Gold':
      case 'Super Admin':
        return const Color(0xFFD4A017);
      case 'Silver':
      case 'Manager':
        return AppColors.textGrey;
      default:
        return const Color(0xFF8B5E3C);
    }
  }
}

// ── BOTTOM SHEET DETAIL USER ─────────────────────────────────────
class _UserDetailSheet extends StatelessWidget {
  final _UserData user;
  final VoidCallback onToggleStatus;

  const _UserDetailSheet({
    required this.user,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = user.status == 'active';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          // Avatar besar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            user.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),

          Text(
            user.memberLevel,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textGrey,
            ),
          ),

          const SizedBox(height: 20),

          // Info grid
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _infoRow(Icons.email_outlined, 'Email', user.email),
                const Divider(height: 16),
                _infoRow(Icons.phone_outlined, 'Telepon', user.phone),
                const Divider(height: 16),
                _infoRow(Icons.calendar_today_outlined,
                    'Bergabung', user.joinDate),
                if (user.role == 'customer') ...[
                  const Divider(height: 16),
                  _infoRow(Icons.shopping_bag_outlined,
                      'Total Pesanan', '${user.totalOrder}x'),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tombol aksi
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onToggleStatus,
                  icon: Icon(
                    isActive
                        ? Icons.block_outlined
                        : Icons.check_circle_outline,
                    size: 16,
                    color: isActive ? AppColors.error : AppColors.success,
                  ),
                  label: Text(
                    isActive ? 'Nonaktifkan' : 'Aktifkan',
                    style: TextStyle(
                      color:
                      isActive ? AppColors.error : AppColors.success,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color:
                      isActive ? AppColors.error : AppColors.success,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Tutup'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textGrey),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textGrey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

// ── MODEL USER ───────────────────────────────────────────────────
class _UserData {
  final String id, name, email, phone, role,
      status, joinDate, memberLevel;
  final int totalOrder;

  const _UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.joinDate,
    required this.totalOrder,
    required this.memberLevel,
  });
}