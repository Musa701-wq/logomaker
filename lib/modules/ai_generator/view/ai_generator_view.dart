import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/utils/color_constants.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../view_model/ai_generator_view_model.dart';

class AIGeneratorView extends GetView<AIGeneratorViewModel> {
  const AIGeneratorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'AI Generator',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Obx(() => Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 32.h),
                
                _buildSectionTitle('SELECT CATEGORY'),
                SizedBox(height: 16.h),
                _buildCategoryGrid(),
                
                SizedBox(height: 32.h),
                _buildSectionTitle('BUSINESS DETAILS'),
                SizedBox(height: 12.h),
                CustomTextField(
                  label: 'Custom Detail',
                  hintText: 'e.g. Minimalist, 3D, Organic...',
                  controller: controller.customDetailsController,
                ),
                
                SizedBox(height: 32.h),
                _buildSectionTitle('AI PROMPT'),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller.promptController,
                    maxLines: 4,
                    style: GoogleFonts.outfit(fontSize: 15.sp),
                    decoration: InputDecoration(
                      hintText: 'Describe your dream logo in detail...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                
                SizedBox(height: 48.h),
                CustomButton(
                  text: 'GENERATE LOGO',
                  onPressed: controller.generateLogo,
                  isLoading: controller.isLoading.value,
                  icon: Icon(Icons.auto_awesome, color: Colors.white, size: 20.sp),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
          
          if (controller.isLoading.value)
            _buildLoadingOverlay(),
        ],
      )),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Craft Your Brand',
          style: GoogleFonts.outfit(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Enter details below and let our AI bring your\nvision to life.',
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary.withOpacity(0.5),
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: controller.categories.map((category) {
        return Obx(() {
          final isSelected = controller.selectedCategory.value == category;
          return GestureDetector(
            onTap: () => controller.selectCategory(category),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.dividerColor,
                  width: 1.5,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ] : [],
              ),
              child: Text(
                category,
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder(
              duration: const Duration(seconds: 2),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Container(
                  width: 120.w,
                  height: 120.w,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 4),
                  ),
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 4,
                    color: AppColors.primary,
                  ),
                );
              },
            ),
            SizedBox(height: 32.h),
            Text(
              'AI IS CREATING...',
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Analyzing your prompt and generating motifs',
              style: TextStyle(color: Colors.white70, fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }
}
