import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/color_constants.dart';
import '../view_model/history_view_model.dart';

class HistoryView extends GetView<HistoryViewModel> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.accentPurpleBtn,
      backgroundColor: Colors.white,
      onRefresh: () => controller.reload(),
      child: CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [AppColors.themeGradientStart, AppColors.themeGradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'The Ethereal Studio',
                        style: GoogleFonts.outfit(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Creation ',
                      style: GoogleFonts.outfit(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [AppColors.themeGradientStart, AppColors.themeGradientEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'History',
                        style: GoogleFonts.outfit(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  'Browse your past masterpieces and re-ignite your creative spark.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Masonry History Grid
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          sliver: Obx(() {
            if (controller.historyProjects.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 60.h),
                    child: Column(children: [
                      Icon(Icons.history_rounded, color: Colors.grey[300], size: 60.sp),
                      SizedBox(height: 16.h),
                      Text('No designs yet', style: GoogleFonts.outfit(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white38)),
                      SizedBox(height: 8.h),
                      Text('Your saved designs will appear here', style: GoogleFonts.outfit(fontSize: 14.sp, color: AppColors.textSecondary)),
                    ]),
                  ),
                ),
              );
            }
            return SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20.h,
              crossAxisSpacing: 20.w,
              itemBuilder: (context, index) {
                final project = controller.historyProjects[index];
                return _buildMasonryHistoryCard(project, index);
              },
              childCount: controller.historyProjects.length,
            );
          }),
        ),
        
        SliverToBoxAdapter(child: SizedBox(height: 100.h)),
      ],
    ), // CustomScrollView
    ); // RefreshIndicator
  }

  Widget _buildMasonryHistoryCard(Map<String, String> project, int index) {
    final isTall = index % 3 == 0 || index % 5 == 0;
    final hasState = project['statePath'] != null && project['statePath']!.isNotEmpty;

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.historyDetail, arguments: project),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7FA), // Soft off-white, easy on the eyes
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: AppColors.themeGradientEnd.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                  child: Container(
                    height: isTall ? 240.h : 180.h,
                    width: double.infinity,
                    color: const Color(0xFF2B2E7A),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        project['isAsset'] == 'true'
                            ? Image.asset(project['image']!, fit: BoxFit.cover)
                            : (project['image']!.startsWith('http')
                                ? Image.network(project['image']!, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Center(child: Icon(Icons.image_outlined, color: Colors.grey[300], size: 40.sp)))
                                : Image.file(File(project['image']!), fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Center(child: Icon(Icons.image_outlined, color: Colors.grey[300], size: 40.sp)))),
                        // Bottom fade overlay for premium look
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 60.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.35),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Details
                Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 12.h, 10.w, 14.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['subtitle']!.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentPurpleBtn.withOpacity(0.75),
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              project['title']!,
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          // Edit button — only if state is saved
                          GestureDetector(
                            onTap: hasState
                                ? () => Get.toNamed(
                                      AppRoutes.editor,
                                      arguments: {'statePath': project['statePath']},
                                    )
                                : null,
                            child: Container(
                              padding: EdgeInsets.all(7.w),
                              decoration: BoxDecoration(
                                gradient: hasState
                                    ? LinearGradient(
                                        colors: [
                                          AppColors.themeGradientStart.withOpacity(0.15),
                                          AppColors.themeGradientEnd.withOpacity(0.15),
                                        ],
                                      )
                                    : null,
                                color: hasState ? null : Colors.grey.withOpacity(0.08),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                size: 13.sp,
                                color: hasState
                                    ? AppColors.accentPurpleBtn
                                    : Colors.grey[350],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Delete button — top right corner
          Positioned(
            top: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: () => controller.removeEntry(index),
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close_rounded, color: Colors.white, size: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
