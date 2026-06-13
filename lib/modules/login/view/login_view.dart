import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/utils/color_constants.dart';
import '../view_model/login_view_model.dart';

class LoginView extends GetView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 420.h,
            child: ClipPath(
              clipper: CustomHeaderClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF008080),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.h),
                    Text(
                      'Atelier',
                      style: GoogleFonts.dancingScript(
                        fontSize: 64.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(0, 4),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 50.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Dismiss (Close) Button
          Positioned(
            top: 40.h,
            right: 20.w,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 400.h),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      children: [
                        Text(
                          'Welcome back',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 34.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Login to continue your creative journey',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            color: Colors.black45,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Obx(() => GestureDetector(
                          onTap: controller.isLoading.value ? null : () => controller.loginWithGoogle(),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: double.infinity,
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: controller.isLoading.value
                                  ? SizedBox(
                                      width: 24.w,
                                      height: 24.w,
                                      child: const CircularProgressIndicator(
                                        color: Color(0xFF0B0D13),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.g_mobiledata_rounded, color: const Color(0xFF4285F4), size: 40.sp),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'Continue with Google',
                                          style: GoogleFonts.outfit(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF0B0D13),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        )),
                        const Spacer(),
                        // Terms and Policies Footer
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Text.rich(
                            TextSpan(
                              text: 'By continuing, you agree to our ',
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                color: Colors.black45,
                                height: 1.5,
                              ),
                              children: [
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final url = Uri.parse('https://logomaker-6d294.web.app/terms.html');
                                      try {
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url, mode: LaunchMode.externalApplication);
                                        }
                                      } catch (e) {
                                        print('Could not launch Terms: $e');
                                      }
                                    },
                                    child: Text(
                                      'Terms of Service',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12.sp,
                                        color: const Color(0xFF008080),
                                        fontWeight: FontWeight.w800,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                const TextSpan(text: ' and '),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final url = Uri.parse('https://logomaker-6d294.web.app/privacy.html');
                                      try {
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url, mode: LaunchMode.externalApplication);
                                        }
                                      } catch (e) {
                                        print('Could not launch Privacy: $e');
                                      }
                                    },
                                    child: Text(
                                      'Privacy Policy',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12.sp,
                                        color: const Color(0xFF008080),
                                        fontWeight: FontWeight.w800,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
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

class CustomHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 80);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height);
    var secondEndPoint = Offset(size.width, size.height - 80);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
