import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../view_model/home_view_model.dart';
import '../../history/view/history_view.dart';
import '../../profile/view/profile_view.dart';
import '../../credits/view/credits_view.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/color_constants.dart';
import 'category_grid_view.dart';

class HomeView extends GetView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8), // soft off-white background
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Obx(() {
          switch (controller.selectedIndex.value) {
            case 0: return _buildHomeBody();
            case 1: return const HistoryView();
            case 2: return const CreditsView();
            case 3: return const ProfileView();
            default: return _buildHomeBody();
          }
        }),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateOptions(),
        backgroundColor: AppColors.accentPurpleBtn,
        shape: const CircleBorder(),
        elevation: 4,
        child: Icon(Icons.add, color: Colors.white, size: 32.sp),
      ),
    );
  }

  // ── HOME BODY ──
  Widget _buildHomeBody() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildTopBar()),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        SliverToBoxAdapter(child: _buildTopCategoriesRow()),
        SliverToBoxAdapter(child: SizedBox(height: 32.h)),
        SliverToBoxAdapter(child: _buildSection('Most Popular', controller.atelierProjects, isNew: true)),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(child: _buildSection('Esport', controller.atelierProjects.reversed.toList(), isNew: true)),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(child: _buildSection('AI', controller.atelierProjects, isNew: true)),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
        SliverToBoxAdapter(child: _buildSection('Fashion', controller.atelierProjects.reversed.toList(), isNew: true)),
        SliverToBoxAdapter(child: SizedBox(height: 100.h)),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        children: [
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Icon(Icons.menu, color: Colors.black87, size: 28.sp),
            ),
          ),
          SizedBox(width: 12.w),
          Text('LOGO MAKER', style: GoogleFonts.outfit(
            color: Colors.black87, fontSize: 18.sp, fontWeight: FontWeight.bold, letterSpacing: 0.5,
          )),
          const Spacer(),
          Icon(Icons.search, color: Colors.black87, size: 28.sp),
          SizedBox(width: 12.w),
          Obx(() => controller.isGuest.value
            ? GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.login),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.accentPurpleBtn,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Login',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () => controller.changeIndex(2),
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppColors.accentPurpleBtn.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.diamond_outlined, color: AppColors.accentPurpleBtn, size: 20.sp),
                ),
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCategoriesRow() {
    final cats = [
      {'icon': Icons.layers_clear, 'name': 'BG Remover'},
      {'icon': Icons.camera_alt_outlined, 'name': 'Instagram'},
      {'icon': Icons.badge_outlined, 'name': 'Business Card'},
      {'icon': Icons.play_circle_outline, 'name': 'Youtube'},
      {'icon': Icons.add_circle_outline, 'name': 'Instagram\nStory'},
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cats.map((cat) => GestureDetector(
          onTap: () => Get.to(() => CategoryGridView(title: cat['name'] as String, items: controller.atelierProjects)),
          child: Column(
            children: [
              Container(
                width: 54.w,
                height: 54.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F8),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Icon(cat['icon'] as IconData, color: Colors.black87, size: 26.sp),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                width: 60.w,
                child: Text(
                  cat['name'] as String,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(color: Colors.black87, fontSize: 10.sp, fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, String>> items, {bool isNew = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: GoogleFonts.outfit(color: Colors.black87, fontSize: 18.sp, fontWeight: FontWeight.bold)),
              if (isNew) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF39C12), // Orange badge color
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text('NEW', style: GoogleFonts.outfit(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                ),
              ],
              const Spacer(),
              GestureDetector(
                onTap: () => Get.to(() => CategoryGridView(title: title, items: items)),
                child: Text('See All', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 13.sp, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 110.w, // small square size
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final project = items[index];
              return GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.editor, arguments: {
                  'templateImage': project['image'],
                  'templateText': project['title'],
                  'templateTextColor': project['textColor'],
                }),
                child: Container(
                  width: 110.w,
                  margin: EdgeInsets.only(right: 12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2336),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(project['image']!, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter, end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 12.h, left: 8.w, right: 8.w),
                            child: Text(
                              project['title']!,
                              style: GoogleFonts.outfit(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── BOTTOM NAV ──
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomAppBar(
        color: const Color(0xFFE8E8EC), // Slightly gray
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 0,
      padding: EdgeInsets.zero,
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(0, Icons.home_filled, 'Home'),
            _buildNavItem(1, Icons.history, 'History'),
            SizedBox(width: 48.w), // Space for FAB
            _buildNavItem(2, Icons.account_balance_wallet_rounded, 'Credits'),
            _buildNavItem(3, Icons.person_rounded, 'Profile'),
          ],
        ),
      ),
    ));
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      final color = isSelected ? AppColors.accentPurpleBtn : Colors.grey.shade400;
      return GestureDetector(
        onTap: () => controller.changeIndex(index),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 60.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24.sp),
              SizedBox(height: 4.h),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: color,
                  fontSize: 10.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showCreateOptions() {
    if (controller.isGuest.value) {
      Get.toNamed(AppRoutes.login);
      return;
    }

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F8),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
            ),
            SizedBox(height: 24.h),
            Text('Create New Logo', style: GoogleFonts.outfit(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 32.h),
            GestureDetector(
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.aiGenerator);
              },
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEF4),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(color: AppColors.themeGradientStart.withOpacity(0.1), shape: BoxShape.circle),
                      child: Icon(Icons.auto_awesome, color: AppColors.themeGradientStart, size: 24.sp),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create with AI', style: GoogleFonts.outfit(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
                          SizedBox(height: 4.h),
                          Text('Generate a unique logo using AI', style: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16.sp),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.editor);
              },
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEF4),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(color: AppColors.themeGradientEnd.withOpacity(0.1), shape: BoxShape.circle),
                      child: Icon(Icons.edit_rounded, color: AppColors.themeGradientEnd, size: 24.sp),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create Manually', style: GoogleFonts.outfit(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
                          SizedBox(height: 4.h),
                          Text('Start from scratch in the editor', style: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16.sp),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFFF4F4F8),
      child: SafeArea(
        child: Column(
          children: [
            // ── Gradient Header ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 28.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.themeGradientStart, AppColors.themeGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // App Logo
                  Container(
                    width: 72.w,
                    height: 72.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18.r),
                      child: Image.asset(
                        'assets/images/logo1.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'LOGO MAKER',
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Atelier Design Studio',
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Go Premium Button
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      controller.changeIndex(2);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.workspace_premium_rounded, color: const Color(0xFFFFB700), size: 18.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Go Premium',
                            style: GoogleFonts.outfit(
                              color: AppColors.themeGradientStart,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Menu Items ──
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                children: [
                  _buildDrawerSection('GENERAL'),
                  _buildDrawerTile(Icons.info_outline_rounded, 'How To Use', onTap: () {
                    Get.back();
                    Get.snackbar('How To Use', 'Tutorial coming soon!', snackPosition: SnackPosition.BOTTOM);
                  }),
                  _buildDrawerTile(Icons.star_border_rounded, 'Rate Us', onTap: () {
                    Get.back();
                    Get.snackbar('Rate Us', 'Thank you for your support!', snackPosition: SnackPosition.BOTTOM);
                  }),
                  _buildDrawerTile(Icons.share_rounded, 'Share App', onTap: () {
                    Get.back();
                    Get.snackbar('Share App', 'Sharing options coming soon!', snackPosition: SnackPosition.BOTTOM);
                  }),
                  _buildDrawerTile(Icons.support_agent_rounded, 'Customer Support', onTap: () {
                    Get.back();
                    Get.snackbar('Support', 'Support coming soon!', snackPosition: SnackPosition.BOTTOM);
                  }),

                  SizedBox(height: 8.h),
                  _buildDrawerSection('LEGAL'),
                  _buildDrawerTile(Icons.description_outlined, 'Terms & Conditions', onTap: () async {
                    Get.back();
                    final url = Uri.parse('https://logomaker-6d294.web.app/terms.html');
                    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
                  }),
                  _buildDrawerTile(Icons.privacy_tip_outlined, 'Privacy Policy', onTap: () async {
                    Get.back();
                    final url = Uri.parse('https://logomaker-6d294.web.app/privacy.html');
                    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
                  }),
                ],
              ),
            ),

            // ── Footer ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Text(
                '© 2026 Atelier Studio. All rights reserved.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 10.sp,
                  color: Colors.black38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerSection(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 4.h),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black38,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildDrawerTile(IconData icon, String title, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.accentPurpleBtn.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: AppColors.accentPurpleBtn, size: 20.sp),
              ),
              SizedBox(width: 16.w),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, color: Colors.black26, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }
}

