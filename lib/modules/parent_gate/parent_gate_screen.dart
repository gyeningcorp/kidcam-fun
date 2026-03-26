import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_fonts.dart';
import '../../core/utils/math_challenge.dart';
import 'parent_gate_service.dart';

/// Parent gate screen with math challenge and number pad.
///
/// A friendly character asks a simple addition question.
/// Big number buttons for fat-finger accuracy on tablets.
/// 3 wrong attempts triggers 60-second cooldown.
class ParentGateScreen extends ConsumerStatefulWidget {
  const ParentGateScreen({super.key});

  @override
  ConsumerState<ParentGateScreen> createState() => _ParentGateScreenState();
}

class _ParentGateScreenState extends ConsumerState<ParentGateScreen> {
  late MathChallenge _challenge;
  String _enteredAnswer = '';
  bool _showError = false;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _challenge = MathChallenge.fresh();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _onNumberTap(int number) {
    setState(() {
      _enteredAnswer += number.toString();
      _showError = false;
    });

    // Auto-submit when answer length matches expected answer length
    if (_enteredAnswer.length >= _challenge.answer.toString().length) {
      _submitAnswer();
    }
  }

  void _onDelete() {
    if (_enteredAnswer.isNotEmpty) {
      setState(() {
        _enteredAnswer = _enteredAnswer.substring(0, _enteredAnswer.length - 1);
        _showError = false;
      });
    }
  }

  void _submitAnswer() {
    final gateService = ref.read(parentGateServiceProvider);

    if (gateService.attemptUnlock(_enteredAnswer, _challenge)) {
      Navigator.of(context).pushReplacementNamed('/parent_settings');
    } else {
      setState(() {
        _showError = true;
        _enteredAnswer = '';
        _challenge = MathChallenge.fresh();
      });

      if (gateService.isOnCooldown) {
        _startCooldownTimer();
      }
    }
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final gateService = ref.read(parentGateServiceProvider);
      if (!gateService.isOnCooldown) {
        _cooldownTimer?.cancel();
        setState(() {});
      } else {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gateService = ref.watch(parentGateServiceProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.parentGateBg, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded, size: 28),
                      color: AppColors.textLight,
                    ),
                    const Spacer(),
                    Text(
                      'Parent Area',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // Balance the close button
                  ],
                ),
              ),

              const Spacer(),

              // Friendly character + question
              const Text(
                '\u{1F916}',
                style: TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),

              if (gateService.isOnCooldown) ...[
                Text(
                  'Too many tries!',
                  style: AppFonts.parentGateQuestion.copyWith(
                    color: AppColors.cooldownRed,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try again in ${gateService.cooldownRemaining.inSeconds}s',
                  style: TextStyle(
                    fontFamily: AppFonts.primary,
                    fontWeight: AppFonts.bold,
                    fontSize: 18,
                    color: AppColors.textLight,
                  ),
                ),
              ] else ...[
                Text(
                  _challenge.question,
                  style: AppFonts.parentGateQuestion,
                ),
                const SizedBox(height: 24),

                // Answer display
                Container(
                  width: 120,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _showError ? AppColors.cooldownRed : AppColors.skyBlue,
                      width: 3,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _enteredAnswer.isEmpty ? '?' : _enteredAnswer,
                    style: AppFonts.parentGateQuestion.copyWith(
                      color: _enteredAnswer.isEmpty
                          ? AppColors.textLight
                          : AppColors.textDark,
                    ),
                  ),
                ),

                if (_showError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Not quite! Try again.',
                      style: TextStyle(
                        fontFamily: AppFonts.primary,
                        fontWeight: AppFonts.bold,
                        fontSize: 14,
                        color: AppColors.cooldownRed,
                      ),
                    ),
                  ),
              ],

              const Spacer(),

              // Number pad
              if (!gateService.isOnCooldown) _buildNumberPad(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          // Row 1: 1-3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _numberButton(1),
              _numberButton(2),
              _numberButton(3),
            ],
          ),
          const SizedBox(height: 12),
          // Row 2: 4-6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _numberButton(4),
              _numberButton(5),
              _numberButton(6),
            ],
          ),
          const SizedBox(height: 12),
          // Row 3: 7-9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _numberButton(7),
              _numberButton(8),
              _numberButton(9),
            ],
          ),
          const SizedBox(height: 12),
          // Row 4: delete, 0
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _actionButton(
                icon: Icons.backspace_rounded,
                onTap: _onDelete,
              ),
              _numberButton(0),
              const SizedBox(width: 72, height: 72), // Spacer
            ],
          ),
        ],
      ),
    );
  }

  Widget _numberButton(int number) {
    return GestureDetector(
      onTap: () => _onNumberTap(number),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '$number',
          style: AppFonts.numberPadButton,
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.background,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 28, color: AppColors.textLight),
      ),
    );
  }
}
