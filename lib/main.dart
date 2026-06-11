import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/customer/customer_shell.dart';   // ← tambah
import 'screens/admin/admin_shell.dart';          // ← tambah

void main() {
  runApp(const TitikKopiApp());
}

class TitikKopiApp extends StatelessWidget {
  const TitikKopiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Titik Kopi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/':         (context) => const SplashScreen(),
        '/auth':     (context) => const AuthScreen(),
        '/customer': (context) => const CustomerShell(),  // ← tambah
        '/admin':    (context) => const AdminShell(),     // ← tambah
      },
    );
  }
}