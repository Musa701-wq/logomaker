import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/routes/app_routes.dart';

class WelcomeBannerViewModel extends GetxController {
  var isAnimating = false.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 300), () {
      isAnimating.value = true;
    });
  }

  Future<void> onGetStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcomeBanner', true);
    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> onBuyNow() async {
    final url = Uri.parse('https://logomaker-6d294.web.app/pricing.html');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open purchase page',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    }
  }
}
