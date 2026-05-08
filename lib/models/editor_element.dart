import 'package:flutter/material.dart';

enum ElementType { text, image, shape }

class EditorElement {
  final String id;
  final ElementType type;
  Offset position;
  String content;
  double scale;
  double rotation;
  double rotateX;
  double rotateY;
  double opacity;
  Color glowColor;
  double glowRadius;
  Color outlineColor;
  double outlineWidth;
  double brightness;
  double contrast;
  double saturation;
  double exposure;
  double hue;
  double sepia;
  double blur;
  double borderRadius;
  List<Color>? shapeGradient;
  double shadowBlur;
  Color shadowColor;
  List<double>? filterMatrix;
  Color? color;
  String? fontFamily;
  FontWeight? fontWeight;
  FontStyle? fontStyle;
  double? fontSize;
  double letterSpacing;
  double lineHeight;
  TextAlign textAlign;
  double curveAngle;

  EditorElement({
    required this.id,
    required this.type,
    required this.position,
    required this.content,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.rotateX = 0.0,
    this.rotateY = 0.0,
    this.opacity = 1.0,
    this.glowColor = Colors.transparent,
    this.glowRadius = 0.0,
    this.outlineColor = Colors.transparent,
    this.outlineWidth = 0.0,
    this.brightness = 0,
    this.contrast = 1,
    this.saturation = 1,
    this.exposure = 0,
    this.hue = 0,
    this.sepia = 0,
    this.blur = 0,
    this.borderRadius = 0,
    this.shapeGradient,
    this.shadowBlur = 0,
    this.shadowColor = Colors.transparent,
    this.filterMatrix,
    this.color,
    this.fontFamily,
    this.fontWeight,
    this.fontStyle,
    this.fontSize,
    this.letterSpacing = 0.0,
    this.lineHeight = 1.0,
    this.textAlign = TextAlign.center,
    this.curveAngle = 0.0,
  });

  // ── Serialization ──

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.index,
    'px': position.dx,
    'py': position.dy,
    'content': content,
    'scale': scale,
    'rotation': rotation,
    'rotateX': rotateX,
    'rotateY': rotateY,
    'opacity': opacity,
    'glowColor': glowColor.value,
    'glowRadius': glowRadius,
    'outlineColor': outlineColor.value,
    'outlineWidth': outlineWidth,
    'brightness': brightness,
    'contrast': contrast,
    'saturation': saturation,
    'exposure': exposure,
    'hue': hue,
    'sepia': sepia,
    'blur': blur,
    'borderRadius': borderRadius,
    'shapeGradient': shapeGradient?.map((c) => c.value).toList(),
    'shadowBlur': shadowBlur,
    'shadowColor': shadowColor.value,
    'filterMatrix': filterMatrix,
    'color': color?.value,
    'fontFamily': fontFamily,
    'fontWeight': fontWeight?.value,
    'fontStyle': fontStyle?.index,
    'fontSize': fontSize,
    'letterSpacing': letterSpacing,
    'lineHeight': lineHeight,
    'textAlign': textAlign.index,
    'curveAngle': curveAngle,
  };

  factory EditorElement.fromJson(Map<String, dynamic> j) => EditorElement(
    id: j['id'] as String,
    type: ElementType.values[j['type'] as int],
    position: Offset((j['px'] as num).toDouble(), (j['py'] as num).toDouble()),
    content: j['content'] as String,
    scale: (j['scale'] as num).toDouble(),
    rotation: (j['rotation'] as num).toDouble(),
    rotateX: (j['rotateX'] as num).toDouble(),
    rotateY: (j['rotateY'] as num).toDouble(),
    opacity: (j['opacity'] as num).toDouble(),
    glowColor: Color(j['glowColor'] as int),
    glowRadius: (j['glowRadius'] as num).toDouble(),
    outlineColor: Color(j['outlineColor'] as int),
    outlineWidth: (j['outlineWidth'] as num).toDouble(),
    brightness: (j['brightness'] as num).toDouble(),
    contrast: (j['contrast'] as num).toDouble(),
    saturation: (j['saturation'] as num).toDouble(),
    exposure: (j['exposure'] as num).toDouble(),
    hue: (j['hue'] as num).toDouble(),
    sepia: (j['sepia'] as num).toDouble(),
    blur: (j['blur'] as num).toDouble(),
    borderRadius: (j['borderRadius'] as num).toDouble(),
    shapeGradient: (j['shapeGradient'] as List?)?.map((v) => Color(v as int)).toList(),
    shadowBlur: (j['shadowBlur'] as num).toDouble(),
    shadowColor: Color(j['shadowColor'] as int),
    filterMatrix: (j['filterMatrix'] as List?)?.map((v) => (v as num).toDouble()).toList(),
    color: j['color'] != null ? Color(j['color'] as int) : null,
    fontFamily: j['fontFamily'] as String?,
    fontWeight: j['fontWeight'] != null ? [FontWeight.w100, FontWeight.w200, FontWeight.w300, FontWeight.w400, FontWeight.w500, FontWeight.w600, FontWeight.w700, FontWeight.w800, FontWeight.w900].firstWhere((w) => w.value == j['fontWeight'], orElse: () => FontWeight.normal) : null,
    fontStyle: j['fontStyle'] != null ? FontStyle.values[j['fontStyle'] as int] : null,
    fontSize: j['fontSize'] != null ? (j['fontSize'] as num).toDouble() : null,
    letterSpacing: (j['letterSpacing'] as num).toDouble(),
    lineHeight: (j['lineHeight'] as num).toDouble(),
    textAlign: TextAlign.values[j['textAlign'] as int],
    curveAngle: (j['curveAngle'] as num).toDouble(),
  );

  EditorElement copyWith({
    String? id,
    ElementType? type,
    Offset? position,
    String? content,
    double? scale,
    double? rotation,
    double? rotateX,
    double? rotateY,
    double? opacity,
    Color? glowColor,
    double? glowRadius,
    Color? outlineColor,
    double? outlineWidth,
    double? brightness,
    double? contrast,
    double? saturation,
    double? exposure,
    double? hue,
    double? sepia,
    double? blur,
    double? borderRadius,
    List<Color>? shapeGradient,
    double? shadowBlur,
    Color? shadowColor,
    List<double>? filterMatrix,
    Color? color,
    String? fontFamily,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize,
    double? letterSpacing,
    double? lineHeight,
    TextAlign? textAlign,
    double? curveAngle,
  }) {
    return EditorElement(
      id: id ?? this.id,
      type: type ?? this.type,
      position: position ?? this.position,
      content: content ?? this.content,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      rotateX: rotateX ?? this.rotateX,
      rotateY: rotateY ?? this.rotateY,
      opacity: opacity ?? this.opacity,
      glowColor: glowColor ?? this.glowColor,
      glowRadius: glowRadius ?? this.glowRadius,
      outlineColor: outlineColor ?? this.outlineColor,
      outlineWidth: outlineWidth ?? this.outlineWidth,
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      saturation: saturation ?? this.saturation,
      exposure: exposure ?? this.exposure,
      hue: hue ?? this.hue,
      sepia: sepia ?? this.sepia,
      blur: blur ?? this.blur,
      borderRadius: borderRadius ?? this.borderRadius,
      shapeGradient: shapeGradient ?? this.shapeGradient,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowColor: shadowColor ?? this.shadowColor,
      filterMatrix: filterMatrix ?? this.filterMatrix,
      color: color ?? this.color,
      fontFamily: fontFamily ?? this.fontFamily,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      fontSize: fontSize ?? this.fontSize,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      lineHeight: lineHeight ?? this.lineHeight,
      textAlign: textAlign ?? this.textAlign,
      curveAngle: curveAngle ?? this.curveAngle,
    );
  }
}
