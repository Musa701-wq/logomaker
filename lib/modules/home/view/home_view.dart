import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/utils/color_constants.dart';
import '../view_model/home_view_model.dart';
import '../../history/view/history_view.dart';
import '../../profile/view/profile_view.dart';
import '../../../app/routes/app_routes.dart';

class HomeView extends GetView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.premiumDark,
      body: SafeArea(
        child: Obx(() {
          switch (controller.selectedIndex.value) {
            case 0: return _buildHomeBody();
            case 1: return const HistoryView();
            case 2: return _buildProjectsBody();
            case 3: return const ProfileView();
            default: return _buildHomeBody();
          }
        }),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: Obx(() => controller.selectedIndex.value == 0
          ? FloatingActionButton(
              onPressed: () => Get.toNamed(AppRoutes.editor),
              backgroundColor: AppColors.accentPurpleBtn,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
              child: Icon(Icons.add, color: Colors.white, size: 28.sp),
            )
          : const SizedBox.shrink()),
    );
  }

  // ── HOME BODY ──
  Widget _buildHomeBody() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Top bar
        SliverToBoxAdapter(child: _buildTopBar()),

        // Hero card
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _buildHeroCard(),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 28.h)),

        // Start from a vision
        SliverToBoxAdapter(child: _buildVisionHeader()),

        // Category chips
        SliverToBoxAdapter(child: _buildCategoryChips()),

        SliverToBoxAdapter(child: SizedBox(height: 16.h)),

        // Your Atelier header
        SliverToBoxAdapter(child: _buildAtelierHeader()),

        // Atelier grid
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14.h,
              crossAxisSpacing: 14.w,
              childAspectRatio: 0.82,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, i) => _buildAtelierCard(controller.atelierProjects[i]),
              childCount: controller.atelierProjects.length,
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 100.h)),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
      child: Row(
        children: [
          Container(
            width: 36.w, height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.accentPurpleBtn.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.auto_awesome, color: AppColors.accentPurpleBtn, size: 18.sp),
          ),
          SizedBox(width: 10.w),
          Text('Luminous', style: GoogleFonts.outfit(
            color: AppColors.accentPurpleBtn, fontSize: 20.sp, fontWeight: FontWeight.bold,
          )),
          const Spacer(),
          Container(
            width: 38.w, height: 38.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accentPurpleBtn, width: 2),
              image: const DecorationImage(image: AssetImage('assets/images/logo1.jpg'), fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1040), Color(0xFF0F1628)],
        ),
        border: Border.all(color: AppColors.accentPurpleBtn.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.outfit(fontSize: 28.sp, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
              children: const [
                TextSpan(text: 'Craft your '),
                TextSpan(text: 'legacy', style: TextStyle(color: Color(0xFF9C6FFF))),
                TextSpan(text: '\nin light.'),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'The world\'s most intuitive workspace for high-end brand identities and professional logos.',
            style: GoogleFonts.outfit(color: Colors.white54, fontSize: 13.sp, height: 1.5),
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.editor, arguments: {
              'templateImage': 'assets/images/logo.png',
              'templateText': 'Esport',
            }),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.accentPurpleBtn,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [BoxShadow(color: AppColors.accentPurpleBtn.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 6))],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text('Create New Logo', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisionHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start from a vision', style: GoogleFonts.outfit(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 2.h),
              Text('Select a style to begin your creative journey', style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12.sp)),
            ],
          ),
          Text('VIEW ALL', style: GoogleFonts.outfit(color: AppColors.accentPurpleBtn, fontSize: 11.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 36.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: controller.styleCategories.map((cat) => Obx(() {
          final isSel = controller.selectedStyle.value == cat;
          return GestureDetector(
            onTap: () => controller.selectedStyle.value = cat,
            child: Container(
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSel ? AppColors.accentPurpleBtn : AppColors.cardDark,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: isSel ? AppColors.accentPurpleBtn : Colors.white12),
              ),
              child: Text(cat, style: GoogleFonts.outfit(
                color: isSel ? Colors.white : Colors.white54,
                fontSize: 13.sp, fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
              )),
            ),
          );
        })).toList(),
      ),
    );
  }

  Widget _buildAtelierHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 16.h),
      child: Text('Your Atelier', style: GoogleFonts.outfit(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAtelierCard(Map<String, String> project) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.editor, arguments: {
        'templateImage': project['image'],
        'templateText': project['title'],
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(project['image']!, fit: BoxFit.cover),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project['title']!, style: GoogleFonts.outfit(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(project['time']!, style: GoogleFonts.outfit(color: Colors.white38, fontSize: 11.sp)),
                  ],
                ),
              ),
              Icon(Icons.open_in_new_rounded, color: Colors.white38, size: 16.sp),
            ],
          ),
        ],
      ),
    );
  }

  // ── PROJECTS BODY ──
  Widget _buildProjectsBody() {
    return Center(child: Text('Projects', style: GoogleFonts.outfit(color: Colors.white, fontSize: 20.sp)));
  }

  // ── BOTTOM NAV ──
  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.brush_outlined, 'filledIcon': Icons.brush_rounded, 'label': 'STUDIO'},
      {'icon': Icons.grid_view_outlined, 'filledIcon': Icons.grid_view_rounded, 'label': 'TEMPLATES'},
      {'icon': Icons.folder_outlined, 'filledIcon': Icons.folder_rounded, 'label': 'PROJECTS'},
      {'icon': Icons.settings_outlined, 'filledIcon': Icons.settings_rounded, 'label': 'SETTINGS'},
    ];
    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: AppColors.panelDark,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isSel = controller.selectedIndex.value == i;
          return GestureDetector(
            onTap: () => controller.changeIndex(i),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.accentPurpleBtn.withOpacity(0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    isSel ? (items[i]['filledIcon'] as IconData) : (items[i]['icon'] as IconData),
                    color: isSel ? AppColors.accentPurpleBtn : Colors.white38,
                    size: 22.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(items[i]['label'] as String, style: GoogleFonts.outfit(
                  color: isSel ? AppColors.accentPurpleBtn : Colors.white38,
                  fontSize: 9.sp, fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                )),
              ],
            ),
          );
        }),
      )),
    );
  }
}
