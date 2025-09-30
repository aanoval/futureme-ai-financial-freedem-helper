// Dokumen: Konstanta aset aplikasi untuk FutureMe menggunakan ikon built-in Flutter untuk desain modern.
import 'package:flutter/material.dart';

class AppAssets {
  // Menggunakan ikon built-in Flutter untuk semua ikon di aplikasi.
  static const IconData homeIcon = Icons.home_outlined;
  static const IconData homeActiveIcon = Icons.home;
  static const IconData financialIcon = Icons.account_balance_wallet_outlined;
  static const IconData financialActiveIcon = Icons.account_balance_wallet;
  static const IconData goalIcon = Icons.flag_outlined;
  static const IconData goalActiveIcon = Icons.flag;
  static const IconData profileIcon = Icons.person_outline;
  static const IconData profileActiveIcon = Icons.person;
  static const IconData chatIcon = Icons.chat_bubble_outline;
  static const IconData moodIcon = Icons.sentiment_satisfied;

  // Placeholder untuk animasi Lottie jika diintegrasikan di masa depan.
  static const String lottieLoading = 'assets/lottie/loading.json'; // Contoh path, belum digunakan.
  static const String lottieSuccess = 'assets/lottie/success.json'; // Contoh path, belum digunakan.
}