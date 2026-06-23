import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      appBar: AppBar(
        title: Text('About',
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 17.sp)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            // ── Hero ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(28.w),
              decoration: BoxDecoration(
                color: const Color(0xFF008080),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 6))
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.asset('assets/images/logo.png',
                          fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text('Logo Maker',
                      style: GoogleFonts.outfit(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 4.h),
                  Text('Version 1.0.0',
                      style: GoogleFonts.outfit(
                          fontSize: 12.sp, color: Colors.white60)),
                  SizedBox(height: 4.h),
                  Text('by Zencakeus',
                      style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          color: Colors.white60,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // ── Cards ──
            _card(
              icon: Icons.flag_outlined,
              title: 'Our Mission',
              body:
                  'Logo Maker is built to give every creator — from freelancers to businesses — the tools to design professional logos without needing design experience.',
            ),
            SizedBox(height: 12.h),
            _card(
              icon: Icons.design_services_rounded,
              title: 'What We Offer',
              body:
                  'Hundreds of templates across categories, a powerful canvas editor, text and shape tools, custom colors, effects, and one-tap HD export.',
            ),
            SizedBox(height: 12.h),
            _card(
              icon: Icons.security_outlined,
              title: 'Privacy First',
              body:
                  'Your designs are yours. We do not sell or share your personal data. All exports stay on your device unless you choose to share them.',
            ),

            SizedBox(height: 24.h),

            // ── Feature highlights ──
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Features',
                      style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  SizedBox(height: 14.h),
                  _feature('Drag and drop canvas editor'),
                  _feature('100+ logo templates'),
                  _feature('Custom fonts and colors'),
                  _feature('Shapes, icons and stickers'),
                  _feature('HD export to gallery'),
                  _feature('Save and edit history'),
                ],
              ),
            ),

            SizedBox(height: 28.h),

            Text('© 2026 Logo Maker — Zencakeus',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                    fontSize: 11.sp, color: Colors.black38)),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _card(
      {required IconData icon,
      required String title,
      required String body}) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF008080).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child:
                Icon(icon, color: const Color(0xFF008080), size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87)),
                SizedBox(height: 5.h),
                Text(body,
                    style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: Colors.black54,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _feature(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded,
              color: const Color(0xFF008080), size: 16.sp),
          SizedBox(width: 10.w),
          Text(text,
              style: GoogleFonts.outfit(
                  fontSize: 13.sp, color: Colors.black54)),
        ],
      ),
    );
  }
}
