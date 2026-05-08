import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_model/splash_view_model.dart';

class SplashView extends GetView<SplashViewModel> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // We initialize the view model so it starts navigation
    Get.put(SplashViewModel());
    
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D13),
      body: Stack(
        children: [
          // Background Glow
          Center(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                width: 300.w,
                height: 300.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF7B2FBE).withValues(alpha: 0.08),
                ),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder(
                  duration: const Duration(seconds: 1),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.scale(
                        scale: 0.9 + (0.1 * value),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7B2FBE), Color(0xFF9D4EDD)],
                      ),
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B2FBE).withOpacity(0.2),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 50.sp),
                  ),
                ),
                SizedBox(height: 32.h),
                Text(
                  'ATELIER',
                  style: GoogleFonts.outfit(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 8,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'DESIGN STUDIO',
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white38,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
