import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/color_constants.dart';
import '../../../app/widgets/cached_image.dart';
import '../../../app/widgets/shimmer_loading.dart';
import '../../../app/data/subscription_data.dart';
import '../../../app/services/purchase_service.dart';
import '../../home/view_model/home_view_model.dart';
import '../view_model/templates_view_model.dart';

class TemplatesView extends GetView<TemplatesViewModel> {
  const TemplatesView({super.key});

  // ── Premium paywall dialog ──────────────────────────────────────────────────
  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (_) => const _PremiumDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.premiumDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Templates',
          style: GoogleFonts.outfit(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune_rounded, color: Colors.white70, size: 22.sp),
            onPressed: () {},
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1D25),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Obx(() => TextField(
                onChanged: controller.onSearch,
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: 'Search logo templates...',
                  hintStyle: GoogleFonts.outfit(color: Colors.white24, fontSize: 14.sp),
                  prefixIcon: Icon(Icons.search_rounded, color: Colors.white24, size: 20.sp),
                  suffixIcon: controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close_rounded, color: Colors.white24, size: 18.sp),
                        onPressed: () => controller.onSearch(''),
                      )
                    : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                ),
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: controller.searchQuery.value,
                    selection: TextSelection.collapsed(offset: controller.searchQuery.value.length),
                  ),
                ),
              )),
            ),
          ),

          // Categories
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return Obx(() {
                  final isSelected = controller.selectedCategory.value == category;
                  return GestureDetector(
                    onTap: () => controller.onCategorySelected(category),
                    child: Container(
                      margin: EdgeInsets.only(right: 10.w),
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF008080) : const Color(0xFF1A1D25),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF008080) : Colors.white.withOpacity(0.05),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        category,
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.white38,
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),

          SizedBox(height: 24.h),

          // Templates Grid
          Expanded(
            child: Obx(() {
              // premium check — logged-in user = premium
              final homeVm = Get.find<HomeViewModel>();
              final isPremium = !homeVm.isGuest.value;

              if (controller.isLoading.value) {
                return GridView.builder(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h, top: 10.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: 6,
                  itemBuilder: (_, __) => ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: ShimmerLoading(
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: 16,
                    ),
                  ),
                );
              }

              if (controller.filteredTemplates.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_rounded, color: Colors.white10, size: 60.sp),
                      SizedBox(height: 16.h),
                      Text(
                        'No templates found',
                        style: GoogleFonts.outfit(color: Colors.white24, fontSize: 16.sp),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing: 16.w,
                  childAspectRatio: 0.85,
                ),
                itemCount: controller.filteredTemplates.length,
                itemBuilder: (context, index) {
                  final template = controller.filteredTemplates[index];
                  // First 3 templates are free; rest require premium
                  final isLocked = !isPremium && index >= 3;

                  return GestureDetector(
                    onTap: () {
                      if (isLocked) {
                        _showPremiumDialog(context);
                      } else {
                        Get.toNamed(AppRoutes.editor, arguments: {
                          'templateImage': template['image'],
                          'templateText': template['title'],
                          'templateTextColor': template['textColor'],
                        });
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              // Template image
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1D25),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: CachedImage(
                                    template['image']!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(color: Colors.grey[850]),
                                  ),
                                ),
                              ),

                              // Lock overlay
                              if (isLocked)
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.55),
                                        borderRadius: BorderRadius.circular(16.r),
                                      ),
                                      child: Center(
                                        child: Container(
                                          padding: EdgeInsets.all(10.w),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF008080).withOpacity(0.9),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.lock_rounded,
                                            color: Colors.white,
                                            size: 20.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              // "FREE" badge on first 3
                              if (!isLocked && index < 3)
                                Positioned(
                                  top: 8.h,
                                  right: 8.w,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF008080),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      'FREE',
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                template['title']!,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isLocked ? Colors.white38 : Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                template['subtitle']!,
                                style: GoogleFonts.outfit(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary.withOpacity(0.35),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Premium Dialog ─────────────────────────────────────────────────────────────
class _PremiumDialog extends StatefulWidget {
  const _PremiumDialog();

  @override
  State<_PremiumDialog> createState() => _PremiumDialogState();
}

class _PremiumDialogState extends State<_PremiumDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _marqueeCtrl;

  static const _marqueeText =
      'Unlimited templates  •  HD export  •  No watermark  •  All fonts  •  Priority support  •  ';

  final GlobalKey _segKey = GlobalKey();
  double _segWidth = 1000;

  @override
  void initState() {
    super.initState();
    _marqueeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = _segKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && mounted) {
        setState(() => _segWidth = box.size.width);
      }
    });
  }

  @override
  void dispose() {
    _marqueeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: const Color(0xFF008080).withOpacity(0.25), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header gradient banner ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF005F5F), Color(0xFF008080)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  Icon(Icons.workspace_premium_rounded,
                      color: const Color(0xFFFFD700), size: 36.sp),
                  SizedBox(height: 10.h),
                  Text(
                    'Go Premium',
                    style: GoogleFonts.outfit(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Unlock all templates and pro tools',
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // ── Marquee strip ──
            Container(
              width: double.infinity,
              height: 30.h,
              color: const Color(0xFF008080).withOpacity(0.12),
              clipBehavior: Clip.hardEdge,
              child: AnimatedBuilder(
                animation: _marqueeCtrl,
                builder: (_, __) {
                  final offset = -(_marqueeCtrl.value * _segWidth);
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _marqueeSegment(key: _segKey),
                        _marqueeSegment(),
                        _marqueeSegment(),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20.h),

            // ── Feature bullets ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: const [
                  _FeatureRow(icon: Icons.grid_view_rounded,       label: 'All templates unlocked'),
                  _FeatureRow(icon: Icons.high_quality_rounded,    label: 'HD & transparent export'),
                  _FeatureRow(icon: Icons.water_drop_outlined,     label: 'No watermark'),
                  _FeatureRow(icon: Icons.font_download_rounded,   label: 'All premium fonts'),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // ── Price card ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF008080).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFF008080).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Plan',
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Cancel anytime',
                          style: GoogleFonts.outfit(
                            fontSize: 11.sp,
                            color: const Color(0xFF008080),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$4.99',
                          style: GoogleFonts.outfit(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'per week',
                          style: GoogleFonts.outfit(
                            fontSize: 10.sp,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // ── Purchase button ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                      backgroundColor: const Color(0xFF008080),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF008080).withOpacity(0.6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: isPurchasing
                        ? SizedBox(
                            width: 20.sp, height: 20.sp,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ))
                        : Text(
                            'Start Premium',
                            style: GoogleFonts.outfit(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                  );
                }),
              ),
            ),

            // ── Dismiss ──
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Maybe later',
                style: GoogleFonts.outfit(
                  fontSize: 12.sp,
                  color: Colors.white24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _marqueeSegment({Key? key}) {
    return SizedBox(
      key: key,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 40.w),
          Text(
            _marqueeText,
            style: GoogleFonts.outfit(
              fontSize: 11.sp,
              color: const Color(0xFF008080),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF008080), size: 16.sp),
          SizedBox(width: 12.w),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
