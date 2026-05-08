import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../profile/view_model/profile_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginViewModel extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    // Standard login logic...
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      
      // 1. Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        isLoading.value = false;
        return; // User cancelled
      }

      // 2. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Once signed in, return the UserCredential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Update Profile details with REAL data
        final profileVM = Get.find<ProfileViewModel>();
        profileVM.setUserDetails(
          user.displayName ?? 'Google User', 
          user.email ?? ''
        );
        
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      print('GOOGLE SIGN-IN ERROR: $e');
      Get.snackbar(
        'Authentication Error',
        'Could not complete Google Sign-In. Please check your connection or Firebase setup.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void loginWithApple() {
    // Implement Apple login
    print('Login with Apple');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
