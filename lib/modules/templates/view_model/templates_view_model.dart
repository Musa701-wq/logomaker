import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/services/storage_service.dart';

class FolderPath {
  final String prefix;
  final String name;
  const FolderPath(this.prefix, this.name);
  String get fullPath => '$prefix/$name';
}

class TemplatesViewModel extends GetxController {
  var searchQuery = ''.obs;
  var isLoading = true.obs;
  var filteredTemplates = <Map<String, String>>[].obs;
  var selectedCategory = 'All'.obs;

  final List<String> categories = ['All', 'Minimal', 'Modern', 'Tech', 'Abstract', 'Retro', 'Luxury'];

  final List<Map<String, String>> templates = [];

  final Map<String, List<String>> categoryFolders = {
    'All': [
      'abstract', 'animals', 'butterfly', 'camera', 'car', 'circle', 'corporal',
      'dog', 'farmer', 'festival', 'field', 'flowers', 'fly', 'functions',
      'games', 'hallowean', 'heart', 'holiday', 'leaf', 'music', 'ngo',
      'party', 'profession', 'restaurant', 'simple', 'social', 'spots',
      'square', 'star', 'text', 'tools', 'toy', 'video',
      'blury', 'vintage',
      'decorative', 'general', 'regular', 'stylish', 'urdu',
      'basic', 'd_reverse', 'icons', 'label', 'lines', 'rectangular', 'ribben', 'round',
    ],
    'Minimal': ['simple', 'square', 'star', 'text'],
    'Modern': ['abstract', 'functions', 'tools', 'field'],
    'Tech': ['games', 'camera', 'video', 'car', 'spots'],
    'Abstract': ['abstract', 'fly', 'butterfly', 'circle'],
    'Retro': ['hallowean', 'holiday', 'party', 'festival'],
    'Luxury': ['flowers', 'heart', 'leaf', 'ngo', 'music', 'profession', 'restaurant'],
  };

  static const List<FolderPath> folderPaths = [
    FolderPath('musaf/logo', 'abstract'), FolderPath('musaf/logo', 'animals'),
    FolderPath('musaf/logo', 'butterfly'), FolderPath('musaf/logo', 'camera'),
    FolderPath('musaf/logo', 'car'), FolderPath('musaf/logo', 'circle'),
    FolderPath('musaf/logo', 'corporal'), FolderPath('musaf/logo', 'dog'),
    FolderPath('musaf/logo', 'farmer'), FolderPath('musaf/logo', 'festival'),
    FolderPath('musaf/logo', 'field'), FolderPath('musaf/logo', 'flowers'),
    FolderPath('musaf/logo', 'fly'), FolderPath('musaf/logo', 'functions'),
    FolderPath('musaf/logo', 'games'), FolderPath('musaf/logo', 'hallowean'),
    FolderPath('musaf/logo', 'heart'), FolderPath('musaf/logo', 'holiday'),
    FolderPath('musaf/logo', 'leaf'), FolderPath('musaf/logo', 'music'),
    FolderPath('musaf/logo', 'ngo'), FolderPath('musaf/logo', 'party'),
    FolderPath('musaf/logo', 'profession'), FolderPath('musaf/logo', 'restaurant'),
    FolderPath('musaf/logo', 'simple'), FolderPath('musaf/logo', 'social'),
    FolderPath('musaf/logo', 'spots'), FolderPath('musaf/logo', 'square'),
    FolderPath('musaf/logo', 'star'), FolderPath('musaf/logo', 'text'),
    FolderPath('musaf/logo', 'tools'), FolderPath('musaf/logo', 'toy'),
    FolderPath('musaf/logo', 'video'),
    FolderPath('musaf/background', 'abstract'), FolderPath('musaf/background', 'blury'),
    FolderPath('musaf/background', 'vintage'),
    FolderPath('musaf/fonts', 'decorative'), FolderPath('musaf/fonts', 'general'),
    FolderPath('musaf/fonts', 'regular'), FolderPath('musaf/fonts', 'simple'),
    FolderPath('musaf/fonts', 'stylish'), FolderPath('musaf/fonts', 'urdu'),
    FolderPath('musaf/shapes', 'basic'), FolderPath('musaf/shapes', 'd_reverse'),
    FolderPath('musaf/shapes', 'icons'), FolderPath('musaf/shapes', 'label'),
    FolderPath('musaf/shapes', 'lines'), FolderPath('musaf/shapes', 'rectangular'),
    FolderPath('musaf/shapes', 'ribben'), FolderPath('musaf/shapes', 'round'),
  ];

  @override
  void onInit() {
    super.onInit();
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    isLoading.value = true;
    for (final fp in folderPaths) {
      await StorageService.getImagesOneByOne(
        fp.fullPath,
        limit: 12,
        onUrl: (url) {
          templates.add({
            'title': fp.name,
            'subtitle': fp.name.toUpperCase(),
            'image': url,
            'category': _getCategoryForFolder(fp.name),
            'textColor': '0xFFFFFFFF',
          });
        },
      );
      if (isLoading.value) isLoading.value = false;
      updateFilteredTemplates();
    }
    isLoading.value = false;
  }

  String _getCategoryForFolder(String folderName) {
    for (final entry in categoryFolders.entries) {
      if (entry.key == 'All') continue;
      if (entry.value.contains(folderName)) return entry.key;
    }
    return 'All';
  }

  void onSearch(String query) {
    searchQuery.value = query;
    updateFilteredTemplates();
  }

  void onCategorySelected(String category) {
    selectedCategory.value = category;
    filterByCategory(category);
  }

  void updateFilteredTemplates() {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      filteredTemplates.value = List.from(templates);
    } else {
      filteredTemplates.value = templates
          .where((t) =>
              (t['title'] ?? '').toLowerCase().contains(query) ||
              (t['category'] ?? '').toLowerCase().contains(query))
          .toList();
    }
  }

  void filterByCategory(String category) {
    if (category == 'All') {
      filteredTemplates.value = List.from(templates);
    } else {
      final folders = categoryFolders[category] ?? [];
      filteredTemplates.value = templates
          .where((t) => folders.contains(t['title']))
          .toList();
    }
  }

  void addLogoToTemplates(String title, String imagePath) {
    templates.insert(0, {
      'title': title,
      'subtitle': 'AI GENERATED',
      'image': imagePath,
      'category': 'All',
      'textColor': '0xFFFFFFFF',
    });
    updateFilteredTemplates();
  }

  Color _parseColor(String hex) {
    hex = hex.replaceAll('0x', '').replaceAll('#', '');
    if (hex.length == 8) hex = hex.substring(2);
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  Color getTextColor(String? colorStr) {
    if (colorStr == null) return Colors.white;
    try {
      return _parseColor(colorStr);
    } catch (_) {
      return Colors.white;
    }
  }
}
