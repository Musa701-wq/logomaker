import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/routes/app_routes.dart';

class OnboardingViewModel extends GetxController {
  final pageController = PageController();
  var currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    Get.offAllNamed(AppRoutes.welcomeBanner);
  }

  void skip() {
    completeOnboarding();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
