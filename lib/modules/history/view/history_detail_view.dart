import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/utils/color_constants.dart';
import '../../../widgets/custom_button.dart';

class HistoryDetailView extends StatelessWidget {
  const HistoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> project = Get.arguments;
    final bool isAi = project['genType'] == 'ai';

    return Scaffold(
      backgroundColor: AppColors.premiumDark,
      appBar: AppBar(
        title: Text(
          'Creation Detail',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProjectImage(project),
            SizedBox(height: 32.h),
            
            Text(
              project['title']!,
              style: GoogleFonts.outfit(
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              project['subtitle']!,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
            
            if (isAi) ...[
              SizedBox(height: 32.h),
              _buildSectionTitle('AI CATEGORY'),
              SizedBox(height: 12.h),
              _buildInfoCard(project['category']!, Icons.category_outlined),
              
              SizedBox(height: 24.h),
              _buildSectionTitle('AI PROMPT'),
              SizedBox(height: 12.h),
              _buildPromptCard(project['prompt']!),
            ],
            
            SizedBox(height: 48.h),
            _buildActionButtons(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectImage(Map<String, String> project) {
    final imgPath = project['image'] ?? '';
    Widget imageWidget;

    if (project['isAsset'] == 'true') {
      imageWidget = Image.asset(imgPath, fit: BoxFit.contain);
    } else if (imgPath.startsWith('http')) {
      imageWidget = Image.network(
        imgPath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(Icons.broken_image_rounded, color: Colors.grey[400], size: 60.sp),
      );
    } else {
      imageWidget = Image.file(
        File(imgPath),
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(Icons.broken_image_rounded, color: Colors.grey[400], size: 60.sp),
      );
    }

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 300.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: imageWidget,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black54,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildInfoCard(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20.sp),
          SizedBox(width: 12.w),
          Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptCard(String prompt) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Text(
        prompt,
        style: GoogleFonts.outfit(
          fontSize: 14.sp,
          color: Colors.black54,
          height: 1.5,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Save',
            onPressed: () => Get.snackbar('Success', 'Saved to Gallery'),
            icon: Icon(Icons.download_rounded, color: Colors.white, size: 18.sp),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: CustomButton(
            text: 'Share',
            isSecondary: true,
            onPressed: () => Get.snackbar('Success', 'Sharing options opened'),
            icon: Icon(Icons.share_rounded, color: AppColors.primary, size: 18.sp),
          ),
        ),
      ],
    );
  }
}
