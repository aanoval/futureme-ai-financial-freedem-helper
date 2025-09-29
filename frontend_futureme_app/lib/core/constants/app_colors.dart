// Dokumen: Warna tema aplikasi FutureMe untuk desain modern dengan Material 3.
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2196F3); // Biru untuk energi freelancer.
  static const Color secondary = Color(0xFF4CAF50); // Hijau untuk pertumbuhan finansial.
  static const Color background = Colors.white;
  static const Color accent = Color(0xFFFFC107); // Kuning untuk mood booster.
  static const Color error = Colors.redAccent;
  static const Color textPrimary = Colors.black87;
  static final Color textSecondary = const Color.fromARGB(255, 119, 117, 117)!;
  static final Color cardBackground = const Color.fromARGB(255, 251, 247, 247)!;
  // Skema warna untuk dark mode jika diimplementasikan.
  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        appBarTheme: AppBarTheme(color: primary, elevation: 0),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: background,
          selectedItemColor: primary,
          unselectedItemColor: textSecondary,
        ),
      );
}