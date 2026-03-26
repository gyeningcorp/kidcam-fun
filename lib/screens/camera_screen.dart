import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_fonts.dart';
import '../modules/camera/camera_controller_wrapper.dart';
import '../modules/camera/camera_permission_handler.dart';
import '../modules/face_tracking/expression_detector.dart';
import '../modules/face_tracking/face_tracking_notifier.dart';
import '../modules/filters/filter_carousel.dart';
import '../modules/filters/filter_registry.dart';
import '../modules/filters/filter_renderer.dart';

/// Main camera experience screen.
///
/// Composites the live camera preview with filter overlays,
/// expression reaction effects, and the filter carousel.
class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen>
    with WidgetsBindingObserver {
  bool _showExpressionEffect = false;
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize camera after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cameraControllerProvider).initialize();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final camera = ref.read(cameraControllerProvider);
    if (state == AppLifecycleState.inactive) {
      camera.pause();
    } else if (state == AppLifecycleState.resumed) {
      camera.resume();
    }
  }

  Future<void> _capturePhoto() async {
    // Haptic feedback on capture
    HapticFeedback.mediumImpact();

    final camera = ref.read(cameraControllerProvider);
    final photo = await camera.capturePhoto();
    if (photo != null && mounted) {
      Navigator.of(context).pushNamed('/photo_taken', arguments: photo.path);
    }
  }

  void _onSwipeFilter(DragEndDetails details) {
    final filters = FilterRegistry.allFilters;
    final currentIndex = ref.read(selectedFilterIndexProvider);
    final velocity = details.primaryVelocity ?? 0;

    if (velocity < -200 && currentIndex < filters.length - 1) {
      // Swipe left — next filter
      ref.read(selectedFilterIndexProvider.notifier).state = currentIndex + 1;
    } else if (velocity > 200 && currentIndex > 0) {
      // Swipe right — previous filter
      ref.read(selectedFilterIndexProvider.notifier).state = currentIndex - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final camera = ref.watch(cameraControllerProvider);
    final faceData = ref.watch(faceTrackingProvider);
    final selectedFilter = ref.watch(selectedFilterProvider);
    final expression = ref.watch(expressionDetectorProvider);

    // Trigger expression effect overlay
    if (expression == ExpressionEvent.smile && !_showExpressionEffect) {
      _showExpressionEffect = true;
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _showExpressionEffect = false);
      });
    }

    if (camera.errorMessage != null) {
      return const CameraPermissionDeniedScreen();
    }

    if (!camera.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.sunshineYellow),
              const SizedBox(height: 16),
              Text(
                'Starting camera...',
                style: TextStyle(
                  fontFamily: AppFonts.primary,
                  fontWeight: AppFonts.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: back button + sound toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: Colors.white,
                    iconSize: 28,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() => _soundEnabled = !_soundEnabled);
                    },
                    icon: Icon(
                      _soundEnabled
                          ? Icons.music_note_rounded
                          : Icons.music_off_rounded,
                    ),
                    color: Colors.white,
                    iconSize: 28,
                  ),
                ],
              ),
            ),

            // Camera preview with filter overlay
            Expanded(
              child: GestureDetector(
                onHorizontalDragEnd: _onSwipeFilter,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Camera preview
                      CameraPreview(camera.controller!),

                      // Filter overlay
                      faceData.when(
                        data: (face) => FilterRendererWidget(
                          faceData: face,
                          filter: selectedFilter,
                          previewSize: MediaQuery.of(context).size,
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),

                      // Expression reaction overlay (smile -> stars)
                      if (_showExpressionEffect)
                        const _ExpressionReactionOverlay(),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Filter carousel
            const FilterCarousel(),

            const SizedBox(height: 16),

            // Capture button
            GestureDetector(
              onTap: _capturePhoto,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.captureInner,
                  border: Border.all(
                    color: AppColors.captureOuter,
                    width: 5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.captureOuter.withOpacity(0.3),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 36,
                  color: AppColors.captureOuter,
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Stars/hearts burst overlay triggered by smile detection.
class _ExpressionReactionOverlay extends StatefulWidget {
  const _ExpressionReactionOverlay();

  @override
  State<_ExpressionReactionOverlay> createState() =>
      _ExpressionReactionOverlayState();
}

class _ExpressionReactionOverlayState extends State<_ExpressionReactionOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return IgnorePointer(
          child: Stack(
            children: List.generate(8, (i) {
              final progress = _controller.value;
              final angle = (i / 8) * 3.14159 * 2;
              final radius = progress * 150;
              final opacity = (1.0 - progress).clamp(0.0, 1.0);

              return Positioned(
                left: MediaQuery.of(context).size.width / 2 +
                    radius * _cos(angle) -
                    12,
                top: MediaQuery.of(context).size.height / 3 +
                    radius * _sin(angle) -
                    12,
                child: Opacity(
                  opacity: opacity,
                  child: Text(
                    i.isEven ? '\u{2B50}' : '\u{2764}\u{FE0F}',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  double _cos(double angle) => angle.isFinite ? _cosApprox(angle) : 0;
  double _sin(double angle) => angle.isFinite ? _sinApprox(angle) : 0;

  // Simple trigonometry without importing dart:math in the widget
  double _cosApprox(double x) {
    // Taylor series approximation for cos
    x = x % (2 * 3.14159);
    return 1 - (x * x) / 2 + (x * x * x * x) / 24;
  }

  double _sinApprox(double x) {
    x = x % (2 * 3.14159);
    return x - (x * x * x) / 6 + (x * x * x * x * x) / 120;
  }
}
