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
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                if (!controller.isAnimating.value) return const SizedBox();
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),
                      _buildHeroCard(),
                      SizedBox(height: 20.h),
                      _buildPlansSection(),
                      SizedBox(height: 20.h),
                      _buildFeaturesSection(),
                      SizedBox(height: 24.h),
                      _buildSubscribeButton(),
                      SizedBox(height: 12.h),
                      _buildSkipLink(),
                      SizedBox(height: 32.h),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Logo Maker Pro', style: GoogleFonts.outfit(
                    fontSize: 22.sp, fontWeight: FontWeight.w800, color: Colors.black87,
                  )),
                  SizedBox(height: 2.h),
                  Text('Unlock premium features', style: GoogleFonts.outfit(
                    fontSize: 13.sp, color: Colors.black45,
                  )),
                ],
              ),
              GestureDetector(
                onTap: controller.onGetStarted,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBackground,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text('Skip', style: GoogleFonts.outfit(
                    fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black45,
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video placeholder — replace with your video player widget
            Container(
              color: Colors.black,
              child: Center(
                child: Icon(Icons.play_circle_outline_rounded, color: Colors.white.withValues(alpha: 0.5), size: 48.sp),
              ),
            ),
            // Gradient overlay
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                height: 100.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Logo Maker Pro', style: GoogleFonts.outfit(
                      fontSize: 18.sp, fontWeight: FontWeight.w800, color: Colors.white,
                    )),
                    SizedBox(height: 2.h),
                    Text('Create stunning logos in minutes', style: GoogleFonts.outfit(
                      fontSize: 12.sp, color: Colors.white.withValues(alpha: 0.7),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlansSection() {
    return Obx(() => Row(
      children: controller.plans.asMap().entries.map((entry) {
        final index = entry.key;
        final plan = entry.value;
        final isSelected = controller.selectedPlanIndex.value == index;
        final Color accentColor = Color(plan.color);
        return Expanded(
          child: GestureDetector(
            onTap: () => controller.selectedPlanIndex.value = index,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected ? accentColor : Colors.grey.withValues(alpha: 0.2),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: accentColor.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4))]
                    : [],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (plan.isPopular)
                    Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text('BEST', style: GoogleFonts.outfit(
                        fontSize: 8.sp, fontWeight: FontWeight.bold, color: Colors.white,
                      )),
                    )
                  else
                    SizedBox(height: 16.h),
                  Text(plan.title, style: GoogleFonts.outfit(
                    fontSize: 13.sp, fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.black87 : Colors.black45,
                  )),
                  SizedBox(height: 8.h),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(plan.price, style: GoogleFonts.outfit(
                      fontSize: 24.sp, fontWeight: FontWeight.w900,
                      color: accentColor,
                    )),
                  ),
                  Text(plan.period, style: GoogleFonts.outfit(
                    fontSize: 10.sp, color: Colors.black38,
                  )),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }

  Widget _buildFeaturesSection() {
    return Obx(() {
      final plan = controller.plans[controller.selectedPlanIndex.value];
      final Color accentColor = Color(plan.color);
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What\'s included', style: GoogleFonts.outfit(
              fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.black87,
            )),
            SizedBox(height: 12.h),
            ...plan.features.map((f) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Container(
                    width: 20.w, height: 20.w,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_rounded, color: accentColor, size: 13.sp),
                  ),
                  SizedBox(width: 10.w),
                  Flexible(
                    child: Text(f, style: GoogleFonts.outfit(
                      fontSize: 13.sp, color: Colors.black87,
                    )),
                  ),
                ],
              ),
            )),
          ],
        ),
      );
    });
  }

  Widget _buildSubscribeButton() {
    return Obx(() {
      final plan = controller.plans[controller.selectedPlanIndex.value];
      final Color accentColor = Color(plan.color);
      final bool loading = controller.isPurchasing.value;
      return GestureDetector(
        onTap: loading ? null : () => controller.onSubscribe(controller.selectedPlanIndex.value),
        child: Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: loading
                ? SizedBox(width: 22.sp, height: 22.sp, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                : Text('Subscribe  ${plan.price}${plan.period}', style: GoogleFonts.outfit(
                    fontSize: 16.sp, fontWeight: FontWeight.w800, color: Colors.white,
                  )),
          ),
        ),
      );
    });
  }

  Widget _buildSkipLink() {
    return GestureDetector(
      onTap: controller.onGetStarted,
      child: Text(
        'Continue with free version',
        style: GoogleFonts.outfit(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black38,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
