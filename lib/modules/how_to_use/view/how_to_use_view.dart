import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';

class HowToUseView extends StatelessWidget {
  const HowToUseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.black87, size: 24.sp),
          onPressed: () => Get.back(),
        ),
        title: Text('How To Use', style: GoogleFonts.outfit(
          color: Colors.black87, fontSize: 18.sp, fontWeight: FontWeight.bold,
        )),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          _stepCard(
            number: '1',
            icon: Icons.add_circle_outline_rounded,
            title: 'Create a Design',
            desc: 'Tap the + button at the bottom center to start. Choose "Create Manually" to open the editor and build your logo from scratch.',
          ),
          _stepCard(
            number: '2',
            icon: Icons.text_fields_rounded,
            title: 'Add & Style Text',
            desc: 'Tap the Text tab to add your brand name. Change fonts, size, color, and alignment using the controls below the canvas.',
          ),
          _stepCard(
            number: '3',
            icon: Icons.category_rounded,
            title: 'Add Shapes & Icons',
            desc: 'Use the Icons tab to add built-in shapes or browse Firebase shape categories. Tap a shape to add it to your canvas.',
          ),
          _stepCard(
            number: '4',
            icon: Icons.image_outlined,
            title: 'Set Background & Images',
            desc: 'Choose from solid colors, gradient backgrounds, or upload your own image from the Background tab.',
          ),
          _stepCard(
            number: '5',
            icon: Icons.color_lens_outlined,
            title: 'Customize Colors & Effects',
            desc: 'Select any element and use the Colors tab to change fill or tint. Apply filters and adjustments in the Effects tab.',
          ),
          _stepCard(
            number: '6',
            icon: Icons.download_rounded,
            title: 'Export & Save',
            desc: 'Tap the download icon to save your design to your device or history. Premium users can export in HD quality.',
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.editor),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0xFF008080),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text('Try It Now', style: GoogleFonts.outfit(
                  color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold,
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepCard({
    required String number,
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.w, height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xFF008080).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(number, style: GoogleFonts.outfit(
                fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF008080),
              )),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.outfit(
                  fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black87,
                )),
                SizedBox(height: 4.h),
                Text(desc, style: GoogleFonts.outfit(
                  fontSize: 12.sp, color: Colors.black54, height: 1.4,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
