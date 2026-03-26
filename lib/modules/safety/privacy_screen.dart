import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';

/// Privacy explanation screen in plain English.
///
/// Accessible from parent settings without the parent gate
/// (parents should always be able to read this).
/// Written in friendly, reassuring language — not legal jargon.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  static const _safetyPoints = [
    _SafetyPoint(
      icon: Icons.phone_android_rounded,
      text: 'Everything stays on this phone',
    ),
    _SafetyPoint(
      icon: Icons.wifi_off_rounded,
      text: 'No internet connection needed',
    ),
    _SafetyPoint(
      icon: Icons.person_off_rounded,
      text: 'No account or login required',
    ),
    _SafetyPoint(
      icon: Icons.visibility_off_rounded,
      text: 'We never see your child\'s photos',
    ),
    _SafetyPoint(
      icon: Icons.block_rounded,
      text: 'No ads, no tracking',
    ),
    _SafetyPoint(
      icon: Icons.camera_alt_rounded,
      text: 'Camera is only used inside the app',
    ),
    _SafetyPoint(
      icon: Icons.save_rounded,
      text: 'Photos are only saved if YOU turn it on',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, AppColors.homeGradientBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded, size: 28),
                    ),
                    const Spacer(),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Center(
                        child: Text(
                          'How KidCam Fun\nKeeps Your Child Safe',
                          style: TextStyle(
                            fontFamily: AppFonts.primary,
                            fontWeight: AppFonts.extraBold,
                            fontSize: 26,
                            color: AppColors.textDark,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Safety checkmarks
                      ...List.generate(_safetyPoints.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: AppColors.mintGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _safetyPoints[i].icon,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    _safetyPoints[i].text,
                                    style: TextStyle(
                                      fontFamily: AppFonts.primary,
                                      fontWeight: AppFonts.bold,
                                      fontSize: 17,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 24),

                      // Closing statement
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.skyBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'KidCam Fun never sends\nany data anywhere.',
                              style: TextStyle(
                                fontFamily: AppFonts.primary,
                                fontWeight: AppFonts.extraBold,
                                fontSize: 18,
                                color: AppColors.textDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'It\'s just a toy \u2014 a really fun one.',
                              style: TextStyle(
                                fontFamily: AppFonts.primary,
                                fontWeight: AppFonts.bold,
                                fontSize: 16,
                                color: AppColors.textLight,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SafetyPoint {
  final IconData icon;
  final String text;

  const _SafetyPoint({required this.icon, required this.text});
}
