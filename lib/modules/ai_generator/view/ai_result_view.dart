import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/color_constants.dart';
import '../../../widgets/custom_button.dart';
import '../../templates/view_model/templates_view_model.dart';
import '../view_model/ai_generator_view_model.dart';

class AIResultView extends GetView<AIGeneratorViewModel> {
  const AIResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.premiumDark,
      appBar: AppBar(
        title: Text(
          'Generation Result',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: Colors.black87, size: 24.sp),
          onPressed: () => Get.offAllNamed(AppRoutes.home),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          children: [
            _buildResultCard(),
            SizedBox(height: 40.h),
            _buildActionSection(),
            SizedBox(height: 32.h),
            _buildSuccessMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      height: 380.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Grid Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                  ),
                ),
              ),
            ),
          ),
          
          // Result SVG
          Center(
            child: Container(
              width: 250.w,
              height: 250.w,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white, // White background for the logo itself looks better
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: Obx(() => controller.generatedLogoSvg.value.isNotEmpty
                  ? SvgPicture.string(
                      controller.generatedLogoSvg.value,
                      fit: BoxFit.contain,
                    )
                  : const Center(child: CircularProgressIndicator())),
              ),
            ),
          ),
          
          // Badge
          Positioned(
            top: 24.h,
            right: 24.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.accentPurple]),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white, size: 14.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'AI GENERATED',
                    style: GoogleFonts.outfit(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection() {
    return Column(
      children: [
        CustomButton(
          text: 'SAVE TO GALLERY',
          onPressed: controller.saveToGallery,
          icon: Icon(Icons.download_rounded, color: Colors.white, size: 20.sp),
        ),
        SizedBox(height: 12.h),
        CustomButton(
          text: 'ADD TO TEMPLATES',
          onPressed: () {
            // Get the templates view model and add the logo
            try {
              final templatesVM = Get.find<TemplatesViewModel>();
              templatesVM.addLogoToTemplates(
                controller.brandNameController.text.isNotEmpty 
                  ? controller.brandNameController.text 
                  : 'AI Logo',
                'assets/images/logo2.jpg' // Using generated image
              );
            } catch (e) {
              Get.snackbar('Error', 'Templates module not initialized');
            }
          },
          icon: Icon(Icons.auto_fix_high_rounded, color: Colors.white, size: 20.sp),
        ),
        SizedBox(height: 12.h),
        CustomButton(
          text: 'SHARE DESIGN',
          isSecondary: true,
          onPressed: controller.shareLogo,
          icon: Icon(Icons.share_rounded, color: AppColors.primary, size: 18.sp),
        ),
      ],
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        Text(
          'Your vision, realized.',
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Text(
            'This unique asset has been crafted using the Atelier Gen-01 engine based on your creative prompt.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
