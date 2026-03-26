import 'dart:math';

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_fonts.dart';

/// Home screen with a giant PLAY button and floating emoji background.
///
/// Deliberately simple: just one big button for kids and a subtle
/// lock icon for parents. No other UI elements to confuse young children.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _emojiController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Play button pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Floating emoji animation
    _emojiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _emojiController.dispose();
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
              AppColors.homeGradientTop,
              AppColors.homeGradientBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Floating emoji background
              ...List.generate(8, (i) => _FloatingEmoji(
                controller: _emojiController,
                index: i,
              )),

              // Center: Giant PLAY button
              Center(
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed('/camera'),
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.sunshineYellow,
                            AppColors.coral,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.coral.withOpacity(0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt_rounded,
                            size: 56,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'PLAY',
                            style: AppFonts.playButton.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom right: Parent gate lock icon (subtle)
              Positioned(
                bottom: 24,
                right: 24,
                child: GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed('/parent_gate'),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: 20,
                      color: AppColors.textLight.withOpacity(0.5),
                    ),
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

/// A single floating emoji in the home screen background.
class _FloatingEmoji extends StatelessWidget {
  final AnimationController controller;
  final int index;

  const _FloatingEmoji({required this.controller, required this.index});

  static const _emojis = [
    '\u{1F31F}', // star
    '\u{1F388}', // balloon
    '\u{1F98B}', // butterfly
    '\u{1F308}', // rainbow
    '\u{2728}',  // sparkles
    '\u{1F31F}', // star
    '\u{1F388}', // balloon
    '\u{1F98B}', // butterfly
  ];

  @override
  Widget build(BuildContext context) {
    final random = Random(index * 42);
    final startX = random.nextDouble() * 0.9 + 0.05;
    final speed = 0.3 + random.nextDouble() * 0.7;
    final size = 20.0 + random.nextDouble() * 16;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final progress = ((controller.value * speed) + index / 8) % 1.0;
        final screenSize = MediaQuery.of(context).size;

        // Gentle sine wave horizontal drift
        final xOffset = sin(progress * 2 * pi) * 20;

        return Positioned(
          left: startX * screenSize.width + xOffset,
          top: screenSize.height * (1.0 - progress),
          child: Opacity(
            opacity: (sin(progress * pi) * 0.6).clamp(0.0, 0.6),
            child: Text(
              _emojis[index],
              style: TextStyle(fontSize: size),
            ),
          ),
        );
      },
    );
  }
}
