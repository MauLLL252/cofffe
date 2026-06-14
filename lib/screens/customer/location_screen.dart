import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class LocationScreen extends StatefulWidget {
  final String selected;
  const LocationScreen({super.key, required this.selected});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late String _selected;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  // Daftar lokasi outlet Titik Kopi
  final List<_OutletLocation> _outlets = const [
    _OutletLocation(
      id: 'tk_sudirman',
      name: 'Titik Kopi Sudirman',
      address: 'Jl. Jend. Sudirman No. 12, Jakarta Pusat',
      area: 'Jakarta Pusat',
      distance: '0.3 km',
      isOpen: true,
      lat: -6.2088,
      lng: 106.8456,
      tag: 'Terdekat',
    ),
    _OutletLocation(
      id: 'tk_kemang',
      name: 'Titik Kopi Kemang',
      address: 'Jl. Kemang Raya No. 45, Jakarta Selatan',
      area: 'Jakarta Selatan',
      distance: '2.1 km',
      isOpen: true,
      lat: -6.2607,
      lng: 106.8133,
      tag: 'Populer',
    ),
    _OutletLocation(
      id: 'tk_kelapa_gading',
      name: 'Titik Kopi Kelapa Gading',
      address: 'Mall of Indonesia Lt. 2, Kelapa Gading',
      area: 'Jakarta Utara',
      distance: '5.4 km',
      isOpen: true,
      lat: -6.1588,
      lng: 106.9064,
      tag: '',
    ),
    _OutletLocation(
      id: 'tk_BSD',
      name: 'Titik Kopi BSD City',
      address: 'The Breeze BSD City, Tangerang Selatan',
      area: 'Tangerang Selatan',
      distance: '12.7 km',
      isOpen: false,
      lat: -6.3014,
      lng: 106.6519,
      tag: '',
    ),
    _OutletLocation(
      id: 'tk_depok',
      name: 'Titik Kopi Depok',
      address: 'Jl. Margonda Raya No. 88, Depok',
      area: 'Depok',
      distance: '14.2 km',
      isOpen: true,
      lat: -6.3970,
      lng: 106.8190,
      tag: '',
    ),
    _OutletLocation(
      id: 'tk_bekasi',
      name: 'Titik Kopi Bekasi',
      address: 'Grand Metropolitan Mall Lt. 1, Bekasi',
      area: 'Bekasi',
      distance: '18.5 km',
      isOpen: true,
      lat: -6.2383,
      lng: 106.9756,
      tag: '',
    ),
  ];

  List<_OutletLocation> get _filtered {
    if (_searchQuery.isEmpty) return _outlets;
    return _outlets
        .where((o) =>
    o.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        o.area.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        o.address.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
          'Pilih Lokasi Outlet',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _selected),
            child: const Text(
              'Simpan',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search Bar ──────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Cari nama outlet atau area...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textGrey,
                  size: 20,
                ),
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

          // ── Mini Map Placeholder ────────────────────────────
          _buildMiniMap(),

          // ── Label ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih Outlet',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  '${_filtered.length} outlet',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),

          // ── List Outlet ─────────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? _buildEmpty()
                : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) =>
              const SizedBox(height: 10),
              itemBuilder: (context, index) =>
                  _buildOutletCard(_filtered[index]),
            ),
          ),
        ],
      ),
    );
  }

  // ── MINI MAP ────────────────────────────────────────────────
  Widget _buildMiniMap() {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFE8F0E8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // ── Grid jalan (simulasi peta) ──────────────────
            CustomPaint(
              size: const Size(double.infinity, 180),
              painter: _MapPainter(),
            ),

            // ── Pin outlet ───────────────────────────────────
            ..._buildMapPins(),

            // ── Overlay tombol buka maps ──────────────────────
            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => _showOpenMapsDialog(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.map_outlined,
                          size: 14, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text(
                        'Buka Maps',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Label peta ───────────────────────────────────
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on,
                        size: 12, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'Outlet Titik Kopi',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Buat pin outlet di peta (posisi relatif disederhanakan)
  List<Widget> _buildMapPins() {
    // Posisi relatif di dalam kotak peta (x%, y%)
    final positions = [
      const Offset(0.45, 0.45), // Sudirman
      const Offset(0.35, 0.62), // Kemang
      const Offset(0.72, 0.28), // Kelapa Gading
      const Offset(0.18, 0.70), // BSD
      const Offset(0.42, 0.78), // Depok
      const Offset(0.80, 0.55), // Bekasi
    ];

    return List.generate(
      _outlets.length > positions.length
          ? positions.length
          : _outlets.length,
          (i) {
        final outlet   = _outlets[i];
        final pos      = positions[i];
        final isActive = outlet.id == _selected;

        return Positioned(
          left: pos.dx * (MediaQuery.of(context).size.width - 32) - 16,
          top: pos.dy * 180 - 20,
          child: GestureDetector(
            onTap: () {
              if (outlet.isOpen) {
                setState(() => _selected = outlet.id);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bubble nama (hanya untuk yang terpilih)
                if (isActive)
                  Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      outlet.name.replaceAll('Titik Kopi ', ''),
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // Pin icon
                Container(
                  width: isActive ? 32 : 24,
                  height: isActive ? 32 : 24,
                  decoration: BoxDecoration(
                    color: !outlet.isOpen
                        ? AppColors.textGrey
                        : isActive
                        ? AppColors.primary
                        : AppColors.accent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: isActive ? 2.5 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.coffee,
                    size: isActive ? 16 : 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOpenMapsDialog() {
    final outlet = _outlets.firstWhere(
          (o) => o.id == _selected,
      orElse: () => _outlets.first,
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.map, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Buka di Maps'),
          ],
        ),
        content: Text(
          'Buka lokasi "${outlet.name}" di Google Maps?',
          style: const TextStyle(fontSize: 13),
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
              // Di sini bisa pakai url_launcher untuk buka Google Maps
              // launch('https://maps.google.com/?q=${outlet.lat},${outlet.lng}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '🗺️ Membuka ${outlet.name} di Maps...'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: const Text('Buka Maps'),
          ),
        ],
      ),
    );
  }

  // ── EMPTY STATE ─────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          const Text(
            'Outlet tidak ditemukan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Coba kata kunci lain',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  // ── CARD OUTLET ─────────────────────────────────────────────
  Widget _buildOutletCard(_OutletLocation outlet) {
    final isSelected = outlet.id == _selected;

    return GestureDetector(
      onTap: () {
        if (!outlet.isOpen) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${outlet.name} sedang tutup'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          return;
        }
        setState(() => _selected = outlet.id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
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
            // Icon lokasi
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.store_outlined,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textGrey,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            // Info outlet
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama + tag
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          outlet.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: outlet.isOpen
                                ? AppColors.textDark
                                : AppColors.textGrey,
                          ),
                        ),
                      ),
                      if (outlet.tag.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            outlet.tag,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Alamat
                  Text(
                    outlet.address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Jarak + status buka
                  Row(
                    children: [
                      const Icon(Icons.near_me,
                          size: 12, color: AppColors.textGrey),
                      const SizedBox(width: 4),
                      Text(
                        outlet.distance,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: outlet.isOpen
                              ? AppColors.success
                              : AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        outlet.isOpen ? 'Buka' : 'Tutup',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: outlet.isOpen
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Radio button
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── CUSTOM PAINTER UNTUK PETA SEDERHANA ─────────────────────────
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final minorPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final bgPaint = Paint()
      ..color = const Color(0xFFD4E6D4)
      ..style = PaintingStyle.fill;

    // Background hijau muda (seperti area terbuka)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      bgPaint,
    );

    // Blok-blok bangunan
    final blockPaint = Paint()
      ..color = const Color(0xFFB8D4B8)
      ..style = PaintingStyle.fill;

    final blocks = [
      Rect.fromLTWH(10, 10, 80, 50),
      Rect.fromLTWH(110, 10, 60, 40),
      Rect.fromLTWH(200, 20, 90, 45),
      Rect.fromLTWH(10, 80, 50, 60),
      Rect.fromLTWH(80, 90, 70, 40),
      Rect.fromLTWH(170, 80, 80, 55),
      Rect.fromLTWH(10, 155, 100, 20),
      Rect.fromLTWH(150, 145, 120, 30),
    ];

    for (final block in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(block, const Radius.circular(4)),
        blockPaint,
      );
    }

    // Jalan utama horizontal
    canvas.drawLine(
      Offset(0, size.height * 0.38),
      Offset(size.width, size.height * 0.38),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.72),
      Offset(size.width, size.height * 0.72),
      roadPaint,
    );

    // Jalan utama vertikal
    canvas.drawLine(
      Offset(size.width * 0.33, 0),
      Offset(size.width * 0.33, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.68, 0),
      Offset(size.width * 0.68, size.height),
      roadPaint,
    );

    // Jalan kecil
    canvas.drawLine(
      Offset(0, size.height * 0.55),
      Offset(size.width * 0.33, size.height * 0.55),
      minorPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.68, size.height * 0.55),
      Offset(size.width, size.height * 0.55),
      minorPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.50, 0),
      Offset(size.width * 0.50, size.height * 0.38),
      minorPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.72),
      Offset(size.width * 0.50, size.height),
      minorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── MODEL OUTLET ─────────────────────────────────────────────────
class _OutletLocation {
  final String id, name, address, area, distance, tag;
  final bool isOpen;
  final double lat, lng;

  const _OutletLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.area,
    required this.distance,
    required this.isOpen,
    required this.lat,
    required this.lng,
    required this.tag,
  });
}