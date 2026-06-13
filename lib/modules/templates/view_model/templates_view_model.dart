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
      'textColor': '0xFF00B4FF', // blue
    },
    {
      'title': 'Fluid Dynamics',
      'subtitle': 'ABSTRACT',
      'image': 'assets/images/logo2.jpg',
      'category': 'Abstract',
      'textColor': '0xFFFFFFFF', // white
    },
    {
      'title': 'Heritage Brew',
      'subtitle': 'RETRO',
      'image': 'assets/images/logo1.jpg',
      'category': 'Retro',
      'textColor': '0xFF008080', // teal
    },
    {
      'title': 'Aurelius Gold',
      'subtitle': 'LUXURY',
      'image': 'assets/images/logo2.jpg',
      'category': 'Luxury',
      'textColor': '0xFF006666', // dark teal
    },
    {
      'title': 'Nexus Tech',
      'subtitle': 'MODERN',
      'image': 'assets/images/logo1.jpg',
      'category': 'Tech',
      'textColor': '0xFF00B4FF', // blue
    },
    {
      'title': 'Ethereal Studio',
      'subtitle': 'FASHION',
      'image': 'assets/images/logo2.jpg',
      'category': 'Modern',
      'textColor': '0xFF008080', // teal
    },
    {
      'title': 'Cyber Flux',
      'subtitle': 'TECH',
      'image': 'assets/images/logo1.jpg',
      'category': 'Tech',
      'textColor': '0xFF006666', // dark teal
    },
    {
      'title': 'Velvet Noir',
      'subtitle': 'LUXURY',
      'image': 'assets/images/logo2.jpg',
      'category': 'Luxury',
      'textColor': '0xFFFFFFFF', // white
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
      backgroundColor: const Color(0xFF008080),
      colorText: Colors.white,
    );
  }
}
