import 'dart:math';

/// A simple addition math challenge used for the parent gate.
///
/// Generates two random single-digit numbers (1-9) and requires
/// their sum as the answer. Randomized each time to prevent kids
/// from memorizing the answer.
class MathChallenge {
  final int a;
  final int b;
  final int answer;

  MathChallenge._internal(this.a, this.b, this.answer);

  /// Generate a fresh random math challenge.
  factory MathChallenge.fresh() {
    final random = Random();
    final a = random.nextInt(9) + 1; // 1-9
    final b = random.nextInt(9) + 1; // 1-9
    return MathChallenge._internal(a, b, a + b);
  }

  /// The question string displayed to the parent.
  String get question => '$a + $b = ?';

  /// Verify whether the entered answer is correct.
  bool verify(String input) {
    final entered = int.tryParse(input.trim());
    return entered == answer;
  }
}
