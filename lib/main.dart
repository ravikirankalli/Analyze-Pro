import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'theme/app_colors.dart';
import 'widgets/brand.dart';

void main() => runApp(const AnalyzeProApp());

class AnalyzeProApp extends StatelessWidget {
  const AnalyzeProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Brand.title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.brightBlue,
          primary: AppColors.brightBlue,
        ),
        scaffoldBackgroundColor: AppColors.white,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
