import 'dart:io';

/// Performance tiers for adaptive rendering quality.
///
/// The app adjusts face detection frequency and filter complexity
/// based on the device's capabilities to ensure smooth performance.
enum DeviceTier {
  /// 2022+ flagship: Full face mesh, expression detection, 60fps
  high,

  /// 2020+ mid-range: Face landmarks, smile detection, 30fps
  mid,

  /// Pre-2019: Static filter at face bounding box only, 24fps
  low,
}

/// Detects the device's performance tier for adaptive rendering.
class DeviceTierDetector {
  /// Detect the current device's performance tier.
  ///
  /// Uses available system memory as the primary heuristic.
  /// On iOS, also considers device model for known tiers.
  static DeviceTier detect() {
    final ramGB = _estimateRamGB();

    if (ramGB >= 6) return DeviceTier.high;
    if (ramGB >= 4) return DeviceTier.mid;
    return DeviceTier.low;
  }

  /// Get the target frame rate for face detection on this tier.
  static int targetFps(DeviceTier tier) {
    switch (tier) {
      case DeviceTier.high:
        return 60;
      case DeviceTier.mid:
        return 30;
      case DeviceTier.low:
        return 24;
    }
  }

  /// Whether expression detection should be enabled on this tier.
  static bool supportsExpressionDetection(DeviceTier tier) {
    return tier != DeviceTier.low;
  }

  /// Whether full face landmarks should be used (vs. bounding box only).
  static bool supportsFullLandmarks(DeviceTier tier) {
    return tier != DeviceTier.low;
  }

  /// Rough RAM estimate from platform info.
  ///
  /// This is a best-effort heuristic. On real devices, consider
  /// using device_info_plus for more accurate detection.
  static double _estimateRamGB() {
    try {
      if (Platform.isAndroid) {
        // Android: /proc/meminfo gives total memory
        final memInfo = File('/proc/meminfo').readAsStringSync();
        final match = RegExp(r'MemTotal:\s+(\d+)').firstMatch(memInfo);
        if (match != null) {
          final kB = int.parse(match.group(1)!);
          return kB / 1024 / 1024; // Convert KB to GB
        }
      }
      // iOS doesn't expose /proc; default to mid tier.
      // In production, use device_info_plus to check device model.
      return 4.0;
    } catch (_) {
      return 4.0; // Safe default: mid tier
    }
  }
}
