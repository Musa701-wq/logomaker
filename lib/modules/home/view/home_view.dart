import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../../app/utils/color_constants.dart';
import '../view_model/home_view_model.dart';
import '../../history/view/history_view.dart';
import '../../profile/view/profile_view.dart';
import '../../credits/view/credits_view.dart';
import '../../../app/routes/app_routes.dart';

class HomeView extends GetView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D13),
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
      floatingActionButton: Obx(() => controller.selectedIndex.value == 0
          ? Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: FloatingActionButton(
                onPressed: () => controller.onCreateNewLogo(),
                backgroundColor: const Color(0xFF7B2FBE),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
                child: Icon(Icons.add, color: Colors.white, size: 28.sp),
              ),
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
              color: const Color(0xFF7B2FBE).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.auto_awesome, color: const Color(0xFF7B2FBE), size: 18.sp),
          ),
          SizedBox(width: 10.w),
          Text('Luminous', style: GoogleFonts.outfit(
            color: const Color(0xFF7B2FBE), fontSize: 20.sp, fontWeight: FontWeight.bold,
          )),
          const Spacer(),
          Obx(() => controller.isGuest.value 
            ? GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.login),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B2FBE).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: const Color(0xFF7B2FBE).withOpacity(0.3)),
                  ),
                  child: Text(
                    'LOGIN',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF7B2FBE),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : Container(
                width: 38.w, height: 38.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF7B2FBE), width: 2),
                  image: const DecorationImage(image: AssetImage('assets/images/logo1.jpg'), fit: BoxFit.cover),
                ),
              )),
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
        border: Border.all(color: const Color(0xFF7B2FBE).withOpacity(0.2)),
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
            onTap: () => controller.onCreateNewLogo(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFF7B2FBE),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [BoxShadow(color: const Color(0xFF7B2FBE).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 6))],
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
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.templates),
            child: Text('VIEW ALL', style: GoogleFonts.outfit(color: const Color(0xFF7B2FBE), fontSize: 11.sp, fontWeight: FontWeight.bold)),
          ),
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
                color: isSel ? const Color(0xFF7B2FBE) : const Color(0xFF1A1D25),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: isSel ? const Color(0xFF7B2FBE) : Colors.white12),
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
                color: const Color(0xFF2B2E7A),
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


  // ── BOTTOM NAV ──
  Widget _buildBottomNav() {
    return Obx(() => CurvedNavigationBar(
      backgroundColor: const Color(0xFF0B0D13), // Match Scaffold background
      color: const Color(0xFF1A1D25),
      buttonBackgroundColor: const Color(0xFF7B2FBE),
      height: 60,
      animationDuration: const Duration(milliseconds: 300),
      items: const <Widget>[
        Icon(Icons.brush_rounded, size: 30, color: Colors.white),
        Icon(Icons.grid_view_rounded, size: 30, color: Colors.white),
        Icon(Icons.account_balance_wallet_rounded, size: 30, color: Colors.white),
        Icon(Icons.person_rounded, size: 30, color: Colors.white),
      ],
      index: controller.selectedIndex.value,
      onTap: (index) {
        controller.changeIndex(index);
      },
    ));
  }
}
