/// Sound file path constants for KidCam Fun.
/// All sounds are local assets — no network fetching.
abstract final class AppSounds {
  static const String _base = 'assets/sounds';

  /// Playful "boing" when swiping between filters
  static const String filterSwitch = '$_base/filter_switch.mp3';

  /// Camera shutter + chime on photo capture
  static const String photoTaken = '$_base/photo_taken.mp3';

  /// Sparkle/twinkle when smile is detected
  static const String starsSparkle = '$_base/stars_sparkle.mp3';

  /// Celebration sound on photo taken screen
  static const String celebration = '$_base/celebration.mp3';

  /// Soft tap for UI button presses
  static const String buttonTap = '$_base/button_tap.mp3';

  /// Subtle unlock sound for parent gate
  static const String parentGateSuccess = '$_base/parent_gate_success.mp3';
}
