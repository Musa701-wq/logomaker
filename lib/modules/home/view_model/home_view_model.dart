import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../app/routes/app_routes.dart';

class HomeViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxInt selectedIndex = 0.obs;
  final RxBool isGuest = true.obs;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((user) {
      checkLoginStatus();
    });
  }

  void checkLoginStatus() {
    isGuest.value = _auth.currentUser == null;
  }

  void onCreateNewLogo() {
    if (isGuest.value) {
      Get.toNamed(AppRoutes.login);
    } else {
      Get.toNamed(AppRoutes.aiGenerator);
    }
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  // Style categories for "Start from a vision"
  final List<String> styleCategories = ['Minimalist', 'Abstract', 'Typography', 'Gaming', 'Luxury'];
  final RxString selectedStyle = 'Minimalist'.obs;

  // Your Atelier - recent projects (placeholder data)
  final List<Map<String, String>> atelierProjects = [
    {'title': 'Prism Tech', 'time': '2 hours ago', 'image': 'assets/images/logo2.jpg', 'textColor': '0xFF00B4FF'},
    {'title': 'Velvet Noir', 'time': 'Yesterday', 'image': 'assets/images/logo2.jpg', 'textColor': '0xFFFFFFFF'},
    {'title': 'Bloom Studio', 'time': '3 days ago', 'image': 'assets/images/logo1.jpg', 'textColor': '0xFFFF4D9E'},
    {'title': 'Cyber Flux', 'time': 'Last week', 'image': 'assets/images/logo2.jpg', 'textColor': '0xFFB06EFF'},
  ];

  // Legacy
  final List<String> categories = ['Modern', 'Serif', 'Minimal'];
  final RxString selectedCategory = 'Modern'.obs;
  void selectCategory(String category) => selectedCategory.value = category;
}
