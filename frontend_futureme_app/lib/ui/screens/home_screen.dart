// Layar home dengan informasi profil pengguna.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/helpers.dart';
import '../../providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProvider>().profile;
    return AnimatedOpacity(
      opacity: 1.0,
      duration: animationDuration,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppStrings.welcome, style: AppTextStyles.heading1),
            Text('Nama: ${profile.name}'),
            Text('Umur: ${profile.age}'),
            Text('${AppStrings.financialFreedom}: ${profile.targetFreedomAge}'),
            Text('Tahun tersisa: ${calculateYearsToFreedom(profile.age, profile.targetFreedomAge)}'),
          ],
        ),
      ),
    );
  }
}