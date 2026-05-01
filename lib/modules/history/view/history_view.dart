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
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: () => controller.reload(),
      child: CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        // Premium Header
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Row(
              children: [
                Icon(Icons.brush_rounded, color: AppColors.primary, size: 28.sp),
                SizedBox(width: 12.w),
                Text(
                  'The Ethereal Studio',
                  style: GoogleFonts.outfit(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1.5),
                  ),
                  child: CircleAvatar(
                    radius: 18.r,
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.person_3_rounded, size: 22.sp, color: Colors.grey[400]),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Title Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Creation ',
                        style: GoogleFonts.outfit(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: 'History',
                        style: GoogleFonts.outfit(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6F61E1), // Purple from design
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Browse your past masterpieces and re-\nignite your creative spark.',
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
                      Text('No designs yet', style: GoogleFonts.outfit(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: Container(
                    height: isTall ? 240.h : 180.h,
                    width: double.infinity,
                    color: Colors.grey[100],
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
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black.withOpacity(0.05), Colors.transparent],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Details
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project['subtitle']!.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary.withOpacity(0.7),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              project['title']!,
                              style: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Edit button — only if state is saved
                          GestureDetector(
                            onTap: hasState
                                ? () => Get.toNamed(
                                      AppRoutes.editor,
                                      arguments: {'statePath': project['statePath']},
                                    )
                                : null,
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: hasState
                                    ? const Color(0xFFF0EFFF)
                                    : Colors.grey.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                size: 14.sp,
                                color: hasState
                                    ? const Color(0xFF6F61E1)
                                    : Colors.grey[400],
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
