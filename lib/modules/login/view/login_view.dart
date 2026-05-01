import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../app/utils/color_constants.dart';
import '../view_model/login_view_model.dart';

class LoginView extends GetView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              
              // Logo and App Name
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.atelierDark,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.asset(
                        'assets/images/logo1.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'The Ethereal Studio',
                    style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.atelierDark,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 60.h),

              // Login Card
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.inter(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.atelierDark,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Sign in to your creative suite.',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Email Field
                    CustomTextField(
                      label: 'Email Address',
                      hintText: 'name@studio.com',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 24.h),

                    // Password Field
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Password',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.atelierDark,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Forgot Password?',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF00897B), // Teal from design
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Obx(() => TextField(
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            color: AppColors.atelierDark,
                          ),
                          decoration: InputDecoration(
                            hintText: '........',
                            hintStyle: GoogleFonts.inter(
                              color: AppColors.textSecondary.withOpacity(0.5),
                              fontSize: 15.sp,
                            ),
                            filled: true,
                            fillColor: AppColors.atelierFieldBg.withOpacity(0.4),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value 
                                  ? Icons.visibility_off_outlined 
                                  : Icons.visibility_outlined,
                                size: 20.sp,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: AppColors.atelierFieldBg),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                          ),
                        )),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    // Sign In Button
                    Obx(() => CustomButton(
                      text: 'Sign In',
                      isLoading: controller.isLoading.value,
                      onPressed: controller.login,
                      icon: Icon(Icons.arrow_forward, color: Colors.tealAccent, size: 20.sp),
                    )),

                    SizedBox(height: 32.h),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.dividerColor)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'OR CONTINUE WITH',
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: AppColors.dividerColor)),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    // Social Buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Google',
                            isSecondary: true,
                            onPressed: controller.loginWithGoogle,
                            icon: Icon(Icons.g_mobiledata, size: 24.sp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // Bottom Links
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00897B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // Footer
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Text(
                    '© 2024 Atelier Studio. Crafted for creators. Secure & Private.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
