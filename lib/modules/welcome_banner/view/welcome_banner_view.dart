import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/utils/color_constants.dart';
import '../view_model/welcome_banner_view_model.dart';

class WelcomeBannerView extends GetView<WelcomeBannerViewModel> {
  const WelcomeBannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withValues(alpha: 0.9),
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -60.h,
                right: -40.w,
                child: _buildBlurCircle(220.w, AppColors.primary.withValues(alpha: 0.3)),
              ),
              Positioned(
                bottom: -80.h,
                left: -60.w,
                child: _buildBlurCircle(280.w, Colors.white.withValues(alpha: 0.06)),
              ),

              Obx(() => AnimatedOpacity(
                opacity: controller.isAnimating.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),

                    _buildAnimatedItem(
                      delay: 0,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: controller.onGetStarted,
                          child: Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: Text(
                              'Skip',
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            children: [
                              SizedBox(height: 20.h),

                              _buildAnimatedItem(
                                delay: 200,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentTeal.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.4),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'LIMITED EDITION',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 24.h),

                              _buildAnimatedItem(
                                delay: 400,
                                child: Container(
                                  width: double.infinity,
                                  height: 240.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.25),
                                        blurRadius: 40,
                                        offset: const Offset(0, 15),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(32.r),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white,
                                                AppColors.accentTeal,
                                                AppColors.primary.withValues(alpha: 0.3),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Opacity(
                                            opacity: 0.08,
                                            child: CustomPaint(
                                              painter: _GridPainter(),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: -40.h,
                                          right: -30.w,
                                          child: Container(
                                            width: 150.w,
                                            height: 150.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: RadialGradient(
                                                colors: [
                                                  Colors.white.withValues(alpha: 0.2),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 90.w,
                                                height: 90.w,
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius: BorderRadius.circular(24.r),
                                                  border: Border.all(
                                                    color: Colors.white.withValues(alpha: 0.25),
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.auto_awesome_rounded,
                                                  color: Colors.white,
                                                  size: 44.sp,
                                                ),
                                              ),
                                              SizedBox(height: 16.h),
                                              Text(
                                                'PREMIUM',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w900,
                                                  color: AppColors.primary,
                                                  letterSpacing: 6,
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                'LOGO MAKER PRO',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.primary.withValues(alpha: 0.7),
                                                  letterSpacing: 3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: 60.h,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black.withValues(alpha: 0.3),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 28.h),

                              _buildAnimatedItem(
                                delay: 600,
                                child: Text(
                                  'Unlock Unlimited\nCreative Possibilities',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.outfit(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    height: 1.2,
                                  ),
                                ),
                              ),

                              SizedBox(height: 12.h),

                              _buildAnimatedItem(
                                delay: 700,
                                child: Text(
                                  'Choose your plan and start creating today.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withValues(alpha: 0.7),
                                    height: 1.5,
                                  ),
                                ),
                              ),

                              SizedBox(height: 24.h),

                              _buildAnimatedItem(
                                delay: 800,
                                child: Obx(() => Row(
                                  children: controller.plans.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final plan = entry.value;
                                    final isSelected = controller.selectedPlanIndex.value == index;
                                    final Color accentColor = Color(plan.color);
                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () => controller.selectedPlanIndex.value = index,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                                          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? accentColor.withValues(alpha: 0.25)
                                                : Colors.white.withValues(alpha: 0.05),
                                            borderRadius: BorderRadius.circular(16.r),
                                            border: Border.all(
                                              color: isSelected
                                                  ? accentColor
                                                  : Colors.white.withValues(alpha: 0.1),
                                              width: isSelected ? 2.5 : 1,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (plan.isPopular)
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Container(
                                                    margin: EdgeInsets.only(bottom: 6.h),
                                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                                                    decoration: BoxDecoration(
                                                      color: accentColor,
                                                      borderRadius: BorderRadius.circular(4.r),
                                                    ),
                                                    child: Text(
                                                      'BEST',
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 7.sp,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              else
                                                SizedBox(height: 14.h),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  plan.title,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  plan.price,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  plan.period,
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 9.sp,
                                                    color: Colors.white.withValues(alpha: 0.5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )),
                              ),

                              SizedBox(height: 20.h),

                              _buildAnimatedItem(
                                delay: 900,
                                child: Obx(() {
                                  final plan = controller.plans[controller.selectedPlanIndex.value];
                                  final Color accentColor = Color(plan.color);
                                  return Container(
                                    padding: EdgeInsets.all(16.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.1),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: plan.features.map((f) => Padding(
                                        padding: EdgeInsets.only(bottom: 8.h),
                                        child: Row(
                                          children: [
                                            Icon(Icons.check_circle_rounded,
                                                color: accentColor, size: 16.sp),
                                            SizedBox(width: 10.w),
                                            Text(
                                              f,
                                              style: GoogleFonts.outfit(
                                                fontSize: 13.sp,
                                                color: Colors.white.withValues(alpha: 0.9),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )).toList(),
                                    ),
                                  );
                                }),
                              ),

                              SizedBox(height: 24.h),

                              _buildAnimatedItem(
                                delay: 1000,
                                child: Obx(() {
                                  final plan = controller.plans[controller.selectedPlanIndex.value];
                                  final Color accentColor = Color(plan.color);
                                  final bool loading = controller.isPurchasing.value;
                                  return GestureDetector(
                                    onTap: loading ? null : () => controller.onSubscribe(controller.selectedPlanIndex.value),
                                    child: Container(
                                      width: double.infinity,
                                      height: 62.h,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            accentColor,
                                            accentColor.withValues(alpha: 0.8),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: accentColor.withValues(alpha: 0.4),
                                            blurRadius: 25,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (loading)
                                              SizedBox(
                                                width: 22.sp,
                                                height: 22.sp,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  color: Colors.white,
                                                ),
                                              )
                                            else
                                              Icon(
                                                Icons.bolt_rounded,
                                                color: Colors.white,
                                                size: 24.sp,
                                              ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              loading ? 'Processing...' : 'SUBSCRIBE — ',
                                              style: GoogleFonts.outfit(
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                                letterSpacing: 2,
                                              ),
                                            ),
                                            if (!loading)
                                              Text(
                                                '${plan.price}${plan.period}',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),

                              SizedBox(height: 12.h),

                              _buildAnimatedItem(
                                delay: 1100,
                                child: GestureDetector(
                                  onTap: controller.onGetStarted,
                                  child: Text(
                                    'No thanks, start free',
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withValues(alpha: 0.5),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 32.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlurCircle(double size, Color color) {
    return ClipRRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedItem({
    required int delay,
    required Widget child,
  }) {
    return AnimatedSlide(
      offset: controller.isAnimating.value ? Offset.zero : const Offset(0, 0.25),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: controller.isAnimating.value ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500 + delay),
        child: child,
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
