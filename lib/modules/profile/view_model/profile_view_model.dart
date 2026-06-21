import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../app/routes/app_routes.dart';

class ProfileViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final RxString userName = 'Guest User'.obs;
  final RxString userEmail = 'Login to sync your projects'.obs;
  final RxBool isPremium = false.obs;
  final RxDouble usagePercentage = 0.0.obs;
  final RxBool isGuest = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes to update the profile automatically
    _auth.authStateChanges().listen((user) {
      checkLoginStatus();
    });
  }

  void checkLoginStatus() {
    final user = _auth.currentUser;
    if (user != null) {
      isGuest.value = false;
      userName.value = user.displayName ?? 'Creative Pro';
      userEmail.value = user.email ?? 'user@example.com';
    } else {
      isGuest.value = true;
      userName.value = 'Guest User';
      userEmail.value = 'Login to sync your projects';
    }
  }
  
  // Saved assets thumbnails logic
  final List<String> savedAssets = [
    'assets/images/logo.png',
  ];

  final RxBool isDarkMode = false.obs;
  final RxBool isNotificationsEnabled = true.obs;

  void setUserDetails(String name, String email) {
    userName.value = name;
    userEmail.value = email;
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
  }

  void toggleNotifications(bool value) {
    isNotificationsEnabled.value = value;
  }

  Future<void> logout() async {
    try {
      // Sign out from Google if applicable
      try {
        await _googleSignIn.signOut();
        await _googleSignIn.disconnect();
      } catch (_) {}

      // Sign out from Firebase
      await _auth.signOut();
      
      // Navigate to Home — the auth listeners in ViewModels will handle the UI reset
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      print('LOGOUT ERROR: $e');
      Get.offAllNamed(AppRoutes.home);
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      print('DELETE ACCOUNT ERROR: $e');
      logout();
    }
  }
}
