import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/utils/color_constants.dart';
import '../view_model/ai_generator_view_model.dart';

class AIGeneratorView extends GetView<AIGeneratorViewModel> {
  const AIGeneratorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.premiumDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20.sp),
          onPressed: () => controller.previousStep(),
        ),
        title: Text(
          'Create New Logo',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: Obx(() => Stack(
        children: [
          Column(
            children: [
              _buildProgressHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildCurrentStep(),
                  ),
                ),
              ),
              _buildBottomAction(),
            ],
          ),
          if (controller.isLoading.value) _buildLoadingOverlay(),
        ],
      )),
    );
  }

  Widget _buildProgressHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'STEP ${controller.currentStep.value} OF 3',
                  style: GoogleFonts.outfit(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 1,
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: controller.currentStep.value / 3,
                    minHeight: 4.h,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (controller.currentStep.value) {
      case 1: return _buildStep1();
      case 2: return _buildStep2();
      case 3: return _buildStep3();
      default: return const SizedBox();
    }
  }

  // --- STEP 1: BRAND INFO ---
  Widget _buildStep1() {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Brand Identity', 'Define the foundation of your brand.'),
        SizedBox(height: 32.h),
        _buildTextField('Brand Name', 'e.g. Atelier Studio', controller.brandNameController),
        SizedBox(height: 24.h),
        _buildTextField('Slogan (Optional)', 'e.g. Crafting Excellence', controller.sloganController),
        SizedBox(height: 32.h),
        _buildSectionHeader('Industry Category'),
        SizedBox(height: 16.h),
        Obx(() => Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            ...controller.industries.map((e) => _buildIndustryChip(e)),
            _buildAddIndustryButton(),
          ],
        )),
      ],
    );
  }

  // --- STEP 2: VISUAL IDENTITY ---
  Widget _buildStep2() {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Visual Identity', 'Refining the aesthetic essence.'),
        SizedBox(height: 32.h),
        _buildSectionHeader('Logo Style'),
        SizedBox(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 1.1,
          ),
          itemCount: controller.logoStyles.length,
          itemBuilder: (context, index) {
            final style = controller.logoStyles[index];
            return _buildStyleCard(style);
          },
        ),
        SizedBox(height: 32.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('Color Palette'),
            TextButton.icon(
              onPressed: () => _showColorPickerDialog(),
              icon: Icon(Icons.add_circle_outline_rounded, size: 18.sp, color: AppColors.primary),
              label: Text('Custom', style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 12.sp, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Obx(() => Column(
          children: controller.colorPalettes.map((p) => _buildPaletteRow(p)).toList(),
        )),
      ],
    );
  }

  // --- STEP 3: FINAL TOUCHES ---
  Widget _buildStep3() {
    return Column(
      key: const ValueKey(3),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Final Touches', 'Polishing the final visual identity.'),
        SizedBox(height: 32.h),
        _buildSectionHeader('Target Audience'),
        SizedBox(height: 16.h),
        SizedBox(
          height: 100.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: ['Kids', 'Corporate', 'Luxury Clients', 'Teenagers']
                .map((e) => _buildAudienceCard(e))
                .toList(),
          ),
        ),
        SizedBox(height: 32.h),
        _buildSectionHeader('Font Style'),
        SizedBox(height: 16.h),
        _buildFontDropdown(),
        SizedBox(height: 40.h),
        _buildSectionHeader('Logo Layout'),
        SizedBox(height: 16.h),
        Row(
          children: [
            _buildLayoutOption('Icon + Text', Icons.image_outlined),
            SizedBox(width: 12.w),
            _buildLayoutOption('Only Text', Icons.text_fields_rounded),
          ],
        ),
      ],
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildIndustryChip(String text) {
    return Obx(() {
      final isSelected = controller.selectedIndustry.value == text;
      return GestureDetector(
        onTap: () => controller.selectedIndustry.value = text,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.1)),
          ),
          child: Text(text, style: GoogleFonts.outfit(color: isSelected ? AppColors.primary : Colors.black87, fontSize: 13.sp, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ),
      );
    });
  }

  Widget _buildAddIndustryButton() {
    return GestureDetector(
      onTap: () => _showAddIndustryDialog(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.withOpacity(0.1), style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: AppColors.primary, size: 16.sp),
            SizedBox(width: 6.w),
            Text('Custom', style: GoogleFonts.outfit(color: AppColors.primary, fontSize: 13.sp, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildFontDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedFont.value,
          dropdownColor: Colors.white,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
          isExpanded: true,
          style: GoogleFonts.outfit(color: Colors.black87, fontSize: 15.sp),
          items: controller.fontStyles.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: GoogleFonts.getFont(
                value == 'Modern' ? 'Outfit' : 
                value == 'Bold' ? 'Outfit' : 
                value == 'Handwritten' ? 'Dancing Script' : 
                value == 'Elegant' ? 'Playfair Display' : 'Outfit'
              )),
            );
          }).toList(),
          onChanged: (val) => controller.selectedFont.value = val!,
        ),
      )),
    );
  }

  Widget _buildLayoutOption(String text, IconData icon) {
    return Obx(() {
      final isSelected = controller.selectedLayout.value == text;
      return Expanded(
        child: GestureDetector(
          onTap: () => controller.selectedLayout.value = text,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: isSelected ? AppColors.primary : Colors.black54, size: 18.sp),
                SizedBox(width: 10.w),
                Text(text, style: GoogleFonts.outfit(color: isSelected ? AppColors.primary : Colors.black54, fontWeight: FontWeight.bold, fontSize: 13.sp)),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showAddIndustryDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text('Custom Industry', style: GoogleFonts.outfit(color: Colors.black87, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller.customIndustryController,
          autofocus: true,
          style: GoogleFonts.outfit(color: Colors.black87),
          decoration: InputDecoration(
            hintText: 'Enter industry name...',
            hintStyle: TextStyle(color: Colors.black26),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('CANCEL', style: TextStyle(color: Colors.black54))),
          TextButton(onPressed: () => controller.addCustomIndustry(), child: Text('ADD', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  void _showColorPickerDialog() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Palette Builder', style: GoogleFonts.outfit(color: Colors.black87, fontSize: 20.sp, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => Get.back(), icon: Icon(Icons.close_rounded, color: Colors.black26)),
              ],
            ),
            SizedBox(height: 20.h),
            
            // Preview
            Center(
              child: Obx(() => Container(
                width: 120.w,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  gradient: LinearGradient(colors: [controller.tempColor1.value, controller.tempColor2.value]),
                  boxShadow: [BoxShadow(color: controller.tempColor1.value.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
                ),
                child: Center(
                  child: Text('PREVIEW', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.sp, letterSpacing: 1)),
                ),
              )),
            ),
            
            SizedBox(height: 32.h),
            
            _buildColorPickerSection('Primary Color', controller.tempColor1),
            SizedBox(height: 24.h),
            _buildColorPickerSection('Secondary Color', controller.tempColor2),
            
            SizedBox(height: 32.h),
            GestureDetector(
              onTap: () => controller.addCustomColorPalette(),
              child: Container(
                height: 56.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                alignment: Alignment.center,
                child: Text('ADD TO PALETTES', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.sp)),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildColorPickerSection(String label, Rx<Color> selectedColor) {
    final List<Color> pickerColors = [
      Colors.red, Colors.pink, Colors.purple, Colors.deepPurple, Colors.indigo,
      Colors.blue, Colors.lightBlue, Colors.cyan, Colors.teal, Colors.green,
      Colors.lightGreen, Colors.lime, Colors.yellow, Colors.amber, Colors.orange,
      Colors.deepOrange, Colors.brown, Colors.grey, Colors.blueGrey, Colors.black,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(color: Colors.black87, fontSize: 13.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 12.h),
        SizedBox(
          height: 35.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: pickerColors.length,
            itemBuilder: (context, index) {
              final color = pickerColors[index];
              return Obx(() => GestureDetector(
                onTap: () => selectedColor.value = color,
                child: Container(
                  width: 35.h,
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedColor.value == color ? Colors.black87 : Colors.grey.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: selectedColor.value == color 
                    ? Icon(Icons.check, color: Colors.white, size: 16.sp) 
                    : null,
                ),
              ));
            },
          ),
        ),
      ],
    );
  }

  // --- REUSED HELPERS FROM PREVIOUS VERSION ---

  Widget _buildStepTitle(String title, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.outfit(fontSize: 28.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
        SizedBox(height: 8.h),
        Text(sub, style: GoogleFonts.outfit(fontSize: 14.sp, color: Colors.black54)),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(width: 4.w, height: 16.h, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2.r))),
        SizedBox(width: 8.w),
        Text(title, style: GoogleFonts.outfit(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 0.5)),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController ctr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(color: Colors.black54, fontSize: 13.sp, fontWeight: FontWeight.w500)),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r), border: Border.all(color: Colors.grey.withOpacity(0.1))),
          child: TextField(
            controller: ctr,
            style: GoogleFonts.outfit(color: Colors.black87, fontSize: 14.sp),
            decoration: InputDecoration(
              hintText: hint, hintStyle: GoogleFonts.outfit(color: Colors.black26, fontSize: 14.sp),
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h), border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStyleCard(Map<String, dynamic> style) {
    return Obx(() {
      final isSelected = controller.selectedStyle.value == style['name'];
      return GestureDetector(
        onTap: () => controller.selectedStyle.value = style['name'],
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(style['icon'], color: isSelected ? AppColors.primary : Colors.black54, size: 24.sp),
              SizedBox(height: 8.h),
              Text(style['name'], style: GoogleFonts.outfit(fontSize: 11.sp, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? Colors.black87 : Colors.black54)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPaletteRow(Map<String, dynamic> p) {
    return Obx(() {
      final isSelected = controller.selectedColorPalette.value == p['name'];
      return GestureDetector(
        onTap: () => controller.selectedColorPalette.value = p['name'],
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r), border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.1))),
          child: Row(
            children: [
              Row(children: (p['colors'] as List<Color>).map((c) => Container(width: 24.w, height: 24.w, margin: EdgeInsets.only(right: 8.w), decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: Colors.grey.withOpacity(0.2))))).toList()),
              SizedBox(width: 8.w),
              Text(p['name'], style: GoogleFonts.outfit(color: isSelected ? AppColors.primary : Colors.black87, fontSize: 14.sp)),
              const Spacer(),
              if (isSelected) Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20.sp),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAudienceCard(String text) {
    return Obx(() {
      final isSelected = controller.selectedAudience.value == text;
      return GestureDetector(
        onTap: () => controller.selectedAudience.value = text,
        child: Container(
          width: 140.w, margin: EdgeInsets.only(right: 12.w),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16.r), border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.1)),
            image: DecorationImage(image: AssetImage('assets/images/logo${text == "Kids" ? 1 : 2}.jpg'), fit: BoxFit.cover, opacity: 0.1),
          ),
          alignment: Alignment.bottomLeft, padding: EdgeInsets.all(12.w),
          child: Text(text, style: GoogleFonts.outfit(color: isSelected ? AppColors.primary : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13.sp)),
        ),
      );
    });
  }

  Widget _buildBottomAction() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 30.h),
      decoration: BoxDecoration(color: AppColors.premiumDark),
      child: GestureDetector(
        onTap: () => controller.nextStep(),
        child: Container(
          height: 60.h,
          decoration: BoxDecoration(
            color: const Color(0xFF7B2FBE),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B2FBE).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.currentStep.value == 3 ? 'GENERATE LOGO' : 'NEXT STEP',
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(width: 10.w),
                Icon(
                  controller.currentStep.value == 3 ? Icons.auto_awesome : Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.white.withOpacity(0.9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 80.w, height: 80.w, child: CircularProgressIndicator(strokeWidth: 6, color: AppColors.primary)),
            SizedBox(height: 32.h),
            Text('AI IS CRAFTING...', style: GoogleFonts.outfit(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: 2)),
            SizedBox(height: 8.h),
            Text('Synthesizing your visual identity', style: GoogleFonts.outfit(color: Colors.black54, fontSize: 14.sp)),
          ],
        ),
      ),
    );
  }
}
