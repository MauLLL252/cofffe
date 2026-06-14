import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isLogin = true;

  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure       = true;
  bool _isLoading     = false;

  late AnimationController _fadeCtrl;
  late Animation<double>   _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: 1,
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeCtrl,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _toggleMode() async {
    await _fadeCtrl.reverse();
    setState(() => _isLogin = !_isLogin);
    _fadeCtrl.forward();
  }

  void _handleSubmit() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || _passwordCtrl.text.isEmpty) {
      _showSnack('Email dan password tidak boleh kosong!');
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (email.contains('admin')) {
      Navigator.of(context).pushReplacementNamed('/admin');
    } else {
      Navigator.of(context).pushReplacementNamed('/customer');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 56),

                // ── Logo + Nama App ──────────────────────────
                Center(
                  child: Column(
                    children: [
                      // Logo kopi
                      Image.asset(
                        'assets/images/logo.png',
                        width: 64,
                        height: 64,
                        // Fallback kalau asset belum siap
                        errorBuilder: (_, __, ___) => Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A2B1D),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '☕',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Nama app font OVO
                      Text(
                        'Titik Kopi',
                        style: GoogleFonts.ovo(
                          fontSize: 28,
                          color: const Color(0xFF2C1E16),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // ── Judul form ───────────────────────────────
                Text(
                  _isLogin ? 'Masuk' : 'Buat Akun',
                  style: GoogleFonts.ovo(
                    fontSize: 26,
                    color: const Color(0xFF2C1E16),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  _isLogin
                      ? 'Selamat datang kembali!'
                      : 'Daftar untuk mulai memesan',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Field nama (register only) ───────────────
                if (!_isLogin) ...[
                  _buildField(
                    ctrl: _nameCtrl,
                    hint: 'Nama Lengkap',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 14),
                ],

                // ── Field email ──────────────────────────────
                _buildField(
                  ctrl: _emailCtrl,
                  hint: 'Email',
                  icon: Icons.email_outlined,
                  keyboard: TextInputType.emailAddress,
                ),

                const SizedBox(height: 14),

                // ── Field password ───────────────────────────
                _buildField(
                  ctrl: _passwordCtrl,
                  hint: 'Password',
                  icon: Icons.lock_outline,
                  obscure: _obscure,
                  suffix: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: AppColors.textGrey,
                    ),
                    onPressed: () =>
                        setState(() => _obscure = !_obscure),
                  ),
                ),

                // ── Lupa password ────────────────────────────
                if (_isLogin) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Lupa Password?',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // ── Tombol submit ────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C1E16),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      _isLogin ? 'Masuk' : 'Daftar',
                      style: GoogleFonts.ovo(
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Divider ──────────────────────────────────
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'atau',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Toggle login/register ────────────────────
                Center(
                  child: GestureDetector(
                    onTap: _toggleMode,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                        ),
                        children: [
                          TextSpan(
                            text: _isLogin
                                ? 'Belum punya akun? '
                                : 'Sudah punya akun? ',
                          ),
                          TextSpan(
                            text: _isLogin
                                ? 'Daftar Sekarang'
                                : 'Masuk',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Info demo ────────────────────────────────


                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      obscureText: obscure,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF2C1E16),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.textGrey,
        ),
        prefixIcon: Icon(icon, size: 18, color: AppColors.textGrey),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF4A2B1D),
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}