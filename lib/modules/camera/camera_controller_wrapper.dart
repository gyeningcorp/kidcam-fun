import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the camera lifecycle: initialization, pause/resume, disposal.
///
/// Selects the front camera by default (kids want to see themselves).
/// Handles permission checking and camera availability gracefully.
class CameraControllerWrapper extends ChangeNotifier {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  String? _errorMessage;

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;

  /// Initialize the camera, preferring the front-facing camera.
  Future<void> initialize() async {
    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        _errorMessage = 'No cameras found on this device.';
        notifyListeners();
        return;
      }

      // Prefer front camera — kids want to see their own face
      final frontCamera = _cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false, // No audio needed for photos
        imageFormatGroup: ImageFormatGroup.bgra8888,
      );

      await _controller!.initialize();
      _isInitialized = true;
      _errorMessage = null;
      notifyListeners();
    } on CameraException catch (e) {
      _errorMessage = _friendlyError(e);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Could not start the camera. Please try again.';
      notifyListeners();
    }
  }

  /// Start streaming camera frames for face detection.
  Future<void> startImageStream(
    void Function(CameraImage image) onImage,
  ) async {
    if (_controller == null || !_isInitialized) return;
    await _controller!.startImageStream(onImage);
  }

  /// Stop the camera frame stream.
  Future<void> stopImageStream() async {
    if (_controller == null || !_isInitialized) return;
    try {
      await _controller!.stopImageStream();
    } catch (_) {
      // Stream might not be active — safe to ignore
    }
  }

  /// Capture a photo and return the file path.
  Future<XFile?> capturePhoto() async {
    if (_controller == null || !_isInitialized) return null;
    if (_controller!.value.isTakingPicture) return null;

    try {
      return await _controller!.takePicture();
    } on CameraException {
      return null;
    }
  }

  /// Pause the camera (e.g., when app goes to background).
  Future<void> pause() async {
    if (_controller == null || !_isInitialized) return;
    await stopImageStream();
    await _controller!.pausePreview();
  }

  /// Resume the camera after a pause.
  Future<void> resume() async {
    if (_controller == null || !_isInitialized) return;
    await _controller!.resumePreview();
  }

  /// Clean up camera resources.
  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    _isInitialized = false;
    super.dispose();
  }

  String _friendlyError(CameraException e) {
    switch (e.code) {
      case 'CameraAccessDenied':
      case 'CameraAccessDeniedWithoutPrompt':
      case 'CameraAccessRestricted':
        return 'Camera permission is needed to use filters!';
      default:
        return 'Oops! The camera had a problem. Please try again.';
    }
  }
}

/// Riverpod provider for the camera controller.
final cameraControllerProvider =
    ChangeNotifierProvider.autoDispose<CameraControllerWrapper>((ref) {
  final wrapper = CameraControllerWrapper();
  ref.onDispose(() => wrapper.dispose());
  return wrapper;
});
