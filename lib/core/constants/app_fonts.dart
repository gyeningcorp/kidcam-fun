import 'package:flutter/material.dart';

/// Font constants for KidCam Fun — Nunito for a rounded, friendly feel.
abstract final class AppFonts {
  static const String primary = 'Nunito';

  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  /// Pre-built text styles for common use outside the theme.
  static const TextStyle playButton = TextStyle(
    fontFamily: primary,
    fontWeight: extraBold,
    fontSize: 28,
    color: Color(0xFF37474F),
  );

  static const TextStyle filterLabel = TextStyle(
    fontFamily: primary,
    fontWeight: bold,
    fontSize: 12,
    color: Colors.white,
  );

  static const TextStyle celebrationText = TextStyle(
    fontFamily: primary,
    fontWeight: extraBold,
    fontSize: 36,
    color: Colors.white,
    shadows: [
      Shadow(
        offset: Offset(0, 2),
        blurRadius: 8,
        color: Color(0x40000000),
      ),
    ],
  );

  static const TextStyle parentGateQuestion = TextStyle(
    fontFamily: primary,
    fontWeight: extraBold,
    fontSize: 32,
    color: Color(0xFF37474F),
  );

  static const TextStyle numberPadButton = TextStyle(
    fontFamily: primary,
    fontWeight: extraBold,
    fontSize: 28,
    color: Color(0xFF37474F),
  );
}
