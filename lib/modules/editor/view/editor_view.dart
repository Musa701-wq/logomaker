import 'dart:io';
import 'dart:ui';
import 'dart:math' as dart_math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import '../../../app/utils/color_constants.dart';
import '../../../models/editor_element.dart';
import '../view_model/editor_view_model.dart';

class DottedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.05);
    const double spacing = 20.0;
    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), 0.7, paint);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CustomShapeClipper extends CustomClipper<Path> {
  final String shapeType;
  _CustomShapeClipper(this.shapeType);

  @override
  Path getClip(Size size) {
    Path path = Path();
    double w = size.width;
    double h = size.height;

    switch (shapeType) {
      case 'triangle':
        path.moveTo(w / 2, 0);
        path.lineTo(w, h);
        path.lineTo(0, h);
        path.close();
        break;
      case 'star':
        path.moveTo(w / 2, 0);
        path.lineTo(w * 0.61, h * 0.35);
        path.lineTo(w * 0.98, h * 0.35);
        path.lineTo(w * 0.68, h * 0.57);
        path.lineTo(w * 0.79, h * 0.91);
        path.lineTo(w / 2, h * 0.70);
        path.lineTo(w * 0.21, h * 0.91);
        path.lineTo(w * 0.32, h * 0.57);
        path.lineTo(w * 0.02, h * 0.35);
        path.lineTo(w * 0.39, h * 0.35);
        path.close();
        break;
      case 'hexagon':
        path.moveTo(w * 0.25, 0);
        path.lineTo(w * 0.75, 0);
        path.lineTo(w, h * 0.5);
        path.lineTo(w * 0.75, h);
        path.lineTo(w * 0.25, h);
        path.lineTo(0, h * 0.5);
        path.close();
        break;
      case 'pentagon':
        path.moveTo(w / 2, 0);
        path.lineTo(w, h * 0.38);
        path.lineTo(w * 0.82, h);
        path.lineTo(w * 0.18, h);
        path.lineTo(0, h * 0.38);
        path.close();
        break;
      case 'heart':
        path.moveTo(w / 2, h / 4);
        path.cubicTo(w / 4, 0, 0, h / 4, w / 2, h);
        path.moveTo(w / 2, h / 4);
        path.cubicTo(w * 3 / 4, 0, w, h / 4, w / 2, h);
        break;
      default:
        path.addRect(Rect.fromLTWH(0, 0, w, h));
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class EditorView extends GetView<EditorViewModel> {
  const EditorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.premiumDark,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Obx(() {
                final isEditing = controller.isEditingText.value;
                return Stack(
                  children: [
                    // Canvas - always visible, positioned at top
                    Positioned(
                      top: 0, left: 0, right: 0,
                      bottom: isEditing ? 0 : null,
                      child: _buildCanvasArea(),
                    ),
                    // Bottom panel - hidden when keyboard is open
                    if (!isEditing) _buildContextualBottomPanel(),
                  ],
                );
              }),
            ),
            Obx(() => controller.isEditingText.value
                ? const SizedBox.shrink()
                : _buildBottomNavBar()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20.sp),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Luminous Atelier',
                  style: GoogleFonts.outfit(
                    color: AppColors.accentPurpleBtn,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'UNTITLED LOGO',
                  style: GoogleFonts.outfit(
                    color: Colors.white38,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          _buildTopActionBtn(Icons.layers_outlined, () => _showLayersSheet()),
          SizedBox(width: 8.w),
          Obx(() => PopupMenuButton<String>(
            enabled: !controller.isLoading.value,
            onSelected: (value) async {
              if (value == 'save') {
                await controller.saveTemplateChangesToHistory();
                Get.snackbar(
                  'Saved',
                  'Design saved to history',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.accentPurpleBtn,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                  margin: EdgeInsets.all(16.w),
                );
              } else if (value == 'export') {
                await controller.exportDesign();
              }
            },
            color: const Color(0xFF1E1E2E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'save',
                child: Row(children: [
                  Icon(Icons.bookmark_rounded, color: AppColors.accentPurpleBtn, size: 18.sp),
                  SizedBox(width: 10.w),
                  Text('Save to History', style: GoogleFonts.outfit(color: Colors.white, fontSize: 13.sp)),
                ]),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(children: [
                  Icon(Icons.folder_open_rounded, color: AppColors.accentPurpleBtn, size: 18.sp),
                  SizedBox(width: 10.w),
                  Text('Export', style: GoogleFonts.outfit(color: Colors.white, fontSize: 13.sp)),
                ]),
              ),
            ],
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: controller.isLoading.value
                  ? SizedBox(width: 20.sp, height: 20.sp, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentPurpleBtn))
                  : Icon(Icons.more_vert_rounded, color: Colors.white, size: 20.sp),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTopActionBtn(IconData icon, VoidCallback tap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: IconButton(
        constraints: const BoxConstraints(),
        padding: EdgeInsets.all(8.w),
        onPressed: tap,
        icon: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }

  Widget _buildCanvasArea() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        controller.selectElement(-1);
        controller.isEditingText.value = false;
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: Obx(() => Container(
          decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 40)]),
          child: AspectRatio(
            aspectRatio: controller.aspectRatio.value,
            child: Screenshot(
              controller: controller.screenshotController,
              child: Container(
                decoration: BoxDecoration(
                  color: controller.backgroundColor.value,
                  gradient: controller.backgroundGradient.value != null ? LinearGradient(colors: controller.backgroundGradient.value!) : null,
                ),
                child: Stack(
                  children: [
                    CustomPaint(painter: DottedBackgroundPainter(), size: Size.infinite),
                    ...controller.components.asMap().entries.map(
                      (entry) => _buildDraggableElement(entry.key, entry.value),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }

  Widget _buildDraggableElement(int index, EditorElement element) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      final el = controller.components.length > index ? controller.components[index] : element;
      return Positioned(
        left: el.position.dx,
        top: el.position.dy,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: (_) => controller.onScaleStart(index),
          onScaleUpdate: (details) {
            if (!controller.isEditingText.value) controller.onScaleUpdate(index, details);
          },
          onTap: () {
            if (el.type == ElementType.text) {
              controller.selectElement(index);
              controller.isEditingText.value = true;
            } else {
              controller.selectElement(index);
            }
          },
          child: Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.identity()
              ..rotateX(el.rotateX)
              ..rotateY(el.rotateY)
              ..rotateZ(el.rotation),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildElementContent(index, el),
                if (isSelected)
                  Positioned.fill(child: IgnorePointer(
                    child: Container(decoration: BoxDecoration(
                      border: Border.all(color: AppColors.accentPurpleBtn, width: 2),
                      borderRadius: BorderRadius.circular(6.r),
                    )),
                  )),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildElementContent(int index, EditorElement element) {
    if (element.type == ElementType.text) {
      if (controller.isEditingText.value && controller.selectedIndex.value == index) {
        return IntrinsicWidth(
          child: TextFormField(
            initialValue: element.content,
            autofocus: true,
            textAlign: TextAlign.center,
            onChanged: (v) => controller.updateSelectedElement((e) => e.copyWith(content: v)),
            onFieldSubmitted: (_) => controller.isEditingText.value = false,
            onTapOutside: (_) => controller.isEditingText.value = false,
            cursorColor: Colors.white,
            style: _getFont(element.fontFamily ?? 'Manrope').copyWith(
              fontSize: (element.fontSize ?? 24).sp * element.scale,
              color: element.color ?? Colors.white,
              fontWeight: element.fontWeight,
              letterSpacing: element.letterSpacing,
              height: element.lineHeight,
            ),
            decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero),
          ),
        );
      }
      return _buildTextElement(element);
    } else if (element.type == ElementType.image) {
      final double imgWidth = 150.w * element.scale;

      // Base image
      Widget img = element.content.startsWith('assets/')
          ? Image.asset(element.content, fit: BoxFit.contain, width: imgWidth)
          : Image.file(File(element.content), fit: BoxFit.contain, width: imgWidth);

      // 1. Apply filter matrix (preset filters)
      final List<double>? matrix = element.filterMatrix;
      if (matrix != null && matrix.length == 20) {
        img = ColorFiltered(
          colorFilter: ColorFilter.matrix(matrix),
          child: img,
        );
      }

      // 2. Apply adjustment matrix (brightness/contrast/saturation/etc.)
      final adjustMatrix = controller.getAdjustmentMatrix(element);
      final bool isIdentity = adjustMatrix[0] == 1 && adjustMatrix[6] == 1 && adjustMatrix[12] == 1 && adjustMatrix[4] == 0;
      if (!isIdentity) {
        img = ColorFiltered(
          colorFilter: ColorFilter.matrix(adjustMatrix),
          child: img,
        );
      }

      // 3. Apply blur
      if (element.blur > 0) {
        img = ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: element.blur, sigmaY: element.blur),
          child: img,
        );
      }

      // 4. Glow via BoxShadow + shadow
      final List<BoxShadow> shadows = [
        if (element.glowRadius > 0)
          BoxShadow(color: element.glowColor.withValues(alpha: 0.85), blurRadius: element.glowRadius, spreadRadius: element.glowRadius * 0.3),
        if (element.shadowBlur > 0)
          BoxShadow(color: element.shadowColor.withValues(alpha: 0.7), blurRadius: element.shadowBlur, offset: const Offset(4, 4)),
      ];

      return Opacity(
        opacity: element.opacity,
        child: Container(
          decoration: BoxDecoration(boxShadow: shadows),
          child: img,
        ),
      );
    } else {
      double size = 100.w * element.scale;
      bool isCustomShape = !['circle', 'rect'].contains(element.content);

      final List<BoxShadow> glowShadows = element.glowRadius > 0
          ? [BoxShadow(color: element.glowColor.withValues(alpha: 0.8), blurRadius: element.glowRadius, spreadRadius: element.glowRadius * 0.2)]
          : [];
      final List<BoxShadow> shadowList = element.shadowBlur > 0
          ? [BoxShadow(color: element.shadowColor.withValues(alpha: 0.7), blurRadius: element.shadowBlur, offset: const Offset(4, 4))]
          : [];

      Widget shapeContent = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: element.shapeGradient == null ? element.color : null,
          gradient: element.shapeGradient != null ? LinearGradient(colors: element.shapeGradient!) : null,
          shape: element.content == 'circle' ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: element.content != 'circle' && element.borderRadius > 0 ? BorderRadius.circular(element.borderRadius) : null,
          boxShadow: [...glowShadows, ...shadowList],
        ),
      );

      if (isCustomShape) {
        shapeContent = ClipPath(
          clipper: _CustomShapeClipper(element.content),
          child: shapeContent,
        );
      }

      return Opacity(opacity: element.opacity, child: shapeContent);
    }
  }

  Widget _buildTextElement(EditorElement element) {
    double realSize = (element.fontSize ?? 24).sp * element.scale;

    final List<Shadow> shadows = [
      if (element.glowRadius > 0) ...[
        Shadow(color: element.glowColor, blurRadius: element.glowRadius),
        Shadow(color: element.glowColor, blurRadius: element.glowRadius * 0.5),
      ],
      if (element.shadowBlur > 0)
        Shadow(color: element.shadowColor, blurRadius: element.shadowBlur, offset: const Offset(4, 4)),
    ];

    Widget buildText({Color? color, Paint? foreground}) {
      // If gradient is active, don't apply solid color (ShaderMask handles it)
      final effectiveColor = (element.shapeGradient != null && foreground == null)
          ? Colors.white  // ShaderMask needs white base to tint correctly
          : (foreground != null ? null : (color ?? element.color ?? Colors.white));

      final style = _getFont(element.fontFamily ?? 'Manrope').copyWith(
        fontSize: realSize,
        color: effectiveColor,
        fontWeight: element.fontWeight,
        letterSpacing: element.letterSpacing,
        height: element.lineHeight,
        shadows: foreground != null ? null : (shadows.isNotEmpty ? shadows : null),
        foreground: foreground,
      );
      return Text(element.content, textAlign: element.textAlign, style: style);
    }

    Widget textWidget;

    if (element.outlineWidth > 0) {
      textWidget = Stack(children: [
        buildText(foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = element.outlineWidth
          ..color = element.outlineColor),
        buildText(),
      ]);
    } else {
      textWidget = buildText();
    }

    // Apply gradient via ShaderMask if shapeGradient is set
    if (element.shapeGradient != null) {
      textWidget = ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
          colors: element.shapeGradient!,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: textWidget,
      );
    }

    // Apply curve if curveAngle != 0
    if (element.curveAngle != 0) {
      textWidget = _CurvedTextWidget(
        text: element.content,
        curveAngle: element.curveAngle,
        child: textWidget,
        element: element,
        realSize: realSize,
        shadows: shadows,
      );
    }

    return Opacity(opacity: element.opacity, child: textWidget);
  }

  Widget _buildContextualBottomPanel() {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.08,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.08, 0.35, 0.88],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.panelDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 24, offset: const Offset(0, -4))],
          ),
          child: Column(
            children: [
              // Drag handle - only this part moves the sheet
              SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Center(
                    child: Container(
                      width: 40.w, height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              // Content scrolls independently inside
              Expanded(
                child: Obx(() => SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _buildPanelContent(),
                )),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPanelContent() {
    final tab = controller.currentTab.value;
    switch (tab) {
      case 'TEXT': return _buildTextPanel();
      case 'ICONS': return _buildIconsPanel();
      case 'COLORS': return _buildColorsPanel();
      case 'FONTS': return _buildFontsPanel();
      case 'BG': return _buildBackgroundPanel();
      case 'EFFECTS': return _buildEffectsPanel();
      default: return const SizedBox();
    }
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.panelDark,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem('TEXT', Icons.text_fields_rounded, 'TEXT'),
          _buildBottomNavItem('ICONS', Icons.grid_view_rounded, 'ICONS'),
          _buildBottomNavItem('COLORS', Icons.color_lens_outlined, 'COLORS'),
          _buildBottomNavItem('FONTS', Icons.font_download_rounded, 'FONTS'),
          _buildBottomNavItem('BACKGROUND', Icons.layers_rounded, 'BG'),
          _buildBottomNavItem('EFFECTS', Icons.auto_awesome_rounded, 'EFFECTS'),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(String label, IconData icon, String tabId) {
    return Obx(() {
      final isSelected = controller.currentTab.value == tabId;
      return InkWell(
        onTap: () => controller.currentTab.value = tabId,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentPurpleBtn.withValues(alpha: 0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: isSelected ? AppColors.accentPurpleBtn : Colors.white38, size: 24.sp),
            ),
            SizedBox(height: 4.h),
            Text(label, style: GoogleFonts.outfit(color: isSelected ? AppColors.accentPurpleBtn : Colors.white38, fontSize: 10.sp, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
          ],
        ),
      );
    });
  }

  Widget _buildTextPanel() {
    final idx = controller.selectedIndex.value;
    final hasSelection = idx != -1 && controller.components[idx].type == ElementType.text;
    final e = hasSelection ? controller.components[idx] : null;
    final isImageSelected = idx != -1 && controller.components[idx].type == ElementType.image;
    
    return _panelPad(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      _phdr('Type', undo: controller.undo, redo: controller.redo, add: controller.addText),
      if (!hasSelection && !isImageSelected) _empty('Tap + to add text or select text element', Icons.text_fields_rounded)
      else if (isImageSelected) _empty('Font options disabled for images', Icons.image_not_supported_rounded)
      else ...[
        _lbl('CONTENT'), _tf(e!.content, (v) => controller.updateSelectedElement((x) => x.copyWith(content: v))), _sp(10),
        _lbl('SIZE  •  ${(e.fontSize ?? 24).toInt()}px'), _sld((e.fontSize ?? 24).toDouble(), 8, 200, (v) => controller.updateSelectedElement((x) => x.copyWith(fontSize: v), saveHistory: false)), _sp(4),
        _lbl('WEIGHT'),
        SizedBox(height: 34.h, child: ListView(scrollDirection: Axis.horizontal, children: [
          _wchip('Thin', FontWeight.w100, e), _wchip('Light', FontWeight.w300, e), _wchip('Regular', FontWeight.w400, e),
          _wchip('Medium', FontWeight.w500, e), _wchip('Bold', FontWeight.w700, e), _wchip('Black', FontWeight.w900, e),
        ])),
        _sp(8),
        _lbl('LETTER SPACING  •  ${e.letterSpacing.toStringAsFixed(1)}'), _sld(e.letterSpacing, -5, 20, (v) => controller.updateSelectedElement((x) => x.copyWith(letterSpacing: v), saveHistory: false)), _sp(4),
        _lbl('STROKE WIDTH  •  ${e.outlineWidth.toStringAsFixed(1)}pt'), _sld(e.outlineWidth, 0, 20, (v) => controller.updateSelectedElement((x) => x.copyWith(outlineWidth: v), saveHistory: false)),
        _sp(4), _lbl('STROKE COLOR'), _clrRow(e.outlineColor, (c) => controller.updateSelectedElement((x) => x.copyWith(outlineColor: c))), _sp(10),
        _lbl('3D TILT X  •  ${e.rotateX.toStringAsFixed(2)}'), _sld(e.rotateX, -1, 1, (v) => controller.updateSelectedElement((x) => x.copyWith(rotateX: v), saveHistory: false)), _sp(2),
        _lbl('3D TILT Y  •  ${e.rotateY.toStringAsFixed(2)}'), _sld(e.rotateY, -1, 1, (v) => controller.updateSelectedElement((x) => x.copyWith(rotateY: v), saveHistory: false)), _sp(10),
        _lbl('CURVE  •  ${e.curveAngle.toStringAsFixed(2)}'), _sld(e.curveAngle, -1, 1, (v) => controller.updateSelectedElement((x) => x.copyWith(curveAngle: v), saveHistory: false)), _sp(10),
        _actRow(),
      ],
    ]));
  }

  Widget _buildIconsPanel() {
    return _panelPad(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      _phdr('Assets', undo: controller.undo, redo: controller.redo),
      GestureDetector(onTap: () => controller.addImage(), child: Container(
        width: double.infinity, padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(14.r), border: Border.all(color: AppColors.accentPurpleBtn.withValues(alpha: 0.5))),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.image_rounded, color: AppColors.accentPurpleBtn, size: 20.sp), SizedBox(width: 8.w), Text('Add Image from Gallery', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.sp))]),
      )),
      _sp(14), _lbl('SHAPES'),
      Wrap(spacing: 8.w, runSpacing: 8.h, children: [
        _shpBtn('Circle', Icons.circle_outlined, 'circle'), _shpBtn('Rect', Icons.crop_square_rounded, 'rect'),
        _shpBtn('Triangle', Icons.change_history_rounded, 'triangle'), _shpBtn('Star', Icons.star_border_rounded, 'star'),
        _shpBtn('Hexagon', Icons.hexagon_outlined, 'hexagon'), _shpBtn('Pentagon', Icons.pentagon_outlined, 'pentagon'),
        _shpBtn('Heart', Icons.favorite_border_rounded, 'heart'),
      ]),
    ]));
  }

  Widget _buildColorsPanel() {
    return Obx(() {
      final idx = controller.selectedIndex.value;
      final hasSel = idx != -1;
      final e = hasSel ? controller.components[idx] : null;
      final isGradientTab = controller.colorTab.value == 'GRADIENT';

    return _panelPad(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      _phdr('Colors', undo: controller.undo, redo: controller.redo),
      if (!hasSel) _empty('Select an element to change its color', Icons.color_lens_outlined)
      else ...[
        // SOLID / GRADIENT tabs
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(14.r)),
          child: Row(children: ['SOLID', 'GRADIENT'].map((tab) {
            final sel = controller.colorTab.value == tab;
            return Expanded(child: GestureDetector(
              onTap: () => controller.colorTab.value = tab,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: sel ? AppColors.accentPurpleBtn : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(child: Text(tab, style: GoogleFonts.outfit(
                  color: sel ? Colors.black : Colors.white54,
                  fontWeight: FontWeight.bold, fontSize: 12.sp,
                ))),
              ),
            ));
          }).toList()),
        ),
        _sp(16),

        if (!isGradientTab) ...[
          // Solid color section
          _lbl('COLORS'),
          _clrRow(e!.color, (c) => controller.updateSelectedElement((x) => x.copyWith(color: c, shapeGradient: null))),
          _sp(16),
          _lbl('PRESET PALETTES'),
          ..._presetPalettes().map((palette) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(12.r)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(palette['name'], style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10.sp, fontWeight: FontWeight.bold, letterSpacing: 1)),
              SizedBox(height: 8.h),
              Row(children: (palette['colors'] as List<Color>).map((c) => Expanded(
                child: GestureDetector(
                  onTap: () => controller.updateSelectedElement((x) => x.copyWith(color: c, shapeGradient: null)),
                  child: Container(
                    height: 44.h,
                    margin: EdgeInsets.only(right: 6.w),
                    decoration: BoxDecoration(
                      color: c,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: e.color?.value == c.value ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              )).toList()),
            ]),
          )),
          _sp(4),
          _lbl('OPACITY  •  ${(e.opacity * 100).toInt()}%'),
          _sld(e.opacity, 0, 1, (v) => controller.updateSelectedElement((x) => x.copyWith(opacity: v), saveHistory: false)),
        ] else ...[
          // Gradient section
          _lbl('GRADIENTS'),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: _gradients().sublist(0, 9).map((g) {
              final isSel = e!.shapeGradient != null && e.shapeGradient!.first.value == g.first.value;
              return GestureDetector(
                onTap: () => controller.updateSelectedElement((x) => x.copyWith(shapeGradient: g, color: Colors.white)),
                child: Container(
                  width: 60.w, height: 60.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: g, begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: isSel ? Colors.white : Colors.transparent, width: 2.5),
                  ),
                  child: isSel ? Icon(Icons.check_rounded, color: Colors.white, size: 20.sp) : null,
                ),
              );
            }).toList(),
          ),
          _sp(12),
          _lbl('RAINBOW'),
          _buildGradientTile(_gradients()[9], e!),
          _sp(12),
          _lbl('3D STYLES'),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: _gradients().sublist(10).map((g) => _buildGradientTile(g, e)).toList(),
          ),
          _sp(12),
          _lbl('OPACITY  •  ${(e.opacity * 100).toInt()}%'),
          _sld(e.opacity, 0, 1, (v) => controller.updateSelectedElement((x) => x.copyWith(opacity: v), saveHistory: false)),
        ],
        _sp(10), _actRow(),
      ],
    ]));
  });
  }

  Widget _buildGradientTile(List<Color> g, EditorElement e) {
    final isSel = e.shapeGradient != null && e.shapeGradient!.first.value == g.first.value;
    return GestureDetector(
      onTap: () => controller.updateSelectedElement((x) => x.copyWith(shapeGradient: g, color: Colors.white)),
      child: Container(
        width: 60.w, height: 60.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: g, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: isSel ? Colors.white : Colors.transparent, width: 2.5),
        ),
        child: isSel ? Icon(Icons.check_rounded, color: Colors.white, size: 20.sp) : null,
      ),
    );
  }

  List<Map<String, dynamic>> _presetPalettes() => [
    {'name': 'NEON', 'colors': [const Color(0xFFFF00FF), const Color(0xFF00FFFF), const Color(0xFF00FF00)]},
    {'name': 'FIRE', 'colors': [const Color(0xFFFF3D00), const Color(0xFFFF6D00), const Color(0xFFFFAB00)]},
    {'name': 'ICE', 'colors': [const Color(0xFF00B4D8), const Color(0xFF90E0EF), const Color(0xFFCAF0F8)]},
    {'name': 'ROYAL', 'colors': [const Color(0xFF7B2FBE), const Color(0xFF9D4EDD), const Color(0xFFC77DFF)]},
    {'name': 'SUNSET', 'colors': [const Color(0xFFFF6B6B), const Color(0xFFFFE66D), const Color(0xFF4ECDC4)]},
  ];

  Widget _buildFontsPanel() {
    final idx = controller.selectedIndex.value;
    final hasText = idx != -1 && controller.components[idx].type == ElementType.text;
    final hasNonText = idx != -1 && !hasText;
    final e = hasText ? controller.components[idx] : null;

    // Font categories
    final categories = {
      'All Styles': controller.fonts,
      'Gaming': ['Orbitron', 'Audiowide', 'Bungee', 'Press Start 2P'],
      'Editorial': ['Playfair Display', 'Merriweather', 'Lora', 'Crimson Text'],
      'Monospace': ['Roboto Mono', 'Source Code Pro', 'Courier Prime', 'Space Mono'],
    };

    return _panelPad(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      _phdr('Fonts'),
      if (hasNonText)
        // Disabled state for image/shape
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(children: [
            Icon(Icons.font_download_off_rounded, color: Colors.white24, size: 22.sp),
            SizedBox(width: 12.w),
            Expanded(child: Text(
              'Fonts only apply to text elements.\nSelect a text element to change font.',
              style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12.sp, height: 1.4),
            )),
          ]),
        )
      else if (!hasText)
        _empty('Select a text element to pick a font', Icons.font_download_rounded)
      else ...[
        // Category tabs
        SizedBox(
          height: 36.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: categories.keys.map((cat) {
              final isSelected = cat == 'All Styles';
              return GestureDetector(
                onTap: () {}, // TODO: Add category switching
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accentPurpleBtn : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    cat,
                    style: GoogleFonts.outfit(
                      color: isSelected ? Colors.black : Colors.white70,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        _sp(12),
        // Font cards
        ...controller.fonts.map((font) => _buildFontCard(font, e!)),
      ],
    ]));
  }

  Widget _buildFontCard(String font, EditorElement e) {
    final isSel = e.fontFamily == font;
    return GestureDetector(
      onTap: () => controller.updateSelectedElement((x) => x.copyWith(fontFamily: font)),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSel ? AppColors.accentPurpleBtn.withValues(alpha: 0.15) : AppColors.cardDark,
          border: Border.all(
            color: isSel ? AppColors.accentPurpleBtn : Colors.white12,
            width: isSel ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  font.toUpperCase(),
                  style: GoogleFonts.outfit(
                    color: isSel ? AppColors.accentPurpleBtn : Colors.white54,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                if (isSel)
                  Icon(Icons.star, color: AppColors.accentPurpleBtn, size: 16.sp),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              e.content.isNotEmpty ? e.content : 'Team Name',
              style: _getFont(font).copyWith(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              '${font.toUpperCase()} • VARIABLE',
              style: GoogleFonts.outfit(
                color: Colors.white38,
                fontSize: 9.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundPanel() {
    return Obx(() {
      final bgTab = controller.bgTab.value;
      return _panelPad(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      _phdr('Background'),
      Text('Select the atmosphere for your atelier', style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12.sp)),
      _sp(14),
      // Tabs: TRANSPARENT | SOLID | GRADIENT | TEXTURE
      Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(14.r)),
        child: Row(children: ['TRANSPARENT', 'SOLID', 'GRADIENT', 'TEXTURE'].map((tab) {
          final sel = bgTab == tab;
          return Expanded(child: GestureDetector(
            onTap: () => controller.bgTab.value = tab,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 9.h),
              decoration: BoxDecoration(
                color: sel ? AppColors.accentPurpleBtn : Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(child: Text(tab, style: GoogleFonts.outfit(
                color: sel ? Colors.black : Colors.white38,
                fontWeight: FontWeight.bold, fontSize: 9.sp,
              ))),
            ),
          ));
        }).toList()),
      ),
      _sp(16),

      if (bgTab == 'TRANSPARENT') ...[
        // Transparent option - just a preview
        Center(child: GestureDetector(
          onTap: () => controller.setBackgroundColor(Colors.transparent),
          child: Container(
            width: 80.w, height: 80.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.accentPurpleBtn, width: 2),
              image: const DecorationImage(image: AssetImage('assets/images/logo1.jpg'), opacity: 0.1, fit: BoxFit.cover),
            ),
            child: Icon(Icons.block_rounded, color: AppColors.accentPurpleBtn, size: 32.sp),
          ),
        )),
        _sp(12),
        Center(child: Text('No background (transparent)', style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12.sp))),
      ]
      else if (bgTab == 'SOLID') ...[
        _lbl('COLORS'),
        _clrRow(
          controller.backgroundGradient.value == null ? controller.backgroundColor.value : Colors.transparent,
          (c) => controller.setBackgroundColor(c),
          extra: [Colors.white, Colors.black, const Color(0xFF2B2E7A), const Color(0xFF1a1a2e), const Color(0xFF0f3460), Colors.deepPurple, Colors.teal, Colors.blueGrey, const Color(0xFF1C1C1E), const Color(0xFF2C2C2E)],
        ),
        _sp(16),
        _lbl('PRESET PALETTES'),
        ..._presetPalettes().map((palette) => Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(12.r)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(palette['name'], style: GoogleFonts.outfit(color: Colors.white54, fontSize: 10.sp, fontWeight: FontWeight.bold, letterSpacing: 1)),
            SizedBox(height: 8.h),
            Row(children: (palette['colors'] as List<Color>).map((c) => Expanded(
              child: GestureDetector(
                onTap: () => controller.setBackgroundColor(c),
                child: Container(
                  height: 44.h,
                  margin: EdgeInsets.only(right: 6.w),
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: controller.backgroundColor.value.value == c.value ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              ),
            )).toList()),
          ]),
        )),
      ]
      else if (bgTab == 'GRADIENT') ...[
        _lbl('GRADIENTS'),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: _gradients().map((g) {
            final isSel = controller.backgroundGradient.value != null &&
                controller.backgroundGradient.value!.first.value == g.first.value;
            return GestureDetector(
              onTap: () => controller.setBackgroundGradient(g),
              child: Container(
                width: 60.w, height: 60.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: g, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: isSel ? Colors.white : Colors.transparent, width: 2.5),
                ),
                child: isSel ? Icon(Icons.check_rounded, color: Colors.white, size: 20.sp) : null,
              ),
            );
          }).toList(),
        ),
      ]
      else if (bgTab == 'TEXTURE') ...[
        // NOTE: Texture images not available yet - add asset images to assets/textures/ folder
        Center(child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Column(children: [
            Icon(Icons.texture_rounded, color: Colors.white24, size: 40.sp),
            SizedBox(height: 10.h),
            Text('Textures coming soon', style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13.sp)),
            SizedBox(height: 4.h),
            Text('Add images to assets/textures/', style: GoogleFonts.outfit(color: Colors.white24, fontSize: 10.sp)),
          ]),
        )),
      ],

      _sp(12),
      _lbl('CANVAS RATIO'),
      SizedBox(height: 60.h, child: ListView(scrollDirection: Axis.horizontal, children: controller.ratios.map((r) => GestureDetector(
        onTap: () => controller.setAspectRatio(r['ratio']),
        child: Container(margin: EdgeInsets.only(right: 10.w), padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: controller.aspectRatio.value == r['ratio'] ? AppColors.accentPurpleBtn.withValues(alpha: 0.15) : AppColors.cardDark,
            borderRadius: BorderRadius.circular(10.r), border: Border.all(color: controller.aspectRatio.value == r['ratio'] ? AppColors.accentPurpleBtn : Colors.white12),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(r['icon'], color: controller.aspectRatio.value == r['ratio'] ? AppColors.accentPurpleBtn : Colors.white54, size: 18.sp), Text(r['name'], style: GoogleFonts.outfit(color: Colors.white70, fontSize: 9.sp))]),
        ),
      )).toList())),
    ]));
    });
  }

  Widget _buildEffectsPanel() {
    final idx = controller.selectedIndex.value;
    final hasSel = idx != -1;
    final e = hasSel ? controller.components[idx] : null;
    return _panelPad(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      _phdr('Effects', undo: controller.undo, redo: controller.redo),
      if (!hasSel) _empty('Select an element to add effects', Icons.auto_awesome_rounded)
      else ...[
        _lbl('GLOW RADIUS  •  ${e!.glowRadius.toStringAsFixed(0)}'), _sld(e.glowRadius, 0, 50, (v) => controller.updateSelectedElement((x) => x.copyWith(glowRadius: v), saveHistory: false)),
        _sp(4), _lbl('GLOW COLOR'), _clrRow(e.glowColor, (c) => controller.updateSelectedElement((x) => x.copyWith(glowColor: c))), _sp(10),
        _lbl('SHADOW BLUR  •  ${e.shadowBlur.toStringAsFixed(0)}'), _sld(e.shadowBlur, 0, 50, (v) => controller.updateSelectedElement((x) => x.copyWith(shadowBlur: v), saveHistory: false)),
        _sp(4), _lbl('SHADOW COLOR'), _clrRow(e.shadowColor, (c) => controller.updateSelectedElement((x) => x.copyWith(shadowColor: c))), _sp(10),
        if (e.type == ElementType.shape && e.content != 'circle') ...[
          _lbl('BORDER RADIUS  •  ${e.borderRadius.toStringAsFixed(0)}'),
          _sld(e.borderRadius, 0, 100, (v) => controller.updateSelectedElement((x) => x.copyWith(borderRadius: v), saveHistory: false)),
          _sp(10),
        ],
        if (e.type == ElementType.image) ...[
          _lbl('FILTERS'),
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.filters.length,
              itemBuilder: (_, i) {
                final f = controller.filters[i];
                final fMatrix = List<double>.from(f['matrix']);
                final isSel = e.filterMatrix != null &&
                    e.filterMatrix!.length == fMatrix.length &&
                    e.filterMatrix!.asMap().entries.every((en) => en.value == fMatrix[en.key]);
                return GestureDetector(
                  onTap: () => controller.updateSelectedElement((x) => x.copyWith(filterMatrix: fMatrix)),
                  child: Container(
                    margin: EdgeInsets.only(right: 10.w),
                    width: 58.w,
                    child: Column(children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: isSel ? AppColors.accentPurpleBtn : Colors.white12, width: isSel ? 2 : 1),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(9.r),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.matrix(fMatrix),
                              child: e.content.startsWith('assets/')
                                  ? Image.asset(e.content, fit: BoxFit.cover)
                                  : Image.file(File(e.content), fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(f['name'], style: GoogleFonts.outfit(color: isSel ? AppColors.accentPurpleBtn : Colors.grey, fontSize: 8.sp), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ]),
                  ),
                );
              },
            ),
          ),
          _sp(10), _lbl('ADJUSTMENTS'),
          _lbl('Brightness  •  ${e.brightness.toStringAsFixed(1)}'), _sld(e.brightness, -1, 1, (v) => controller.updateSelectedElement((x) => x.copyWith(brightness: v), saveHistory: false)),
          _lbl('Contrast  •  ${e.contrast.toStringAsFixed(1)}'), _sld(e.contrast, 0, 2, (v) => controller.updateSelectedElement((x) => x.copyWith(contrast: v), saveHistory: false)),
          _lbl('Saturation  •  ${e.saturation.toStringAsFixed(1)}'), _sld(e.saturation, 0, 2, (v) => controller.updateSelectedElement((x) => x.copyWith(saturation: v), saveHistory: false)),
          _lbl('Blur  •  ${e.blur.toStringAsFixed(1)}'), _sld(e.blur, 0, 20, (v) => controller.updateSelectedElement((x) => x.copyWith(blur: v), saveHistory: false)),
        ],
        _sp(10), _actRow(),
      ],
    ]));
  }

  // ── REUSABLE HELPERS ──

  Widget _panelPad(Widget child) => Padding(padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h), child: child);
  Widget _sp(double h) => SizedBox(height: h.h);
  Widget _lbl(String t) => Padding(padding: EdgeInsets.only(bottom: 5.h), child: Text(t, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 10.sp, fontWeight: FontWeight.bold, letterSpacing: 0.8)));

  Widget _phdr(String title, {VoidCallback? undo, VoidCallback? redo, VoidCallback? add}) => Padding(
    padding: EdgeInsets.only(bottom: 14.h),
    child: Row(children: [
      Text(title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      const Spacer(),
      if (undo != null) _icnBtn(Icons.undo_rounded, undo),
      if (redo != null) ...[SizedBox(width: 8.w), _icnBtn(Icons.redo_rounded, redo)],
      if (add != null) ...[SizedBox(width: 8.w), _icnBtn(Icons.add_rounded, add, color: AppColors.accentPurpleBtn)],
    ]),
  );

  Widget _icnBtn(IconData icon, VoidCallback tap, {Color? color}) => InkWell(
    onTap: tap,
    child: Container(padding: EdgeInsets.all(7.w), decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle), child: Icon(icon, color: color ?? Colors.white, size: 17.sp)),
  );

  Widget _empty(String msg, IconData icon) => Padding(
    padding: EdgeInsets.symmetric(vertical: 24.h),
    child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: Colors.white10, size: 40.sp), SizedBox(height: 10.h),
      Text(msg, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13.sp), textAlign: TextAlign.center),
    ])),
  );

  Widget _tf(String val, void Function(String) onChange) => Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(12.r)),
    child: TextFormField(initialValue: val, onChanged: onChange, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(border: InputBorder.none)),
  );

  Widget _sld(double val, double min, double max, void Function(double) onChange) => SliderTheme(
    data: SliderThemeData(trackHeight: 2, activeTrackColor: AppColors.accentPurpleBtn, inactiveTrackColor: Colors.white10, thumbColor: Colors.white, overlayColor: AppColors.accentPurpleBtn.withValues(alpha: 0.2), thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6)),
    child: Slider(
      value: val.clamp(min, max),
      min: min,
      max: max,
      onChanged: onChange,
      onChangeEnd: (_) => controller.commitSliderHistory(),
    ),
  );

  Widget _clrRow(Color? selected, void Function(Color) onColor, {List<Color>? extra}) {
    final baseColors = extra ?? [Colors.white, Colors.black, const Color(0xFFFF3B30), const Color(0xFFFF9500), const Color(0xFFFFCC00), const Color(0xFF34C759), const Color(0xFF007AFF), const Color(0xFF5856D6), const Color(0xFFFF2D55), const Color(0xFF00C7BE), AppColors.accentPurpleBtn, AppColors.accentCyan];
    // Always prepend "no color" transparent circle as first option
    final colors = [Colors.transparent, ...baseColors];
    // If selected is null or transparent, treat transparent as selected
    final effectiveSelected = (selected == null || selected == Colors.transparent) ? Colors.transparent : selected;

    return SizedBox(height: 36.h, child: ListView(scrollDirection: Axis.horizontal, children: colors.map((c) {
      final isSel = effectiveSelected.value == c.value;
      return GestureDetector(
        onTap: () => onColor(c),
        child: Container(
          width: 32.w, height: 32.w,
          margin: EdgeInsets.only(right: 10.w),
          decoration: BoxDecoration(
            color: c == Colors.transparent ? null : c,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSel ? Colors.white : Colors.white24,
              width: isSel ? 2.5 : 1,
            ),
          ),
          child: c == Colors.transparent
              ? Center(child: CustomPaint(size: Size(20.w, 20.w), painter: _NoneColorPainter()))
              : null,
        ),
      );
    }).toList()));
  }

  Widget _wchip(String label, FontWeight w, EditorElement e) {
    final isSel = e.fontWeight == w;
    return GestureDetector(onTap: () => controller.updateSelectedElement((x) => x.copyWith(fontWeight: w)), child: Container(
      margin: EdgeInsets.only(right: 8.w), padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(color: isSel ? AppColors.accentPurpleBtn : Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(20.r)),
      child: Text(label, style: GoogleFonts.outfit(color: isSel ? Colors.black : Colors.white70, fontSize: 11.sp, fontWeight: FontWeight.bold)),
    ));
  }

  Widget _shpBtn(String label, IconData icon, String type) => GestureDetector(
    onTap: () => controller.addShape(type),
    child: Container(padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h), decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(10.r), border: Border.all(color: Colors.white12)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: Colors.white70, size: 16.sp), SizedBox(width: 6.w), Text(label, style: GoogleFonts.outfit(color: Colors.white70, fontSize: 11.sp))])),
  );

  Widget _actRow() => Row(children: [
    _actBtn(Icons.copy_outlined, 'Dupe', () => controller.duplicateSelected()),
    _actBtn(Icons.arrow_upward_rounded, 'Up', () { final i = controller.selectedIndex.value; if (i < controller.components.length - 1) controller.moveLayer(i, i + 1); }),
    _actBtn(Icons.arrow_downward_rounded, 'Down', () { final i = controller.selectedIndex.value; if (i > 0) controller.moveLayer(i, i - 1); }),
    _actBtn(Icons.delete_outline_rounded, 'Delete', () => controller.removeSelected(), color: Colors.redAccent),
  ]);

  Widget _actBtn(IconData icon, String label, VoidCallback tap, {Color? color}) => Expanded(child: GestureDetector(
    onTap: tap,
    child: Container(margin: EdgeInsets.only(right: 6.w), padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(color: color != null ? color.withValues(alpha: 0.1) : AppColors.cardDark, borderRadius: BorderRadius.circular(10.r), border: Border.all(color: color ?? Colors.white10)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: color ?? Colors.white70, size: 18.sp), Text(label, style: GoogleFonts.outfit(color: color ?? Colors.white54, fontSize: 9.sp))]),
    ),
  ));

  List<List<Color>> _gradients() => [
    [Colors.blue, Colors.purple],
    [Colors.orange, Colors.red],
    [Colors.green, Colors.teal],
    [Colors.pink, Colors.orange],
    [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)],
    [const Color(0xFF00c6ff), const Color(0xFF0072ff)],
    [const Color(0xFFf953c6), const Color(0xFFb91d73)],
    [const Color(0xFF3a7bd5), const Color(0xFF00d2ff)],
    [const Color(0xFF2B2E7A), const Color(0xFF9C6FFF)],
    // Rainbow
    [const Color(0xFFFF0000), const Color(0xFFFF7700), const Color(0xFFFFFF00), const Color(0xFF00FF00), const Color(0xFF0000FF), const Color(0xFF8B00FF)],
    // 3D Gold
    [const Color(0xFFFFD700), const Color(0xFFFFFFAA), const Color(0xFFB8860B), const Color(0xFFFFD700)],
    // 3D Silver
    [const Color(0xFF9E9E9E), const Color(0xFFFFFFFF), const Color(0xFF616161), const Color(0xFFBDBDBD)],
    // 3D Red
    [const Color(0xFFB71C1C), const Color(0xFFFF5252), const Color(0xFF7F0000), const Color(0xFFFF1744)],
    // 3D Blue
    [const Color(0xFF0D47A1), const Color(0xFF64B5F6), const Color(0xFF01579B), const Color(0xFF2979FF)],
    // 3D Purple
    [const Color(0xFF4A148C), const Color(0xFFCE93D8), const Color(0xFF6A1B9A), const Color(0xFFAA00FF)],
  ];

  void _showLayersSheet() {
    Get.bottomSheet(Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(color: AppColors.panelDark, borderRadius: BorderRadius.vertical(top: Radius.circular(28.r))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Layers', style: GoogleFonts.outfit(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 16.h),
        Obx(() => Column(children: controller.components.asMap().entries.map((en) {
          final el = en.value; final i = en.key;
          return ListTile(
            leading: Icon(el.type == ElementType.text ? Icons.title : el.type == ElementType.image ? Icons.image : Icons.category, color: Colors.white54),
            title: Text(el.type == ElementType.text ? el.content : el.type == ElementType.image ? 'Image Layer' : 'Shape Layer', style: const TextStyle(color: Colors.white)),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: Icon(Icons.arrow_upward, color: i < controller.components.length - 1 ? Colors.white : Colors.white24, size: 18), onPressed: i < controller.components.length - 1 ? () => controller.moveLayer(i, i + 1) : null),
              IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: Icon(Icons.arrow_downward, color: i > 0 ? Colors.white : Colors.white24, size: 18), onPressed: i > 0 ? () => controller.moveLayer(i, i - 1) : null),
              IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20), onPressed: () { controller.selectElement(i); controller.removeSelected(); Get.back(); }),
            ]),
            onTap: () { controller.selectElement(i); Get.back(); },
          );
        }).toList())),
      ]),
    ));
  }

  TextStyle _getFont(String name) {
    try { return GoogleFonts.getFont(name); } catch (_) { return GoogleFonts.manrope(); }
  }
}

// ── CURVED TEXT ──
class _CurvedTextWidget extends StatelessWidget {
  final String text;
  final double curveAngle;
  final Widget child;
  final EditorElement element;
  final double realSize;
  final List<Shadow> shadows;

  const _CurvedTextWidget({
    required this.text,
    required this.curveAngle,
    required this.child,
    required this.element,
    required this.realSize,
    required this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CurvedTextPainter(
        text: text,
        curveAngle: curveAngle,
        fontSize: realSize,
        color: element.shapeGradient != null ? Colors.white : (element.color ?? Colors.white),
        fontFamily: element.fontFamily ?? 'Manrope',
        fontWeight: element.fontWeight ?? FontWeight.normal,
        letterSpacing: element.letterSpacing,
        outlineColor: element.outlineColor,
        outlineWidth: element.outlineWidth,
        glowColor: element.glowColor,
        glowRadius: element.glowRadius,
        gradient: element.shapeGradient,
      ),
      child: const SizedBox(width: 300, height: 160),
    );
  }
}

class _CurvedTextPainter extends CustomPainter {
  final String text;
  final double curveAngle;
  final double fontSize;
  final Color color;
  final String fontFamily;
  final FontWeight fontWeight;
  final double letterSpacing;
  final Color outlineColor;
  final double outlineWidth;
  final Color glowColor;
  final double glowRadius;
  final List<Color>? gradient;

  _CurvedTextPainter({
    required this.text,
    required this.curveAngle,
    required this.fontSize,
    required this.color,
    required this.fontFamily,
    required this.fontWeight,
    required this.letterSpacing,
    required this.outlineColor,
    required this.outlineWidth,
    required this.glowColor,
    required this.glowRadius,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (text.isEmpty) return;

    // Radius based on curve angle - larger radius = less curve
    final double radius = size.width / (curveAngle.abs() * 2.5 + 0.01);
    final bool curveUp = curveAngle > 0;

    // Center of the arc
    final double cx = size.width / 2;
    final double cy = curveUp ? size.height + radius - fontSize * 1.5 : -radius + fontSize * 0.5;

    // Total angle span
    final double totalAngle = size.width / radius;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Measure each character width
    final List<double> charWidths = [];
    double totalWidth = 0;
    for (int i = 0; i < text.length; i++) {
      textPainter.text = TextSpan(
        text: text[i],
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, letterSpacing: letterSpacing),
      );
      textPainter.layout();
      charWidths.add(textPainter.width + letterSpacing);
      totalWidth += textPainter.width + letterSpacing;
    }

    // Start angle so text is centered
    double anglePerPixel = 1 / radius;
    double currentAngle = (curveUp ? -dart_math.pi / 2 : dart_math.pi / 2) - (totalWidth / 2) * anglePerPixel;

    for (int i = 0; i < text.length; i++) {
      final double charAngle = currentAngle + charWidths[i] / 2 * anglePerPixel;

      canvas.save();
      canvas.translate(
        cx + radius * dart_math.cos(charAngle),
        cy + radius * dart_math.sin(charAngle),
      );
      canvas.rotate(charAngle + (curveUp ? dart_math.pi / 2 : -dart_math.pi / 2));

      // Draw glow
      if (glowRadius > 0) {
        textPainter.text = TextSpan(
          text: text[i],
          style: TextStyle(
            fontSize: fontSize, fontWeight: fontWeight,
            foreground: Paint()
              ..color = glowColor
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius / 3),
          ),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      }

      // Draw outline
      if (outlineWidth > 0) {
        textPainter.text = TextSpan(
          text: text[i],
          style: TextStyle(
            fontSize: fontSize, fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = outlineWidth
              ..color = outlineColor,
          ),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      }

      // Draw fill
      Paint? fillPaint;
      if (gradient != null) {
        fillPaint = Paint()
          ..shader = LinearGradient(colors: gradient!).createShader(
            Rect.fromLTWH(-fontSize, -fontSize, fontSize * 2, fontSize * 2),
          );
      }

      textPainter.text = TextSpan(
        text: text[i],
        style: TextStyle(
          fontSize: fontSize, fontWeight: fontWeight,
          color: fillPaint == null ? color : null,
          foreground: fillPaint,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));

      canvas.restore();
      currentAngle += charWidths[i] * anglePerPixel;
    }
  }

  @override
  bool shouldRepaint(_CurvedTextPainter old) =>
      old.text != text || old.curveAngle != curveAngle || old.color != color;
}

class _NoneColorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white38
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    // Draw circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);
    // Draw diagonal line (top-right to bottom-left)
    canvas.drawLine(
      Offset(size.width * 0.75, size.height * 0.1),
      Offset(size.width * 0.1, size.height * 0.85),
      paint..color = Colors.redAccent..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

