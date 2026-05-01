import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app/utils/color_constants.dart';

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? padding;
  final double? borderRadius;
  final Color? color;
  final Border? border;
  final List<BoxShadow>? shadow;

  const PrimaryContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.color,
    this.border,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding ?? 16.w),
      decoration: BoxDecoration(
        color: color ?? AppColors.cardColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 20.r),
        border: border ?? Border.all(color: AppColors.dividerColor, width: 1),
        boxShadow: shadow ?? [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
