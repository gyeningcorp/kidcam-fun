import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_fonts.dart';

/// Animated splash screen with logo and floating sparkles.
///
/// Auto-navigates to the home screen after 1.5 seconds.
/// Sets the playful, magical tone for the entire app.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _sparkleController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );

    _logoController.forward();

    // Navigate to home after 1.5 seconds
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.splashGradientTop,
              AppColors.splashGradientBottom,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating sparkles
            ...List.generate(12, (i) => _FloatingSparkle(
              controller: _sparkleController,
              index: i,
            )),

            // Logo
            Center(
              child: FadeTransition(
                opacity: _logoOpacity,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Camera emoji as logo placeholder
                      const Text(
                        '\u{1F4F8}',
                        style: TextStyle(fontSize: 72),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'KidCam Fun',
                        style: TextStyle(
                          fontFamily: AppFonts.primary,
                          fontWeight: AppFonts.extraBold,
                          fontSize: 42,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 3),
                              blurRadius: 12,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single floating sparkle particle in the splash screen.
class _FloatingSparkle extends StatelessWidget {
  final AnimationController controller;
  final int index;

  const _FloatingSparkle({required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    final random = Random(index);
    final startX = random.nextDouble();
    final startY = random.nextDouble();
    final size = 8.0 + random.nextDouble() * 16;
    final sparkleEmoji = ['\u{2728}', '\u{2B50}', '\u{1F31F}'][index % 3];

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final progress = (controller.value + index / 12) % 1.0;
        final screenSize = MediaQuery.of(context).size;

        return Positioned(
          left: startX * screenSize.width,
          top: screenSize.height * (1.0 - progress),
          child: Opacity(
            opacity: (1.0 - progress).clamp(0.0, 0.8),
            child: Text(
              sparkleEmoji,
              style: TextStyle(fontSize: size),
            ),
          ),
        );
      },
    );
  }
}
