import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/math_challenge.dart';

/// Service that controls parent gate unlock state.
///
/// The parent gate uses a simple math challenge to prevent kids from
/// accessing settings. After 3 failed attempts, a 60-second cooldown
/// is enforced to prevent brute-forcing.
///
/// The gate state is in-memory only — it resets when the app restarts,
/// which is the intended behavior (no persistent unlock).
class ParentGateService extends ChangeNotifier {
  int _failedAttempts = 0;
  DateTime? _cooldownUntil;
  bool _isUnlocked = false;

  /// Whether the gate is currently in cooldown after failed attempts.
  bool get isOnCooldown =>
      _cooldownUntil != null && DateTime.now().isBefore(_cooldownUntil!);

  /// Time remaining in cooldown, or zero if not in cooldown.
  Duration get cooldownRemaining =>
      isOnCooldown ? _cooldownUntil!.difference(DateTime.now()) : Duration.zero;

  /// Number of failed attempts in the current cycle (resets after cooldown or success).
  int get failedAttempts => _failedAttempts;

  /// Whether the parent area is currently unlocked.
  bool get isUnlocked => _isUnlocked;

  /// Attempt to unlock the parent gate with a math challenge answer.
  ///
  /// Returns true if the answer is correct.
  /// After 3 failures, enforces a 60-second cooldown.
  bool attemptUnlock(String answer, MathChallenge challenge) {
    if (isOnCooldown) return false;

    if (challenge.verify(answer)) {
      _failedAttempts = 0;
      _isUnlocked = true;
      notifyListeners();
      return true;
    }

    _failedAttempts++;
    if (_failedAttempts >= 3) {
      _cooldownUntil = DateTime.now().add(const Duration(seconds: 60));
      _failedAttempts = 0;
    }
    notifyListeners();
    return false;
  }

  /// Lock the parent area (e.g., when navigating away from settings).
  void lock() {
    _isUnlocked = false;
    notifyListeners();
  }
}

/// Riverpod provider for the parent gate service.
final parentGateServiceProvider =
    ChangeNotifierProvider<ParentGateService>((_) => ParentGateService());
