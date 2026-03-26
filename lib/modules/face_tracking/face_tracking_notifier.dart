import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/face_data.dart';
import 'face_detector_service.dart';

/// Riverpod notifier that holds the latest face tracking data.
///
/// Subscribes to the [FaceDetectorService] stream and exposes
/// the most recent [FaceData] to the widget tree.
class FaceTrackingNotifier extends AutoDisposeAsyncNotifier<FaceData?> {
  StreamSubscription<FaceData?>? _subscription;
  FaceData? _lastKnownFace;
  DateTime? _lastFaceTimestamp;

  /// Duration to keep the last known face position before hiding the filter.
  /// This prevents flickering when face detection briefly loses tracking.
  static const _facePersistDuration = Duration(seconds: 1);

  @override
  Future<FaceData?> build() async {
    final service = ref.watch(faceDetectorServiceProvider);

    _subscription = service.faceStream.listen((faceData) {
      if (faceData != null) {
        _lastKnownFace = faceData;
        _lastFaceTimestamp = DateTime.now();
        state = AsyncData(faceData);
      } else {
        // Face lost — keep the last known position briefly to avoid flicker
        if (_lastKnownFace != null && _lastFaceTimestamp != null) {
          final elapsed = DateTime.now().difference(_lastFaceTimestamp!);
          if (elapsed < _facePersistDuration) {
            state = AsyncData(_lastKnownFace);
            return;
          }
        }
        _lastKnownFace = null;
        state = const AsyncData(null);
      }
    });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return null;
  }
}

/// Provider for the face tracking state.
final faceTrackingProvider =
    AutoDisposeAsyncNotifierProvider<FaceTrackingNotifier, FaceData?>(
  FaceTrackingNotifier.new,
);
