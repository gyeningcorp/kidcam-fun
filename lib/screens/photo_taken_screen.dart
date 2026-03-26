import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_fonts.dart';
import '../core/models/captured_media.dart';
import '../modules/filters/filter_carousel.dart';
import '../modules/parent_gate/parent_settings_screen.dart';
import '../modules/storage/local_storage_service.dart';
import '../modules/storage/media_index_db.dart';

/// Photo preview screen shown after capturing a photo.
///
/// Shows the captured photo with a celebration animation.
/// Auto-saves to app sandbox. Optionally saves to photo library
/// if the parent has enabled that setting.
///
/// IMPORTANT: No share button. No send button. Ever.
class PhotoTakenScreen extends ConsumerStatefulWidget {
  const PhotoTakenScreen({super.key});

  @override
  ConsumerState<PhotoTakenScreen> createState() => _PhotoTakenScreenState();
}

class _PhotoTakenScreenState extends ConsumerState<PhotoTakenScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _celebrationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  bool _hasSavedToSandbox = false;

  @override
  void initState() {
    super.initState();

    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _celebrationController,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _celebrationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _celebrationController.forward();

    // Save to app sandbox after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveToSandbox();
    });
  }

  Future<void> _saveToSandbox() async {
    if (_hasSavedToSandbox) return;
    _hasSavedToSandbox = true;

    final photoPath = ModalRoute.of(context)?.settings.arguments as String?;
    if (photoPath == null) return;

    try {
      final file = File(photoPath);
      final bytes = await file.readAsBytes();
      final filename = 'kidcam_${DateTime.now().millisecondsSinceEpoch}.png';

      final storage = ref.read(localStorageProvider);
      final savedFile = await storage.saveToAppSandbox(bytes, filename);

      // Index in SQLite
      final selectedFilter = ref.read(selectedFilterProvider);
      final mediaDb = ref.read(mediaIndexDbProvider);
      await mediaDb.insert(CapturedMedia(
        id: const Uuid().v4(),
        filename: filename,
        filterId: selectedFilter.id,
        capturedAt: DateTime.now(),
        fileSizeBytes: await savedFile.length(),
      ));
    } catch (_) {
      // Don't crash the celebration screen on save failure
    }
  }

  Future<void> _saveToPhotoLibrary() async {
    final photoPath = ModalRoute.of(context)?.settings.arguments as String?;
    if (photoPath == null) return;

    final settings = ref.read(settingsProvider);
    if (!settings.saveToPhotos) return;

    HapticFeedback.lightImpact();

    try {
      final file = File(photoPath);
      final bytes = await file.readAsBytes();
      final storage = ref.read(localStorageProvider);

      final success = await storage.saveToPhotoLibrary(
        bytes,
        parentHasEnabledSaving: true,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Saved to Photos!' : 'Could not save.'),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save to Photos.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photoPath = ModalRoute.of(context)?.settings.arguments as String?;
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Photo preview (full screen)
          if (photoPath != null)
            Image.file(
              File(photoPath),
              fit: BoxFit.cover,
            ),

          // Dark overlay for text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
                stops: const [0.5, 1.0],
              ),
            ),
          ),

          // Celebration content
          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // "Awesome!" text with celebration animation
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: const Text(
                      'Awesome!',
                      style: AppFonts.celebrationText,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Star burst emoji row
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: const Text(
                    '\u{2B50} \u{2728} \u{1F31F} \u{2728} \u{2B50}',
                    style: TextStyle(fontSize: 28),
                  ),
                ),

                const SizedBox(height: 40),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Keep Playing button
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Keep Playing'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.skyBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    // Save button (only if parent enabled)
                    if (settings.saveToPhotos) ...[
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _saveToPhotoLibrary,
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Save'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mintGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
