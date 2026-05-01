import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';

class AIGeneratorViewModel extends GetxController {
  final customDetailsController = TextEditingController();
  final promptController = TextEditingController();
  
  final RxString selectedCategory = ''.obs;
  final RxBool isLoading = false.obs;

  final List<String> categories = [
    'Technology',
    'Food & Beverage',
    'Fashion',
    'Real Estate',
    'Beauty & Wellness',
    'Finance',
    'Entertainment',
  ];

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  Future<void> generateLogo() async {
    if (promptController.text.isEmpty && selectedCategory.value.isEmpty) {
      Get.snackbar(
        'Missing Info',
        'Please select a category or enter a prompt.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    
    // Simulate AI generation delay
    await Future.delayed(const Duration(seconds: 3));
    
    isLoading.value = false;
    Get.toNamed(AppRoutes.aiResult);
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
    customDetailsController.dispose();
    promptController.dispose();
    super.onClose();
  }
}
