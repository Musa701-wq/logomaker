import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/models/subscription_plan.dart';
import '../view_model/credits_view_model.dart';

class CreditsView extends GetView<CreditsViewModel> {
  const CreditsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CreditsViewModel());
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildSubscriptionCard(),
            SizedBox(height: 30.h),
            _buildCreativeCapitalSection(),
            SizedBox(height: 40.h),
            _buildPlansSection(),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Center(
        child: Text(
          'Logo Maker',
          style: GoogleFonts.outfit(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF008080),
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 250.w,
            height: 250.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF008080).withValues(alpha: 0.15),
                  const Color(0xFF008080).withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Container(
            width: 220.w,
            height: 220.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF4F4F8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF008080).withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
          ),
          Container(
            width: 195.w,
            height: 195.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF008080).withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
          ),
          Obx(() {
            if (controller.isSubscribed.value) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_rounded,
                      color: const Color(0xFF008080), size: 28.sp),
                  SizedBox(height: 6.h),
                  Text(
                    'SUBSCRIBED',
                    style: GoogleFonts.outfit(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    controller.activePlanTitle.value,
                    style: GoogleFonts.outfit(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF008080),
                    ),
                  ),
                  Text(
                    'Expires ${controller.expiryDate.value}',
                    style: GoogleFonts.outfit(
                      fontSize: 11.sp,
                      color: Colors.black45,
                    ),
                  ),
                ],
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.subscriptions_outlined,
                    color: Colors.black26, size: 28.sp),
                SizedBox(height: 6.h),
                Text(
                  'NOT SUBSCRIBED',
                  style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 6.h),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCreativeCapitalSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          Text(
            'Your Subscription',
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Subscribe to unlock unlimited logo designs and premium tools.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              color: Colors.black45,
              height: 1.6,
            ),
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0xFF008080),
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF008080).withValues(alpha: 0.35),
                    blurRadius: 18,
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

  Widget _buildPlansSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PLANS',
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF008080),
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Choose Your Plan',
            style: GoogleFonts.outfit(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20.h),
          Obx(() => Column(
            children: controller.plans.asMap().entries.map((entry) {
              final index = entry.key;
              final plan = entry.value;
              return _buildPlanCard(plan, index);
            }).toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan, int index) {
    final Color accentColor = Color(plan.color);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F8),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: plan.isPopular
              ? accentColor.withValues(alpha: 0.4)
              : Colors.grey.withValues(alpha: 0.12),
          width: plan.isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: plan.isPopular
                ? accentColor.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        plan.title,
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        plan.price,
                        style: GoogleFonts.outfit(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.h),
                      child: Text(
                        plan.period,
                        style: GoogleFonts.outfit(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  'ID: ${plan.productId}',
                  style: GoogleFonts.outfit(
                    fontSize: 9.sp,
                    color: Colors.black26,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 14.h),
                ...plan.features.map((feature) => Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: accentColor, size: 15.sp),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: Text(
                              feature,
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                color: Colors.black54,
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: () => controller.subscribe(index),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Obx(() => Text(
                controller.isPurchasing.value ? 'Processing...' : 'Subscribe',
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
