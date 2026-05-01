import 'package:get/get.dart';

class ProfileViewModel extends GetxController {
  final RxString userName = 'Creative Pro'.obs;
  final RxString userEmail = 'lumina.pro@example.com'.obs;
  final RxBool isPremium = true.obs;
  final RxDouble usagePercentage = 0.75.obs; // 75%
  
  // Saved assets thumbnails logic
  final List<String> savedAssets = [
    'assets/images/logo1.jpg',
    'assets/images/logo2.jpg',
  ];

  final RxBool isDarkMode = false.obs;
  final RxBool isNotificationsEnabled = true.obs;

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
  }

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
  }
}
