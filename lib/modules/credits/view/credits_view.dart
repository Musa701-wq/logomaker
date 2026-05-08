import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_model/credits_view_model.dart';

class CreditsView extends StatelessWidget {
  const CreditsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreditsViewModel());

    return Scaffold(
      backgroundColor: const Color(0xFF0B0D13), // Premium Dark
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20.h),
            _buildCreditsCircle(controller),
            SizedBox(height: 30.h),
            _buildCreativeCapitalSection(),
            SizedBox(height: 40.h),
            _buildStoreSection(controller),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        children: [
          const Spacer(),
          Text(
            'Digital Atelier',
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF7B2FBE), width: 2),
              image: const DecorationImage(
                image: AssetImage('assets/images/logo1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditsCircle(CreditsViewModel controller) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer subtle glow
          Container(
            width: 240.w,
            height: 240.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7B2FBE).withOpacity(0.1),
                  blurRadius: 50,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          // Inner Dark Circle
          Container(
            width: 220.w,
            height: 220.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1A1D25),
              border: Border.all(
                color: const Color(0xFF7B2FBE).withOpacity(0.2),
                width: 1.5,
              ),
            ),
          ),
          // Ring
          Container(
            width: 190.w,
            height: 190.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
                width: 1,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AVAILABLE',
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white38,
                  letterSpacing: 1.2,
                ),
              ),
              Obx(() => Text(
                    controller.availableCredits.value.toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},'),
                    style: GoogleFonts.outfit(
                      fontSize: 48.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF7B2FBE),
                    ),
                  )),
              Text(
                'Credits',
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreativeCapitalSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        children: [
          Text(
            'Your Creative Capital',
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Power your imagination with the Digital Atelier\'s credit system. Every generation is a step toward your masterpiece.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              color: Colors.white54,
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B2FBE), Color(0xFF9C6FFF)],
                ),
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B2FBE).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Text(
                'Manage Subscription',
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreSection(CreditsViewModel controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'THE STORE',
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF7B2FBE),
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Quick Top-up',
            style: GoogleFonts.outfit(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 24.h),
          // Vertical List of Plans
          ...controller.topUpPlans.asMap().entries.map((entry) {
            final index = entry.key;
            final plan = entry.value;
            return _buildPlanCard(plan, () => controller.buyPlan(index));
          }),
        ],
      ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan, VoidCallback onTap) {
    final bool isPopular = plan['isPopular'] ?? false;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D25),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isPopular ? const Color(0xFF7B2FBE).withOpacity(0.5) : Colors.white.withOpacity(0.05),
          width: isPopular ? 1.5 : 1,
        ),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          plan['title'],
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (isPopular) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7B2FBE),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              'POPULAR',
                              style: GoogleFonts.outfit(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          plan['credits'],
                          style: GoogleFonts.outfit(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF7B2FBE),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.h),
                          child: Text(
                            'CREDITS',
                            style: GoogleFonts.outfit(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white38,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    ...(plan['features'] as List<String>).map((feature) => Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_outline_rounded,
                                  color: const Color(0xFF7B2FBE), size: 14.sp),
                              SizedBox(width: 8.w),
                              Text(
                                feature,
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Text(
                    plan['price'],
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
