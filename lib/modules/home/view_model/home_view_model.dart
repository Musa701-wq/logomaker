import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  // Style categories for "Start from a vision"
  final List<String> styleCategories = ['Minimalist', 'Abstract', 'Typography', 'Gaming', 'Luxury'];
  final RxString selectedStyle = 'Minimalist'.obs;

  // Your Atelier - recent projects (placeholder data)
  final List<Map<String, String>> atelierProjects = [
    {'title': 'Prism Tech', 'time': '2 hours ago', 'image': 'assets/images/logo2.jpg'},
    {'title': 'Velvet Noir', 'time': 'Yesterday', 'image': 'assets/images/logo2.jpg'},
    {'title': 'Bloom Studio', 'time': '3 days ago', 'image': 'assets/images/logo.png'},
    {'title': 'Cyber Flux', 'time': 'Last week', 'image': 'assets/images/logo.png'},
  ];

  // Legacy
  final List<String> categories = ['Modern', 'Serif', 'Minimal'];
  final RxString selectedCategory = 'Modern'.obs;
  void selectCategory(String category) => selectedCategory.value = category;
}
