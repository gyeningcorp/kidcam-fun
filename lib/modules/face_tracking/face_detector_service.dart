import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../core/models/face_data.dart';

/// Real-time face detection service using Google ML Kit.
///
/// Processes camera frames and emits [FaceData] through a broadcast stream.
/// Drops frames if still processing the previous one to maintain performance.
/// Uses the largest detected face (closest to camera = the child).
class FaceDetectorService {
  late final FaceDetector _detector;
  bool _isProcessing = false;

  FaceDetectorService() {
    _detector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true,
        enableClassification: true,
        enableTracking: true,
        minFaceSize: 0.15,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

  final StreamController<FaceData?> _faceDataController =
      StreamController<FaceData?>.broadcast();

  /// Stream of face tracking data. Emits null when no face is detected.
  Stream<FaceData?> get faceStream => _faceDataController.stream;

  /// Process a single camera frame for face detection.
  ///
  /// Frames are dropped if the previous frame is still being processed,
  /// ensuring we don't build up a backlog on slower devices.
  Future<void> processFrame(
    CameraImage image,
    InputImageRotation rotation,
  ) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      final inputImage = _buildInputImage(image, rotation);
      final faces = await _detector.processImage(inputImage);

      if (faces.isEmpty) {
        _faceDataController.add(null);
      } else {
        // Use the largest face — the one closest to the camera (the child)
        final primaryFace = faces.reduce(
          (a, b) => a.boundingBox.width > b.boundingBox.width ? a : b,
        );
        _faceDataController.add(FaceData.fromMLKitFace(primaryFace));
      }
    } catch (_) {
      // Silently drop failed frames — don't crash the camera experience
    } finally {
      _isProcessing = false;
    }
  }

  /// Build an [InputImage] from a [CameraImage] frame.
  InputImage _buildInputImage(
    CameraImage image,
    InputImageRotation rotation,
  ) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return InputImage.fromBytes(
      bytes: allBytes.done().buffer.asUint8List(),
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.bgra8888,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  /// Release all resources.
  void dispose() {
    _detector.close();
    _faceDataController.close();
  }
}

/// Riverpod provider for the face detection service.
final faceDetectorServiceProvider = Provider<FaceDetectorService>((ref) {
  final service = FaceDetectorService();
  ref.onDispose(() => service.dispose());
  return service;
});
