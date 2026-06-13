import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_model/welcome_banner_view_model.dart';

class WelcomeBannerView extends GetView<WelcomeBannerViewModel> {
  const WelcomeBannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF004D4D),
              Color(0xFF008080),
              Color(0xFF006666),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background decorative elements
              Positioned(
                top: -60.h,
                right: -40.w,
                child: _buildBlurCircle(220.w, Colors.amber.withValues(alpha: 0.1)),
              ),
              Positioned(
                bottom: -80.h,
                left: -60.w,
                child: _buildBlurCircle(280.w, Colors.white.withValues(alpha: 0.06)),
              ),

              // Content
              Obx(() => AnimatedOpacity(
                opacity: controller.isAnimating.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),

                    // Skip button
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

                              // Limited badge
                              _buildAnimatedItem(
                                delay: 200,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                      color: Colors.amber.withValues(alpha: 0.4),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    'LIMITED EDITION',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.amber.shade200,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 24.h),

                              // Product image card
                              _buildAnimatedItem(
                                delay: 400,
                                child: Container(
                                  width: double.infinity,
                                  height: 320.h,
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
                                        // Teal gradient background for product
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                const Color(0xFF00A0A0),
                                                const Color(0xFF006060),
                                                const Color(0xFF004D4D),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Grid pattern overlay
                                        Positioned.fill(
                                          child: Opacity(
                                            opacity: 0.08,
                                            child: CustomPaint(
                                              painter: _GridPainter(),
                                            ),
                                          ),
                                        ),
                                        // Shine effect
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
                                        // Central logo/product display
                                        Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 90.w,
                                                height: 90.w,
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withValues(alpha: 0.12),
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
                                                  color: Colors.white,
                                                  letterSpacing: 6,
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                'LOGO MAKER PRO',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white.withValues(alpha: 0.7),
                                                  letterSpacing: 3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Bottom fade
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

                              // Title
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

                              // Description
                              _buildAnimatedItem(
                                delay: 700,
                                child: Text(
                                  'Get access to all premium templates, AI tools, and HD exports with our Pro plan.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withValues(alpha: 0.7),
                                    height: 1.5,
                                  ),
                                ),
                              ),

                              SizedBox(height: 28.h),

                              // Features
                              _buildAnimatedItem(
                                delay: 800,
                                child: Container(
                                  padding: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      _buildFeatureRow(Icons.check_circle_rounded, '500+ Premium Templates'),
                                      SizedBox(height: 14.h),
                                      _buildFeatureRow(Icons.check_circle_rounded, 'AI Logo Generation'),
                                      SizedBox(height: 14.h),
                                      _buildFeatureRow(Icons.check_circle_rounded, 'Remove Background'),
                                      SizedBox(height: 14.h),
                                      _buildFeatureRow(Icons.check_circle_rounded, 'HD Export & Commercial Use'),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 32.h),

                              // Buy button
                              _buildAnimatedItem(
                                delay: 1000,
                                child: GestureDetector(
                                  onTap: controller.onBuyNow,
                                  child: Container(
                                    width: double.infinity,
                                    height: 62.h,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.amber.shade600,
                                          Colors.orange.shade700,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.amber.withValues(alpha: 0.4),
                                          blurRadius: 25,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.bolt_rounded,
                                            color: Colors.white,
                                            size: 24.sp,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            'BUY NOW — ',
                                            style: GoogleFonts.outfit(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                          Text(
                                            '\$29.99',
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
                                ),
                              ),

                              SizedBox(height: 12.h),

                              // No thanks
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

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal.shade200, size: 20.sp),
        SizedBox(width: 12.w),
        Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
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
