import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../../app/services/storage_service.dart';

class FolderSection {
  final String category;
  final String storagePrefix;
  final List<String> folders;
  const FolderSection(this.category, this.storagePrefix, this.folders);
}

class HomeViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  final RxInt selectedIndex = 0.obs;
  final RxBool isGuest = true.obs;
  final RxBool isLoading = true.obs;

  final RxMap<String, List<Map<String, String>>> folderData =
      <String, List<Map<String, String>>>{}.obs;

  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;

  List<String> get searchSuggestions {
    if (searchQuery.isEmpty) return [];
    final q = searchQuery.toLowerCase();
    return allSections
        .expand((s) => s.folders)
        .where((f) => f.toLowerCase().contains(q))
        .toList();
  }

  final RxList<FolderSection> sections = <FolderSection>[].obs;

  static const List<FolderSection> allSections = [
    FolderSection('Logos', 'musaf/logo', [
      'spots', 'farmer', 'functions',
      'abstract', 'animals', 'butterfly', 'camera', 'car', 'circle', 'corporal',
      'dog', 'festival', 'field', 'flowers', 'fly',
      'games', 'hallowean', 'heart', 'holiday', 'leaf', 'music', 'ngo',
      'party', 'profession', 'restaurant', 'simple', 'social',
      'square', 'star', 'text', 'tools', 'toy', 'video',
    ]),
  ];

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((user) {
      checkLoginStatus();
    });
    sections.value = allSections;
    loadAllFolders();
  }

  void checkLoginStatus() {
    isGuest.value = _auth.currentUser == null;
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> loadAllFolders() async {
    isLoading.value = true;
      for (final section in allSections) {
      for (final folderName in section.folders) {
        final path = '${section.storagePrefix}/$folderName';
        folderData[folderName] = [];
        await StorageService.getImagesOneByOne(
          path,
          limit: 10,
          onUrl: (url) {
            folderData[folderName] = [
              ...folderData[folderName] ?? [],
              {'title': folderName, 'image': url, 'textColor': '0xFFFFFFFF'},
            ];
          },
        );
        if (isLoading.value) isLoading.value = false;
      }
    }
    isLoading.value = false;
  }

  Future<List<Map<String, String>>> getAllImagesFromFolder(
      String fullPath) async {
    try {
      final urls = await StorageService.getImagesFromFolder(fullPath);
      final name = fullPath.split('/').last;
      return urls.map((url) => ({
            'title': name,
            'image': url,
            'textColor': '0xFFFFFFFF',
          })).toList();
    } catch (_) {
      return [];
    }
  }
}
