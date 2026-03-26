import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_fonts.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/photo_taken_screen.dart';
import 'modules/parent_gate/parent_gate_screen.dart';
import 'modules/parent_gate/parent_settings_screen.dart';
import 'modules/safety/privacy_screen.dart';

class KidCamApp extends StatelessWidget {
  const KidCamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KidCam Fun',
      debugShowCheckedModeBanner: false,
      theme: _buildKidCamTheme(),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/home': (_) => const HomeScreen(),
        '/camera': (_) => const CameraScreen(),
        '/photo_taken': (_) => const PhotoTakenScreen(),
        '/parent_gate': (_) => const ParentGateScreen(),
        '/parent_settings': (_) => const ParentSettingsScreen(),
        '/privacy': (_) => const PrivacyScreen(),
      },
    );
  }

  ThemeData _buildKidCamTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.sunshineYellow,
        brightness: Brightness.light,
        primary: AppColors.sunshineYellow,
        secondary: AppColors.skyBlue,
        tertiary: AppColors.coral,
        surface: Colors.white,
      ),
      fontFamily: AppFonts.primary,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppFonts.primary,
          fontWeight: AppFonts.extraBold,
          fontSize: 40,
          color: AppColors.textDark,
        ),
        displayMedium: TextStyle(
          fontFamily: AppFonts.primary,
          fontWeight: AppFonts.bold,
          fontSize: 32,
          color: AppColors.textDark,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppFonts.primary,
          fontWeight: AppFonts.bold,
          fontSize: 24,
          color: AppColors.textDark,
        ),
        titleLarge: TextStyle(
          fontFamily: AppFonts.primary,
          fontWeight: AppFonts.bold,
          fontSize: 20,
          color: AppColors.textDark,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppFonts.primary,
          fontWeight: AppFonts.bold,
          fontSize: 16,
          color: AppColors.textDark,
        ),
        labelLarge: TextStyle(
          fontFamily: AppFonts.primary,
          fontWeight: AppFonts.extraBold,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.sunshineYellow,
          foregroundColor: AppColors.textDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: AppFonts.primary,
            fontWeight: AppFonts.extraBold,
            fontSize: 18,
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.primary,
          fontWeight: AppFonts.bold,
          fontSize: 22,
          color: AppColors.textDark,
        ),
        iconTheme: IconThemeData(color: AppColors.textDark),
      ),
    );
  }
}
