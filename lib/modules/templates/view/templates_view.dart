import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/color_constants.dart';
import '../view_model/templates_view_model.dart';

class TemplatesView extends GetView<TemplatesViewModel> {
  const TemplatesView({super.key});

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
                        onPressed: () {
                          // Clear search
                          controller.onSearch('');
                        },
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
                        color: isSelected ? const Color(0xFF7B2FBE) : const Color(0xFF1A1D25),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF7B2FBE) : Colors.white.withOpacity(0.05),
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
                  return GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.editor, arguments: {
                      'templateImage': template['image'],
                      'templateText': template['title'],
                      'templateTextColor': template['textColor'],
                    }),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1D25),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: Colors.white.withOpacity(0.05)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Image.asset(
                                template['image']!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
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
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                template['subtitle']!,
                                style: GoogleFonts.outfit(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary.withOpacity(0.5),
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
