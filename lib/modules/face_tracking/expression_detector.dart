import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/face_data.dart';
import 'face_tracking_notifier.dart';

/// Detected facial expression events.
enum ExpressionEvent {
  /// Smile detected (probability > 0.7)
  smile,

  /// One eye closed, other open
  wink,

  /// Mouth appears open (landmark distance check)
  mouthOpen,

  /// No notable expression
  neutral,
}

/// Detects facial expressions from [FaceData] and emits [ExpressionEvent]s.
///
/// Includes debouncing to prevent rapid-fire event triggers —
/// an expression must be held for a minimum duration before firing.
class ExpressionDetector extends AutoDisposeNotifier<ExpressionEvent> {
  ExpressionEvent _lastEvent = ExpressionEvent.neutral;
  DateTime _lastEventTime = DateTime.now();

  /// Minimum time an expression must be held before triggering.
  static const _debounceTime = Duration(milliseconds: 300);

  /// Cooldown after an expression fires before it can fire again.
  static const _cooldown = Duration(seconds: 2);

  @override
  ExpressionEvent build() {
    ref.listen(faceTrackingProvider, (_, next) {
      next.whenData((faceData) {
        if (faceData == null) {
          _updateState(ExpressionEvent.neutral);
          return;
        }
        _detectExpression(faceData);
      });
    });
    return ExpressionEvent.neutral;
  }

  void _detectExpression(FaceData face) {
    final now = DateTime.now();

    // Determine the current expression
    ExpressionEvent detected;
    if (face.isSmiling) {
      detected = ExpressionEvent.smile;
    } else if (face.isWinking) {
      detected = ExpressionEvent.wink;
    } else if (face.isMouthOpen) {
      detected = ExpressionEvent.mouthOpen;
    } else {
      detected = ExpressionEvent.neutral;
    }

    // Debounce: only fire if the same expression is held for _debounceTime
    if (detected != _lastEvent) {
      _lastEvent = detected;
      _lastEventTime = now;
      return;
    }

    // Check if held long enough and cooldown has passed
    final heldDuration = now.difference(_lastEventTime);
    if (heldDuration >= _debounceTime) {
      _updateState(detected);
    }
  }

  void _updateState(ExpressionEvent event) {
    if (event == state && event != ExpressionEvent.neutral) return;
    state = event;
  }
}

/// Provider for expression detection.
final expressionDetectorProvider =
    AutoDisposeNotifierProvider<ExpressionDetector, ExpressionEvent>(
  ExpressionDetector.new,
);
