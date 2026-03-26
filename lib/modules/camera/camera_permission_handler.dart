import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';

/// Handles camera permission requests with a kid-friendly explanation.
///
/// Shows a friendly screen when permission is denied, guiding parents
/// to enable camera access in system settings.
class CameraPermissionHandler {
  /// Check if the camera is available and permitted.
  static Future<bool> checkPermission() async {
    try {
      final cameras = await availableCameras();
      return cameras.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

/// Widget shown when camera permission is denied.
class CameraPermissionDeniedScreen extends StatelessWidget {
  const CameraPermissionDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.homeGradientTop, AppColors.homeGradientBottom],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Friendly camera icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.skyBlue.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 64,
                      color: AppColors.skyBlue,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Camera Needed!',
                    style: AppFonts.celebrationText.copyWith(
                      color: AppColors.textDark,
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'KidCam Fun needs the camera to show silly filters on your face!',
                    style: TextStyle(
                      fontFamily: AppFonts.primary,
                      fontWeight: AppFonts.bold,
                      fontSize: 16,
                      color: AppColors.textLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ask a grown-up to turn on camera access in Settings.',
                    style: TextStyle(
                      fontFamily: AppFonts.primary,
                      fontWeight: AppFonts.bold,
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Go Back'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.skyBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
