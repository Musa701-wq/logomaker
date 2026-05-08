import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TemplatesViewModel extends GetxController {
  var searchQuery = ''.obs;
  var selectedCategory = 'All'.obs;
  var filteredTemplates = <Map<String, String>>[].obs;

  final List<String> categories = ['All', 'Minimal', 'Modern', 'Tech', 'Abstract', 'Retro', 'Luxury'];

  final List<Map<String, String>> templates = [
    {
      'title': 'Minimalist Peak',
      'subtitle': 'MINIMAL',
      'image': 'assets/images/logo1.jpg',
      'category': 'Minimal',
    },
    {
      'title': 'Fluid Dynamics',
      'subtitle': 'ABSTRACT',
      'image': 'assets/images/logo2.jpg',
      'category': 'Abstract',
    },
    {
      'title': 'Heritage Brew',
      'subtitle': 'RETRO',
      'image': 'assets/images/logo1.jpg',
      'category': 'Retro',
    },
    {
      'title': 'Aurelius Gold',
      'subtitle': 'LUXURY',
      'image': 'assets/images/logo2.jpg',
      'category': 'Luxury',
    },
    {
      'title': 'Nexus Tech',
      'subtitle': 'MODERN',
      'image': 'assets/images/logo1.jpg',
      'category': 'Tech',
    },
    {
      'title': 'Ethereal Studio',
      'subtitle': 'FASHION',
      'image': 'assets/images/logo2.jpg',
      'category': 'Modern',
    },
    {
      'title': 'Cyber Flux',
      'subtitle': 'TECH',
      'image': 'assets/images/logo1.jpg',
      'category': 'Tech',
    },
    {
      'title': 'Velvet Noir',
      'subtitle': 'LUXURY',
      'image': 'assets/images/logo2.jpg',
      'category': 'Luxury',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    updateFilteredTemplates();
  }

  void updateFilteredTemplates() {
    filteredTemplates.assignAll(templates.where((template) {
      final matchesQuery = template['title']!.toLowerCase().contains(searchQuery.value.toLowerCase());
      final matchesCategory = selectedCategory.value == 'All' || template['category'] == selectedCategory.value;
      return matchesQuery && matchesCategory;
    }).toList());
  }

  void onSearch(String query) {
    searchQuery.value = query;
    updateFilteredTemplates();
  }

  void onCategorySelected(String category) {
    selectedCategory.value = category;
    updateFilteredTemplates();
  }

  void addLogoToTemplates(String title, String imagePath) {
    templates.insert(0, {
      'title': title,
      'subtitle': 'AI GENERATED',
      'image': imagePath,
      'category': 'Modern',
    });
    updateFilteredTemplates();
    Get.snackbar(
      'Success',
      'Logo added to Templates library!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF7B2FBE),
      colorText: Colors.white,
    );
  }
}
