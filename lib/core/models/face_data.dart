import 'dart:ui';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// Processed face tracking data extracted from ML Kit.
///
/// This model normalizes ML Kit's [Face] into a clean interface
/// for the filter renderer and expression detector to consume.
class FaceData {
  final Rect boundingBox;
  final Map<FaceLandmarkType, FaceLandmark?> landmarks;
  final double smileProbability;
  final double leftEyeOpenProbability;
  final double rightEyeOpenProbability;
  final double headEulerAngleY; // Left/right head rotation
  final double headEulerAngleX; // Up/down head tilt
  final double headEulerAngleZ; // Head tilt (ear to shoulder)
  final int? trackingId;

  const FaceData({
    required this.boundingBox,
    required this.landmarks,
    required this.smileProbability,
    required this.leftEyeOpenProbability,
    required this.rightEyeOpenProbability,
    required this.headEulerAngleY,
    required this.headEulerAngleX,
    this.headEulerAngleZ = 0.0,
    this.trackingId,
  });

  factory FaceData.fromMLKitFace(Face face) {
    return FaceData(
      boundingBox: face.boundingBox,
      landmarks: face.landmarks,
      smileProbability: face.smilingProbability ?? 0.0,
      leftEyeOpenProbability: face.leftEyeOpenProbability ?? 1.0,
      rightEyeOpenProbability: face.rightEyeOpenProbability ?? 1.0,
      headEulerAngleY: face.headEulerAngleY ?? 0.0,
      headEulerAngleX: face.headEulerAngleX ?? 0.0,
      headEulerAngleZ: face.headEulerAngleZ ?? 0.0,
      trackingId: face.trackingId,
    );
  }

  /// Whether the person is smiling (threshold: 0.7 probability).
  bool get isSmiling => smileProbability > 0.7;

  /// Whether the left eye is closed (wink detection).
  bool get isLeftEyeClosed => leftEyeOpenProbability < 0.3;

  /// Whether the right eye is closed (wink detection).
  bool get isRightEyeClosed => rightEyeOpenProbability < 0.3;

  /// Whether one eye is closed but not both (a wink, not a blink).
  bool get isWinking =>
      (isLeftEyeClosed && !isRightEyeClosed) ||
      (!isLeftEyeClosed && isRightEyeClosed);

  /// Whether the mouth appears to be open based on landmark positions.
  bool get isMouthOpen {
    final topMouth = landmarks[FaceLandmarkType.noseBase];
    final bottomMouth = landmarks[FaceLandmarkType.bottomMouth];
    if (topMouth == null || bottomMouth == null) return false;

    final distance = (bottomMouth.position.y - topMouth.position.y).abs();
    final faceHeight = boundingBox.height;
    // Mouth is "open" if the gap is more than 15% of face height
    return distance / faceHeight > 0.15;
  }

  bool get isLookingLeft => headEulerAngleY > 20;
  bool get isLookingRight => headEulerAngleY < -20;
  bool get isLookingUp => headEulerAngleX > 15;
  bool get isLookingDown => headEulerAngleX < -15;

  /// Get a specific landmark position as an Offset, or null.
  Offset? landmarkPosition(FaceLandmarkType type) {
    final landmark = landmarks[type];
    if (landmark == null) return null;
    return Offset(
      landmark.position.x.toDouble(),
      landmark.position.y.toDouble(),
    );
  }

  /// Face center point.
  Offset get center => boundingBox.center;

  /// Face width (used for scaling filter overlays).
  double get faceWidth => boundingBox.width;

  /// Face height.
  double get faceHeight => boundingBox.height;
}
