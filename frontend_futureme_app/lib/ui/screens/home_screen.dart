import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/helpers.dart';
import '../../providers/user_provider.dart';
import '../widgets/custom_button.dart';
import 'mood_screen.dart';
import 'goal_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper function to safely calculate progress
  double safeCalculateProgress(int age, int targetFreedomAge) {
    if (age <= 0 || targetFreedomAge <= 0 || age >= targetFreedomAge) {
      return 0.0;
    }
    return age / targetFreedomAge;
  }

  // Helper function to safely calculate years to freedom
  String safeCalculateYearsToFreedom(int age, int targetFreedomAge) {
    if (age <= 0 || targetFreedomAge <= 0 || age >= targetFreedomAge) {
      return 'N/A';
    }
    return (targetFreedomAge - age).toString();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProvider>().profile;

    return Scaffold(
      appBar: AppBar(
        title: Text('Beranda', style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary)),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kartu Profil Interaktif
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary.withOpacity(0.1), AppColors.backgroundSecondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                profile.name.isNotEmpty ? profile.name[0] : '?',
                                style: AppTextStyles.heading1.copyWith(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hai, ${profile.name.isNotEmpty ? profile.name : "Pengguna"}!',
                                    style: AppTextStyles.heading1.copyWith(color: AppColors.textPrimary),
                                  ),
                                  Text(
                                    'Menuju Kebebasan Finansial',
                                    style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Umur Saat Ini', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                                Text('${profile.age > 0 ? profile.age : "N/A"} Tahun', style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Target Bebas Finansial', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                                Text('${profile.targetFreedomAge > 0 ? profile.targetFreedomAge : "N/A"} Tahun', style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: safeCalculateProgress(profile.age, profile.targetFreedomAge),
                          backgroundColor: AppColors.textSecondary.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${safeCalculateYearsToFreedom(profile.age, profile.targetFreedomAge)} Tahun Tersisa',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Ringkasan Keuangan
                Text('Ringkasan Keuangan', style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text('Tabungan', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                              Text(
                                formatCurrency(profile.savings),
                                style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text('Hutang', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                              Text(
                                formatCurrency(profile.debts),
                                style: AppTextStyles.heading2.copyWith(color: AppColors.error),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Tombol Fitur Utama
                Text('Fitur Utama', style: AppTextStyles.heading2.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Catat Mood',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MoodScreen()),
                          );
                        },
                        backgroundColor: AppColors.primary,
                        textColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: 'Tujuan Keuangan',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const GoalScreen()),
                          );
                        },
                        backgroundColor: AppColors.primary,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}