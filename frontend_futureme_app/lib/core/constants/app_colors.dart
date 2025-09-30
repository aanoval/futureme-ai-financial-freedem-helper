// Dokumen: Warna tema aplikasi FutureMe untuk desain modern dengan Material 3.
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1976D2); // Biru modern untuk energi freelancer.
  static const Color secondary = Color(0xFF388E3C); // Hijau untuk pertumbuhan finansial.
  static const Color accent = Color(0xFFFFA000); // Kuning cerah untuk mood booster.
  static const Color background = Color(0xFFF5F5F5); // Latar belakang abu-abu lembut.
  static const Color backgroundSecondary = Color(0xFFE8ECEF); // Latar belakang sekunder untuk card.
  static const Color error = Color(0xFFD32F2F); // Merah untuk error.
  static const Color textPrimary = Color(0xFF212121); // Teks utama gelap.
  static const Color textSecondary = Color(0xFF757575); // Teks sekunder abu-abu.
  static const Color cardBackground = Color(0xFFFFFFFF); // Latar belakang card putih bersih.

  // Skema warna untuk tema aplikasi dengan dukungan dark mode.
  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: secondary,
          background: background,
          surface: cardBackground,
          error: error,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          foregroundColor: textPrimary,
          elevation: 0,
          centerTitle: true,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: cardBackground,
          selectedItemColor: primary,
          unselectedItemColor: textSecondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: cardBackground,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: backgroundSecondary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: error, width: 1),
          ),
        ),
      );
}