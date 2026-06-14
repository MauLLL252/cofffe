import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // ── Controller logo muncul (fade in) ──────────────────────
  late AnimationController _logoAppearCtrl;
  late Animation<double>   _logoFade;

  // ── Controller logo + teks bergerak ───────────────────────
  late AnimationController _moveCtrl;
  late Animation<double>   _logoMoveX;   // logo geser kiri (0 → -offset)
  late Animation<double>   _textFade;    // teks fade in
  late Animation<double>   _textMoveX;  // teks geser dari kanan

  bool _started = false;

  @override
  void initState() {
    super.initState();

    // ── Fase 2: logo muncul fade-in ──────────────────────────
    _logoAppearCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoAppearCtrl,
        curve: Curves.easeIn,
      ),
    );

    // ── Fase 3: logo geser + teks muncul ─────────────────────
    _moveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Logo bergerak ke kiri (nilai dalam piksel, pakai LayoutBuilder nanti)
    _logoMoveX = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _moveCtrl,
        curve: Curves.easeInOut,
      ),
    );

    // Teks fade in bersamaan
    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _moveCtrl,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    // Teks slide dari kanan
    _textMoveX = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(
        parent: _moveCtrl,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    // Fase 1: layar putih kosong 1000ms
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    // Fase 2: logo fade-in di tengah
    await _logoAppearCtrl.forward();
    if (!mounted) return;

    // Jeda sebentar logo di tengah
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    // Fase 3: logo geser kiri + teks muncul
    setState(() => _started = true);
    await _moveCtrl.forward();
    if (!mounted) return;

    // Tahan sebentar lalu navigasi
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed('/auth');
  }

  @override
  void dispose() {
    _logoAppearCtrl.dispose();
    _moveCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    // Seberapa jauh logo bergeser ke kiri dari center
    // Kita geser logo ke x = screenW * 0.22 (kiri)
    // Center logo awalnya di screenW * 0.5
    // Jadi offset = screenW * 0.5 - screenW * 0.22 = screenW * 0.28
    // final logoShift = screenW * 0.22;
    final desiredLogoLeftPadding = 60.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: Stack(
        children: [
          // ── Logo ──────────────────────────────────────────
          AnimatedBuilder(
            animation: Listenable.merge([
              _logoAppearCtrl,
              _moveCtrl,
            ]),
            builder: (context, child) {
              // Posisi X logo:
              // - Sebelum move: di tengah layar
              // - Setelah move: geser ke kiri
              final centerX = screenW / 2 - 70; // 70 = setengah lebar logo
              // final targetX = logoShift - 70;
              final targetX = desiredLogoLeftPadding;
              final currentX = _started
                  ? centerX + (targetX - centerX) * _logoMoveX.value
                  : centerX;

              return Positioned(
                left: currentX,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Opacity(
                    opacity: _logoFade.value,
                    child: child,
                  ),
                ),
              );
            },
            child: Image.asset(
              'assets/images/logo.png',
              width: 140,
              height: 140,
              errorBuilder: (_, __, ___) => Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  color: Color(0xFF4A2B1D),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('☕', style: TextStyle(fontSize: 70)),
                ),
              ),
            ),
          ),

          // ── Teks "Titik" dan "Kopi" ────────────────────────
          AnimatedBuilder(
            animation: _moveCtrl,
            builder: (context, child) {
              // Posisi X teks: di sebelah kanan logo
              // Logo target ada di logoShift, lebar logo 140
              // Teks mulai dari logoShift + 140 + 16 (gap)
              // final textTargetX = logoShift + 90 + 32.0;
              final logoTargetRight = desiredLogoLeftPadding + 140;
              final desiredGap = 32.0;
              final textTargetX = logoTargetRight + desiredGap;
              final currentTextX =
                  textTargetX + _textMoveX.value;

              return Positioned(
                left: currentTextX,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Opacity(
                    opacity: _textFade.value,
                    child: child,
                  ),
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Titik',
                  style: GoogleFonts.ovo(
                    fontSize: 42,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF2C1E16),
                    height: 1.1,
                  ),
                ),
                Text(
                  'Kopi',
                  style: GoogleFonts.ovo(
                    fontSize: 42,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF2C1E16),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}