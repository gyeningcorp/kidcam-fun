import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../core/models/face_data.dart';
import '../../core/models/filter_definition.dart';

/// Renders filter overlays on top of the camera preview.
///
/// Uses [CustomPainter] to draw filter layers anchored to face landmarks.
/// Supports preloaded images for smooth rendering at 30-60fps.
class FilterRendererWidget extends StatelessWidget {
  final FaceData? faceData;
  final FilterDefinition filter;
  final Size previewSize;
  final Map<String, ui.Image>? preloadedImages;

  const FilterRendererWidget({
    super.key,
    required this.faceData,
    required this.filter,
    required this.previewSize,
    this.preloadedImages,
  });

  @override
  Widget build(BuildContext context) {
    if (faceData == null) return const SizedBox.shrink();

    return CustomPaint(
      size: previewSize,
      painter: _FilterPainter(
        faceData: faceData!,
        filter: filter,
        previewSize: previewSize,
        images: preloadedImages ?? {},
      ),
    );
  }
}

class _FilterPainter extends CustomPainter {
  final FaceData faceData;
  final FilterDefinition filter;
  final Size previewSize;
  final Map<String, ui.Image> images;

  _FilterPainter({
    required this.faceData,
    required this.filter,
    required this.previewSize,
    required this.images,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final layer in filter.layers) {
      _drawLayer(canvas, size, layer);
    }
  }

  void _drawLayer(Canvas canvas, Size size, FilterLayer layer) {
    final anchor = _resolveAnchorPoint(layer.anchor);
    if (anchor == null) return;

    final faceWidth = faceData.boundingBox.width;
    final overlayWidth = faceWidth * layer.widthRatio;
    final overlayHeight = overlayWidth * layer.heightRatio;

    // Center the overlay on the anchor + fine-tune offset
    final left =
        anchor.dx - overlayWidth / 2 + layer.centerOffset.dx * faceWidth;
    final top =
        anchor.dy - overlayHeight / 2 + layer.centerOffset.dy * faceWidth;

    final destRect = Rect.fromLTWH(left, top, overlayWidth, overlayHeight);

    // Apply head rotation for natural filter movement
    final rotationAngle = faceData.headEulerAngleZ * 3.14159 / 180;
    canvas.save();
    canvas.translate(destRect.center.dx, destRect.center.dy);
    canvas.rotate(rotationAngle);
    canvas.translate(-destRect.center.dx, -destRect.center.dy);

    // Draw preloaded image if available, otherwise draw placeholder
    final image = images[layer.imageAsset];
    if (image != null) {
      final srcRect = Rect.fromLTWH(
        0,
        0,
        image.width.toDouble(),
        image.height.toDouble(),
      );
      canvas.drawImageRect(image, srcRect, destRect, Paint());
    } else {
      // Placeholder: draw a semi-transparent colored rect for development
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(destRect, const Radius.circular(8)),
        paint,
      );
    }

    canvas.restore();
  }

  Offset? _resolveAnchorPoint(FilterAnchor anchor) {
    final face = faceData;
    Offset? point;

    switch (anchor.landmarkType) {
      case 'topHead':
        point = Offset(
          face.boundingBox.center.dx,
          face.boundingBox.top,
        );
      case 'nose':
        point = _landmarkToOffset(FaceLandmarkType.noseBase);
      case 'leftEye':
        point = _landmarkToOffset(FaceLandmarkType.leftEye);
      case 'rightEye':
        point = _landmarkToOffset(FaceLandmarkType.rightEye);
      case 'mouth':
        point = _landmarkToOffset(FaceLandmarkType.bottomMouth);
      case 'leftCheek':
        point = _landmarkToOffset(FaceLandmarkType.leftCheek);
      case 'rightCheek':
        point = _landmarkToOffset(FaceLandmarkType.rightCheek);
      case 'face_center':
        point = face.boundingBox.center;
      default:
        point = face.boundingBox.center;
    }

    if (point == null) return null;

    // Apply the anchor's relative offset
    return Offset(
      point.dx + anchor.offset.dx * face.faceWidth,
      point.dy + anchor.offset.dy * face.faceWidth,
    );
  }

  Offset? _landmarkToOffset(FaceLandmarkType type) {
    final landmark = faceData.landmarks[type];
    if (landmark == null) return null;
    return Offset(
      landmark.position.x.toDouble(),
      landmark.position.y.toDouble(),
    );
  }

  @override
  bool shouldRepaint(_FilterPainter oldDelegate) =>
      oldDelegate.faceData != faceData || oldDelegate.filter != filter;
}

/// Preloads filter images for smooth rendering.
///
/// Call this when a filter is selected to ensure images are ready
/// before the first paint call.
class FilterImagePreloader {
  final Map<String, ui.Image> _cache = {};

  Map<String, ui.Image> get cache => Map.unmodifiable(_cache);

  /// Preload all image assets for a filter definition.
  Future<void> preloadFilter(FilterDefinition filter) async {
    for (final layer in filter.layers) {
      if (_cache.containsKey(layer.imageAsset)) continue;
      try {
        final image = await _loadImage(layer.imageAsset);
        if (image != null) {
          _cache[layer.imageAsset] = image;
        }
      } catch (_) {
        // Skip failed loads — placeholder will be drawn instead
      }
    }
  }

  Future<ui.Image?> _loadImage(String assetPath) async {
    // In production, use rootBundle to load the asset and decode
    // This is the integration point for real asset loading
    return null;
  }

  void dispose() {
    for (final image in _cache.values) {
      image.dispose();
    }
    _cache.clear();
  }
}
