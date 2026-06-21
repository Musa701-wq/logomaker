import 'package:flutter/material.dart';

class TextLabelPattern {
  final String fontFamily;
  final FontWeight fontWeight;
  final Color color;       // always white
  final double fontSize;
  final double letterSpacing;
  final Color outlineColor; // changes per pattern
  final double outlineWidth;
  final Color glowColor;
  final double glowRadius;
  final Offset position;

  const TextLabelPattern({
    required this.fontFamily,
    required this.fontWeight,
    required this.color,
    required this.fontSize,
    required this.letterSpacing,
    required this.outlineColor,
    required this.outlineWidth,
    required this.glowColor,
    required this.glowRadius,
    required this.position,
  });
}

const List<TextLabelPattern> kTextLabelPatterns = [
  // 0 — Teal outline
  TextLabelPattern(
    fontFamily: 'Oswald',
    fontWeight: FontWeight.w900,
    color: Colors.white,
    fontSize: 28,
    letterSpacing: 3.0,
    outlineColor: Color(0xFF008080),
    outlineWidth: 2.5,
    glowColor: Color(0xFF008080),
    glowRadius: 8,
    position: Offset(20, 270),
  ),
  // 1 — Red outline
  TextLabelPattern(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w800,
    color: Colors.white,
    fontSize: 26,
    letterSpacing: 2.0,
    outlineColor: Color(0xFFE74C3C),
    outlineWidth: 2.5,
    glowColor: Color(0xFFE74C3C),
    glowRadius: 8,
    position: Offset(18, 268),
  ),
  // 2 — Purple outline
  TextLabelPattern(
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontSize: 26,
    letterSpacing: 1.5,
    outlineColor: Color(0xFF9B59B6),
    outlineWidth: 2.5,
    glowColor: Color(0xFF9B59B6),
    glowRadius: 8,
    position: Offset(20, 272),
  ),
  // 3 — Blue outline
  TextLabelPattern(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w900,
    color: Colors.white,
    fontSize: 24,
    letterSpacing: 2.5,
    outlineColor: Color(0xFF2980B9),
    outlineWidth: 2.5,
    glowColor: Color(0xFF2980B9),
    glowRadius: 8,
    position: Offset(16, 265),
  ),
  // 4 — Orange outline
  TextLabelPattern(
    fontFamily: 'Josefin Sans',
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontSize: 26,
    letterSpacing: 3.0,
    outlineColor: Color(0xFFE67E22),
    outlineWidth: 2.5,
    glowColor: Color(0xFFE67E22),
    glowRadius: 8,
    position: Offset(20, 268),
  ),
  // 5 — Green outline
  TextLabelPattern(
    fontFamily: 'Nunito',
    fontWeight: FontWeight.w900,
    color: Colors.white,
    fontSize: 28,
    letterSpacing: 1.0,
    outlineColor: Color(0xFF27AE60),
    outlineWidth: 2.5,
    glowColor: Color(0xFF27AE60),
    glowRadius: 8,
    position: Offset(18, 272),
  ),
  // 6 — Pink outline
  TextLabelPattern(
    fontFamily: 'Space Grotesk',
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontSize: 26,
    letterSpacing: 2.0,
    outlineColor: Color(0xFFFF4081),
    outlineWidth: 2.5,
    glowColor: Color(0xFFFF4081),
    glowRadius: 8,
    position: Offset(20, 264),
  ),
  // 7 — Yellow outline
  TextLabelPattern(
    fontFamily: 'Manrope',
    fontWeight: FontWeight.w800,
    color: Colors.white,
    fontSize: 26,
    letterSpacing: 1.5,
    outlineColor: Color(0xFFF1C40F),
    outlineWidth: 2.5,
    glowColor: Color(0xFFF1C40F),
    glowRadius: 8,
    position: Offset(22, 270),
  ),
  // 8 — Light blue outline
  TextLabelPattern(
    fontFamily: 'Bangers',
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontSize: 32,
    letterSpacing: 4.0,
    outlineColor: Color(0xFF00BCD4),
    outlineWidth: 2.5,
    glowColor: Color(0xFF00BCD4),
    glowRadius: 8,
    position: Offset(16, 260),
  ),
  // 9 — Deep red/crimson outline
  TextLabelPattern(
    fontFamily: 'Russo One',
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontSize: 26,
    letterSpacing: 2.0,
    outlineColor: Color(0xFFC0392B),
    outlineWidth: 2.5,
    glowColor: Color(0xFFC0392B),
    glowRadius: 8,
    position: Offset(20, 268),
  ),
];

/// Deterministic pattern index from any string key
int patternIndexFor(String key) {
  int hash = 0;
  for (final c in key.codeUnits) {
    hash = (hash * 31 + c) & 0x7FFFFFFF;
  }
  return hash % kTextLabelPatterns.length;
}

TextLabelPattern patternFor(String key) =>
    kTextLabelPatterns[patternIndexFor(key)];
