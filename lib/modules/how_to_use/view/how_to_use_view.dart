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
          icon: Icon(Icons.arrow_back_rounded,
              color: Colors.black87, size: 22.sp),
          onPressed: () => Get.back(),
        ),
        title: Text('How To Use',
            style: GoogleFonts.outfit(
                color: Colors.black87,
                fontSize: 17.sp,
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 28.h),
              decoration: BoxDecoration(
                color: const Color(0xFF008080),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.design_services_rounded,
                        color: Colors.white, size: 24.sp),
                  ),
                  SizedBox(height: 16.h),
                  Text('Create professional logos\nin minutes.',
                      style: GoogleFonts.outfit(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.35)),
                  SizedBox(height: 8.h),
                  Text(
                      'Follow these steps to design, customize,\nand export your logo.',
                      style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          color: Colors.white70,
                          height: 1.5)),
                ],
              ),
            ),

            SizedBox(height: 28.h),
            _sectionLabel('STEPS'),
            SizedBox(height: 12.h),

            _step(1, Icons.grid_view_rounded, const Color(0xFF008080),
                'Browse Templates',
                'Scroll through categories on the home screen. Tap any thumbnail to open it directly in the editor.'),
            _step(2, Icons.add_circle_outline_rounded, const Color(0xFF0277BD),
                'Start from Scratch',
                'Tap the + button at the bottom and choose "Create Manually" to open a blank canvas.'),
            _step(3, Icons.text_fields_rounded, const Color(0xFF6A1B9A),
                'Add and Edit Text',
                'Use the Text tool to add your brand name. Tap any text on the canvas to edit content, font, size, and color.'),
            _step(4, Icons.category_rounded, const Color(0xFFE65100),
                'Add Shapes and Icons',
                'Open the Icons tab to browse hundreds of built-in shapes. Drag, resize, and rotate elements on the canvas.'),
            _step(5, Icons.palette_outlined, const Color(0xFF00695C),
                'Customize Colors',
                'Select an element and open the Colors panel to change fill, stroke, or apply a tint using the color picker.'),
            _step(6, Icons.wallpaper_rounded, const Color(0xFFAD1457),
                'Set Background',
                'Choose a solid color, gradient, or upload your own image from the Background panel.'),
            _step(7, Icons.auto_fix_high_rounded, const Color(0xFFF57C00),
                'Apply Effects',
                'Add shadows, glows, and color filters to elements via the Effects tab for a polished look.'),
            _step(8, Icons.download_rounded, const Color(0xFF2E7D32),
                'Export and Save',
                'Tap the download icon to save your logo to the Gallery. Work is also stored in History for future edits.'),

            SizedBox(height: 28.h),
            _sectionLabel('TIPS'),
            SizedBox(height: 12.h),

            _tip(Icons.pinch_rounded,
                'Pinch to zoom on the canvas for precise element placement.'),
            _tip(Icons.layers_rounded,
                'Use the Layers panel to reorder elements and manage depth.'),
            _tip(Icons.undo_rounded,
                'Use undo and redo buttons to quickly revert or restore changes.'),
            _tip(Icons.workspace_premium_rounded,
                'Premium members unlock HD export and all premium templates.'),

            SizedBox(height: 28.h),

            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.editor),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF008080),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF008080).withOpacity(0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 5))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text('Start Designing',
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 36.h),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(label,
        style: GoogleFonts.outfit(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black38,
            letterSpacing: 1.5));
  }

  Widget _step(int index, IconData icon, Color color, String title,
      String desc) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
                color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Center(
                child: Icon(icon, color: color, size: 20.sp)),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.r)),
                    child: Text('Step $index',
                        style: GoogleFonts.outfit(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: color)),
                  ),
                ]),
                SizedBox(height: 5.h),
                Text(title,
                    style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87)),
                SizedBox(height: 3.h),
                Text(desc,
                    style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: Colors.black54,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tip(IconData icon, String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF008080), size: 18.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(text,
                style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    color: Colors.black54,
                    height: 1.45)),
          ),
        ],
      ),
    );
  }
}
