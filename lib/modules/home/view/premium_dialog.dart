import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/data/subscription_data.dart';
import '../../../app/services/purchase_service.dart';

class PremiumHomeBanner extends StatefulWidget {
  const PremiumHomeBanner({super.key});

  @override
  State<PremiumHomeBanner> createState() => _PremiumHomeBannerState();
}

class _PremiumHomeBannerState extends State<PremiumHomeBanner>
    with SingleTickerProviderStateMixin {
  static const _features = [
    {'icon': Icons.grid_view_rounded,     'title': 'Unlimited Templates', 'sub': '500+ pro designs'},
    {'icon': Icons.high_quality_rounded,  'title': 'HD Export',           'sub': 'Crystal-clear quality'},
    {'icon': Icons.water_drop_outlined,   'title': 'No Watermark',        'sub': 'Clean, brand-ready logos'},
    {'icon': Icons.font_download_rounded, 'title': 'All Fonts',           'sub': '80+ premium typefaces'},
  ];

  late final AnimationController _btnAnimCtrl;
  late final Animation<double> _btnAnim;

  @override
  void initState() {
    super.initState();
    _btnAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _btnAnim = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _btnAnimCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _btnAnimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
              color: const Color(0xFF008080).withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF008080).withValues(alpha: 0.15),
              blurRadius: 40,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header with decorative glow ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(24.w, 30.h, 24.w, 24.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF004D4D), Color(0xFF008080), Color(0xFF00A3A3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative glow circles
                  Positioned(
                    right: -20.w, top: -20.h,
                    child: Container(
                      width: 80.w, height: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFD700).withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -10.w, bottom: -10.h,
                    child: Container(
                      width: 50.w, height: 50.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.04),
                      ),
                    ),
                  ),
                  Column(children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(Icons.workspace_premium_rounded,
                          color: const Color(0xFFFFD700), size: 30.sp),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Unlock Everything',
                      style: GoogleFonts.outfit(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Get access to all premium features',
                      style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // ── 2×2 feature grid ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                  childAspectRatio: 2.2,
                ),
                itemCount: _features.length,
                itemBuilder: (_, i) {
                  final f = _features[i];
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF008080).withValues(alpha: 0.1),
                          const Color(0xFF008080).withValues(alpha: 0.04),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                          color: const Color(0xFF008080).withValues(alpha: 0.2)),
                    ),
                    child: Row(children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF008080).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(f['icon'] as IconData,
                            color: const Color(0xFF00B3B3), size: 16.sp),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              f['title'] as String,
                              style: GoogleFonts.outfit(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                              color: Colors.black87),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                            SizedBox(height: 2.h),
                            Text(
                              f['sub'] as String,
                              style: GoogleFonts.outfit(
                                  fontSize: 9.sp, color: Colors.black45),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ]),
                  );
                },
              ),
            ),

            SizedBox(height: 16.h),

            // ── Weekly price card ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF008080).withValues(alpha: 0.12),
                      const Color(0xFF008080).withValues(alpha: 0.04),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                      color: const Color(0xFF008080).withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.star_rounded,
                          color: const Color(0xFFFFD700), size: 18.sp),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Weekly Plan',
                            style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        Text('Cancel anytime',
                            style: GoogleFonts.outfit(
                                fontSize: 11.sp,
                                color: const Color(0xFF00B3B3),
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$4.99',
                            style: GoogleFonts.outfit(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        Text('per week',
                            style: GoogleFonts.outfit(
                                fontSize: 10.sp, color: Colors.black45)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // ── Purchase button with bounce animation ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: AnimatedBuilder(
                animation: _btnAnimCtrl,
                builder: (_, child) => Transform.translate(
                  offset: Offset(0, -_btnAnim.value),
                  child: child,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: Obx(() {
                    final ps = Get.find<PurchaseService>();
                    final isPurchasing = ps.isPurchasing.value;
                    return ElevatedButton(
                      onPressed: isPurchasing ? null : () async {
                        final plan = SubscriptionData.to.plans.firstWhere(
                          (p) => p.productId == 'com.xenderservices.logo.maker.weekly',
                          orElse: () => SubscriptionData.to.plans.first,
                        );
                        await ps.purchasePlan(plan);
                        if (ps.isSubscribed.value && Get.isDialogOpen == true) {
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A3A3),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFF00A3A3).withValues(alpha: 0.6),
                        elevation: 4,
                        shadowColor: const Color(0xFF008080).withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r)),
                      ),
                      child: isPurchasing
                          ? SizedBox(
                              width: 22.sp, height: 22.sp,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.auto_awesome_rounded, size: 18.sp),
                                SizedBox(width: 8.w),
                                Text(
                                  'Get Premium Now',
                                  style: GoogleFonts.outfit(
                                      fontSize: 15.sp, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                    );
                  }),
                ),
              ),
            ),

            SizedBox(height: 4.h),

            TextButton(
              onPressed: () => Get.back(),
              child: Text('Maybe later',
                  style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      color: Colors.black38,
                      fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: 6.h),
          ],
        ),
      ),
    );
  }
}
