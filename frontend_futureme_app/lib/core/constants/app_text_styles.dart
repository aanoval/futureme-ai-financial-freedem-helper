// Dokumen: Gaya teks untuk konsistensi UI di aplikasi FutureMe, dengan font modern.
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary);
  static const TextStyle heading2 = TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static const TextStyle bodyLarge = TextStyle(fontSize: 18, color: AppColors.textPrimary);
  static final TextStyle bodyMedium = TextStyle(fontSize: 16, color: AppColors.textSecondary);
  static const TextStyle button = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);
  static final TextStyle caption = TextStyle(fontSize: 12, color: AppColors.textSecondary);
  // Gunakan untuk animasi teks fade-in.
}