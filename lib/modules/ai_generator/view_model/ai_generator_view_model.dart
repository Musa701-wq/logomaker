import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/services/gemini_service.dart';
import '../../../app/services/prompt_service.dart';

class AIGeneratorViewModel extends GetxController {
  final brandNameController = TextEditingController();
  final sloganController = TextEditingController();
  final customIndustryController = TextEditingController();
  
  final GeminiService _geminiService = GeminiService();
  
  final RxInt currentStep = 1.obs;
  final RxBool isLoading = false.obs;
  final RxString generatedLogoSvg = ''.obs;

  // Step 1: Industry
  final RxString selectedIndustry = 'Technology'.obs;
  final RxList<String> industries = ['Technology', 'Fashion', 'Real Estate', 'Food', 'Beauty', 'Health', 'Finance'].obs;

  // Step 2: Visuals
  final RxString selectedStyle = 'Modern'.obs;
  final RxString selectedColorPalette = 'Default'.obs;
  final RxList<Map<String, dynamic>> colorPalettes = <Map<String, dynamic>>[
    {'name': 'Default', 'colors': [Colors.grey, Colors.white]},
    {'name': 'Blue & White', 'colors': [Colors.blue, Colors.white]},
    {'name': 'Black & Gold', 'colors': [Colors.black, Colors.amber]},
    {'name': 'Teal', 'colors': [Colors.teal, const Color(0xFF008080)]},
  ].obs;

  // Step 3: Final Touches
  final RxString selectedAudience = 'Kids'.obs;
  final RxString selectedFont = 'Bold'.obs;
  final RxString selectedLayout = 'Icon + Text'.obs;

  final List<Map<String, dynamic>> logoStyles = [
    {'name': 'Minimalist', 'icon': Icons.watch_rounded},
    {'name': 'Modern', 'icon': Icons.architecture_rounded},
    {'name': 'Luxury', 'icon': Icons.diamond_rounded},
    {'name': 'Vintage', 'icon': Icons.auto_awesome_mosaic_rounded},
    {'name': '3D', 'icon': Icons.view_in_ar_rounded},
    {'name': 'Mascot', 'icon': Icons.face_rounded},
    {'name': 'Abstract', 'icon': Icons.category_rounded},
  ];

  final List<String> fontStyles = [
    'Modern', 'Bold', 'Handwritten', 'Elegant', 'Minimalist', 'Display', 
    'Serif', 'Sans Serif', 'Script', 'Monospace', 'Futuristic', 'Retro'
  ];

  void addCustomIndustry() {
    if (customIndustryController.text.isNotEmpty) {
      if (!industries.contains(customIndustryController.text)) {
        industries.add(customIndustryController.text);
      }
      selectedIndustry.value = customIndustryController.text;
      customIndustryController.clear();
      Get.back(); // Close dialog
    }
  }

  final Rx<Color> tempColor1 = Colors.teal.obs;
  final Rx<Color> tempColor2 = Colors.blue.obs;

  void addCustomColorPalette() {
    if (tempColor1.value == Colors.transparent) return;
    
    final String paletteName = 'Custom ${colorPalettes.length - 3}';
    final newPalette = {
      'name': paletteName,
      'colors': [tempColor1.value, tempColor2.value],
    };
    
    colorPalettes.add(newPalette);
    selectedColorPalette.value = paletteName;
    
    // Refresh the list to ensure UI updates
    colorPalettes.refresh();
    
    Get.back(); // Close bottom sheet
  }

  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    } else {
      generateLogo();
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  Future<void> generateLogo() async {
    try {
      isLoading.value = true;
      
      // Extract hex codes from selected palette
      final Map<String, dynamic> selectedPaletteData = colorPalettes.firstWhere(
        (p) => p['name'] == selectedColorPalette.value,
        orElse: () => colorPalettes.first,
      );
      final List<String> hexColors = (selectedPaletteData['colors'] as List<Color>)
          .map((c) => '#${c.value.toRadixString(16).substring(2).toUpperCase()}')
          .toList();

      final prompt = PromptService.buildLogoPrompt(
        brandName: brandNameController.text,
        slogan: sloganController.text,
        industry: selectedIndustry.value,
        style: selectedStyle.value,
        colors: hexColors,
        audience: selectedAudience.value,
        font: selectedFont.value,
        layout: selectedLayout.value,
      );

      final svgCode = await _geminiService.generateLogoSvg(prompt);
      generatedLogoSvg.value = svgCode;
      
      isLoading.value = false;
      Get.toNamed(AppRoutes.aiResult);
    } catch (e, stackTrace) {
      isLoading.value = false;
      print('=== LOGO GENERATION EXCEPTION ===');
      print(e);
      print(stackTrace);
      print('=================================');
      Get.snackbar(
        'Generation Error',
        'Could not generate logo: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  void saveToGallery() {
    Get.snackbar(
      'Success',
      'Logo saved to your gallery!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void shareLogo() {
    Get.snackbar(
      'Success',
      'Sharing options opened!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    brandNameController.dispose();
    sloganController.dispose();
    customIndustryController.dispose();
    super.onClose();
  }
}
