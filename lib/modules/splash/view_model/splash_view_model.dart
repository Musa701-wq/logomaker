import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../app/routes/app_routes.dart';
import '../../profile/view_model/profile_view_model.dart';

class SplashViewModel extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startNavigation();
  }

  Future<void> _startNavigation() async {
    // Wait for 2.5 seconds to show the splash
    await Future.delayed(const Duration(milliseconds: 2500));
    
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;
    final hasSeenBanner = prefs.getBool('hasSeenWelcomeBanner') ?? false;

    if (user != null) {
      Get.offAllNamed(AppRoutes.home);
    } else if (isFirstTime) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else if (!hasSeenBanner) {
      Get.offAllNamed(AppRoutes.welcomeBanner);
    } else {
      Get.offAllNamed(AppRoutes.home);
    }
  }
}
