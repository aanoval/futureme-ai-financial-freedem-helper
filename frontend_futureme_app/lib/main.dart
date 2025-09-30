// Entry point aplikasi FutureMe, mengatur provider, tema, dan inisialisasi storage.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'data/services/database_service.dart';
import 'data/services/local_storage_service.dart';
import 'providers/ai_chat_provider.dart';
import 'providers/financial_provider.dart';
import 'providers/goal_provider.dart';
import 'providers/mood_provider.dart';
import 'providers/user_provider.dart';
import 'ui/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SQLite database
  await DatabaseService().db;
  
  // Initialize SharedPreferences for UserProfile
  await LocalStorageService().getProfile();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => FinancialProvider()),
        ChangeNotifierProvider(create: (_) => GoalProvider()),
        ChangeNotifierProvider(create: (_) => MoodProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: AppColors.theme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}