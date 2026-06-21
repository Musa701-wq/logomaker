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
import '../../../app/widgets/cached_image.dart';
import '../../../app/utils/text_label_patterns.dart';
import 'category_grid_view.dart';

class HomeView extends GetView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black87, size: 24.sp),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text('LOGO MAKER', style: GoogleFonts.outfit(
          color: Colors.black87, fontSize: 18.sp, fontWeight: FontWeight.bold, letterSpacing: 0.5,
        )),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black87, size: 24.sp),
            onPressed: () => _showSearch(),
          ),
          Obx(() => controller.isGuest.value
            ? Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.login),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF008080),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text('Login', style: GoogleFonts.outfit(
                      color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold,
                    )),
                  ),
                ),
              )
            : IconButton(
                icon: Icon(Icons.diamond_outlined, color: const Color(0xFF008080), size: 24.sp),
                onPressed: () => controller.changeIndex(2),
              ),
          ),
        ],
      ),
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
        backgroundColor: const Color(0xFF008080),
        shape: const CircleBorder(),
        elevation: 4,
        child: Icon(Icons.add, color: Colors.white, size: 32.sp),
      ),
    );
  }

  // ── SEARCH ──
  void _showSearch() {
    showSearch(
      context: Get.context!,
      delegate: _TemplateSearchDelegate(controller),
    );
  }

  // ── HOME BODY ──
  Widget _buildHomeBody() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerSections();
      }

      if (controller.sections.isEmpty) return const SizedBox.shrink();
      final section = controller.sections.first;

      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 8.h)),
          SliverToBoxAdapter(child: _buildTopCategoriesRow()),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          for (int i = 0; i < section.folders.length; i++)
            if (controller.folderData.containsKey(section.folders[i])) ...[
              SliverToBoxAdapter(
                child: _buildFolderSection(section.folders[i], '${section.storagePrefix}/${section.folders[i]}', i),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            ],
          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      );
    });
  }

  // Removed _buildTopBar - replaced by AppBar

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
          onTap: () {
            final firstKey = controller.folderData.keys.isNotEmpty ? controller.folderData.keys.first : '';
            final items = firstKey.isNotEmpty ? (controller.folderData[firstKey] ?? <Map<String, String>>[]) : <Map<String, String>>[];
            Get.to(() => CategoryGridView(title: cat['name'] as String, items: items));
          },
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

  Widget _buildFolderSection(String folderName, String storagePath, int folderIndex) {
    final items = controller.folderData[folderName] ?? [];
    if (items.isEmpty) return const SizedBox.shrink();
    final titleStyle = _uniformTitleStyle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_folderTitle(folderName), style: titleStyle),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF39C12),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text('NEW', style: GoogleFonts.outfit(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.to(() => CategoryGridView(
                    title: folderName,
                    items: const [],
                    storagePath: storagePath,
                  ));
                },
                child: Text('View All', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 13.sp, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 110.w,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final project = items[index];
              return GestureDetector(
                onTap: () {
                  final patternIdx = patternIndexFor(project['image'] ?? folderName);
                  Get.toNamed(AppRoutes.editor, arguments: {
                    'templateImage': project['image'],
                    'templateText': _folderTitle(folderName),
                    'templateTextColor': project['textColor'],
                    'patternIndex': patternIdx,
                  });
                },
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
                        CachedImage(
                          project['image']!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: Colors.grey[800]),
                        ),
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
                            padding: EdgeInsets.only(bottom: 10.h, left: 6.w, right: 6.w),
                            child: Builder(builder: (_) {
                              final p = patternFor(project['image'] ?? folderName);
                              return Text(
                                _folderTitle(folderName),
                                style: GoogleFonts.getFont(
                                  p.fontFamily,
                                  fontWeight: p.fontWeight,
                                  color: p.color,
                                  fontSize: 11.sp,
                                  letterSpacing: p.letterSpacing.clamp(0, 2),
                                  shadows: p.glowRadius > 0
                                      ? [Shadow(color: p.glowColor, blurRadius: p.glowRadius)]
                                      : null,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              );
                            }),
                          ),
                        ),
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
      final color = isSelected ? const Color(0xFF008080) : Colors.grey.shade400;
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
                      decoration: BoxDecoration(color: const Color(0xFF008080).withOpacity(0.1), shape: BoxShape.circle),
                      child: Icon(Icons.edit_rounded, color: const Color(0xFF008080), size: 24.sp),
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
              decoration: const BoxDecoration(
                color: Color(0xFF008080),
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
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Column(
                    children: [
                      Text(
                        controller.currentUser?.displayName ?? 'Guest',
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        controller.currentUser?.email ?? 'Sign in to personalize',
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
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
                              color: const Color(0xFF008080),
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
                    Get.toNamed(AppRoutes.howToUse);
                  }),
                  _buildDrawerTile(Icons.star_border_rounded, 'Rate Us', onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.rateUs);
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
                  color: const Color(0xFF008080).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: const Color(0xFF008080), size: 20.sp),
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

  // 10 rotating text style patterns for folder section titles — REMOVED
  // Now using uniform title style

  TextStyle _uniformTitleStyle() => GoogleFonts.outfit(
        color: Colors.black87,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      );
  String _folderTitle(String name) {
    const map = {
      'abstract': 'Abstract',
      'animals': 'Animals',
      'butterfly': 'Butterfly',
      'camera': 'Camera',
      'car': 'Car',
      'circle': 'Circle',
      'corporal': 'Corporal',
      'dog': 'Dog',
      'farmer': 'Farmer',
      'festival': 'Festival',
      'field': 'Field',
      'flowers': 'Flowers',
      'fly': 'Fly',
      'functions': 'Functions',
      'games': 'Games',
      'hallowean': 'Halloween',
      'heart': 'Heart',
      'holiday': 'Holiday',
      'leaf': 'Leaf',
      'music': 'Music',
      'ngo': 'NGO',
      'party': 'Party',
      'profession': 'Profession',
      'restaurant': 'Restaurant',
      'simple': 'Simple',
      'social': 'Social',
      'spots': 'Sports',
      'square': 'Square',
      'star': 'Star',
      'text': 'Text',
      'tools': 'Tools',
      'toy': 'Toy',
      'video': 'Video',
    };
    return map[name] ?? name[0].toUpperCase() + name.substring(1);
  }

  Widget _buildShimmerSections() {
    final folders = HomeViewModel.allSections.isNotEmpty
        ? HomeViewModel.allSections.first.folders
        : <String>[];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        children: folders.asMap().entries.map((entry) {
          final i = entry.key;
          final folderName = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    _folderTitle(folderName),
                    style: _uniformTitleStyle(),
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  height: 110.w,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: 5,
                    itemBuilder: (_, __) => Container(
                      width: 110.w,
                      margin: EdgeInsets.only(right: 12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2336),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFBDBDBD),
                          ),
                         ),
                      ),
                    ),
                  ),
                ), 
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TemplateSearchDelegate extends SearchDelegate<String> {
  final HomeViewModel controller;

  _TemplateSearchDelegate(this.controller);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: GoogleFonts.outfit(color: Colors.black38, fontSize: 14.sp),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear_rounded, color: Colors.black54, size: 22.sp),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_rounded, color: Colors.black87, size: 24.sp),
      onPressed: () => close(context, ''),
    );
  }

  List<String> _filteredFolders() {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    return HomeViewModel.allSections
        .expand((s) => s.folders)
        .where((f) => f.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _filteredFolders();
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, color: Colors.black26, size: 48.sp),
            SizedBox(height: 12.h),
            Text('No results found', style: GoogleFonts.outfit(color: Colors.black38, fontSize: 14.sp)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: results.length,
      itemBuilder: (_, i) {
        final folder = results[i];
        final images = controller.folderData[folder] ?? [];
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.black.withOpacity(0.06)),
          ),
          child: Row(
            children: [
              Container(
                width: 48.w, height: 48.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF008080).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: images.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(images.first['image'] ?? '', fit: BoxFit.cover),
                      )
                    : Icon(Icons.folder_rounded, color: const Color(0xFF008080), size: 24.sp),
              ),
              SizedBox(width: 14.w),
              Text(folder, style: GoogleFonts.outfit(
                fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black87,
              )),
              const Spacer(),
              Text('${images.length}', style: GoogleFonts.outfit(
                fontSize: 12.sp, color: Colors.black38,
              )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _filteredFolders();
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_rounded, color: Colors.black26, size: 48.sp),
            SizedBox(height: 12.h),
            Text('Search logo categories', style: GoogleFonts.outfit(color: Colors.black38, fontSize: 14.sp)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: suggestions.length,
      itemBuilder: (_, i) {
        final folder = suggestions[i];
        return ListTile(
          leading: Icon(Icons.folder_rounded, color: const Color(0xFF008080), size: 22.sp),
          title: Text(folder, style: GoogleFonts.outfit(
            color: Colors.black87, fontSize: 14.sp,
          )),
          onTap: () {
            query = folder;
            showResults(context);
          },
        );
      },
    );
  }
}

