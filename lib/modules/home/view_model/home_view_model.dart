import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../app/services/storage_service.dart';
import '../../../app/services/image_cache_db.dart';

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

  // ── Local asset images (3 per folder) shown instantly ──────────────────────
  // Firebase folder name → list of 3 local asset paths
  static const Map<String, List<String>> _localAssets = {
    'spots':      ['assets/Logoss/Logoss/logos/Sports/esport_logo_01.png', 'assets/Logoss/Logoss/logos/Sports/esport_logo_02.png', 'assets/Logoss/Logoss/logos/Sports/esport_logo_03.png'],
    'farmer':     ['assets/Logoss/Logoss/logos/Farmar/far1.png',      'assets/Logoss/Logoss/logos/Farmar/far2.png',      'assets/Logoss/Logoss/logos/Farmar/far3.png'],
    'functions':  ['assets/Logoss/Logoss/logos/Functions/fn1.png',    'assets/Logoss/Logoss/logos/Functions/fn2.png',    'assets/Logoss/Logoss/logos/Functions/fn3.png'],
    'abstract':   ['assets/Logoss/abstract/lg1.png',                  'assets/Logoss/abstract/lg2.png',                  'assets/Logoss/abstract/lg3.png'],
    'animals':    ['assets/Logoss/Logoss/logos/Animals/ani_1.png',    'assets/Logoss/Logoss/logos/Animals/ani_2.png',    'assets/Logoss/Logoss/logos/Animals/ani_3.png'],
    'butterfly':  ['assets/Logoss/Logoss/logos/Butterfly/but_1.png',  'assets/Logoss/Logoss/logos/Butterfly/but_2.png',  'assets/Logoss/Logoss/logos/Butterfly/but_3.png'],
    'camera':     ['assets/Logoss/Logoss/logos/Camera/cam_1.png',     'assets/Logoss/Logoss/logos/Camera/cam_2.png',     'assets/Logoss/Logoss/logos/Camera/cam_3.png'],
    'car':        ['assets/Logoss/Logoss/logos/Car/car_1.png',        'assets/Logoss/Logoss/logos/Car/car_2.png',        'assets/Logoss/Logoss/logos/Car/car_3.png'],
    'circle':     ['assets/Logoss/Logoss/logos/Circle/cir_1.png',     'assets/Logoss/Logoss/logos/Circle/cir_2.png',     'assets/Logoss/Logoss/logos/Circle/cir_3.png'],
    'corporal':   ['assets/Logoss/Logoss/logos/Corporal/corp_3.png',  'assets/Logoss/Logoss/logos/Corporal/corp_4.png',  'assets/Logoss/Logoss/logos/Corporal/corp_5.png'],
    'dog':        ['assets/Logoss/Logoss/logos/Dog/dog1.png',         'assets/Logoss/Logoss/logos/Dog/dog2.png',         'assets/Logoss/Logoss/logos/Dog/dog3.png'],
    'festival':   ['assets/Logoss/Logoss/logos/Festival/fes_1.png',   'assets/Logoss/Logoss/logos/Festival/fes_2.png',   'assets/Logoss/Logoss/logos/Festival/fes_3.png'],
    'field':      ['assets/Logoss/Logoss/logos/Field/fl1.png',        'assets/Logoss/Logoss/logos/Field/fl2.png',        'assets/Logoss/Logoss/logos/Field/fl3.png'],
    'flowers':    ['assets/Logoss/Logoss/logos/Flowers/flow_1.png',   'assets/Logoss/Logoss/logos/Flowers/flow_2.png',   'assets/Logoss/Logoss/logos/Flowers/flow_3.png'],
    'fly':        ['assets/Logoss/Logoss/logos/Fly/fly1.png',         'assets/Logoss/Logoss/logos/Fly/fly2.png',         'assets/Logoss/Logoss/logos/Fly/fly3.png'],
    'games':      ['assets/Logoss/Logoss/logos/Games/gm1.png',        'assets/Logoss/Logoss/logos/Games/gm2.png',        'assets/Logoss/Logoss/logos/Games/gm3.png'],
    'hallowean':  ['assets/Logoss/Logoss/logos/Hallowean/hall_1.png', 'assets/Logoss/Logoss/logos/Hallowean/hall_2.png', 'assets/Logoss/Logoss/logos/Hallowean/hall_3.png'],
    'heart':      ['assets/Logoss/Logoss/logos/Heart/hea_1.png',      'assets/Logoss/Logoss/logos/Heart/hea_2.png',      'assets/Logoss/Logoss/logos/Heart/hea_3.png'],
    'holiday':    ['assets/Logoss/Logoss/logos/Holiday/hol_1.png',    'assets/Logoss/Logoss/logos/Holiday/hol_2.png',    'assets/Logoss/Logoss/logos/Holiday/hol_3.png'],
    'leaf':       ['assets/Logoss/Logoss/logos/Leaf/lea_1.png',       'assets/Logoss/Logoss/logos/Leaf/lea_2.png',       'assets/Logoss/Logoss/logos/Leaf/lea_3.png'],
    'music':      ['assets/Logoss/Logoss/logos/Music/mus_1.png',      'assets/Logoss/Logoss/logos/Music/mus_2.png',      'assets/Logoss/Logoss/logos/Music/mus_3.png'],
    'ngo':        ['assets/Logoss/Logoss/logos/NGO/ngo_1.png',        'assets/Logoss/Logoss/logos/NGO/ngo_2.png',        'assets/Logoss/Logoss/logos/NGO/ngo_3.png'],
    'party':      ['assets/Logoss/Logoss/logos/Party/par_1.png',      'assets/Logoss/Logoss/logos/Party/par_2.png',      'assets/Logoss/Logoss/logos/Party/par_3.png'],
    'profession': ['assets/Logoss/Logoss/logos/Profession/pro_1.png', 'assets/Logoss/Logoss/logos/Profession/pro_2.png', 'assets/Logoss/Logoss/logos/Profession/pro_3.png'],
    'restaurant': ['assets/Logoss/Logoss/logos/Resturant/rest_1.png', 'assets/Logoss/Logoss/logos/Resturant/rest_2.png', 'assets/Logoss/Logoss/logos/Resturant/rest_3.png'],
    'simple':     ['assets/Logoss/Logoss/logos/Simple/s1.png',        'assets/Logoss/Logoss/logos/Simple/s2.png',        'assets/Logoss/Logoss/logos/Simple/s3.png'],
    'social':     ['assets/Logoss/Logoss/logos/Social/soc_1.png',     'assets/Logoss/Logoss/logos/Social/soc_2.png',     'assets/Logoss/Logoss/logos/Social/soc_3.png'],
    'square':     ['assets/Logoss/Logoss/logos/Square/squ_1.png',     'assets/Logoss/Logoss/logos/Square/squ_2.png',     'assets/Logoss/Logoss/logos/Square/squ_3.png'],
    'star':       ['assets/Logoss/Logoss/logos/Star/star_1.png',      'assets/Logoss/Logoss/logos/Star/star_2.png',      'assets/Logoss/Logoss/logos/Star/star_3.png'],
    'text':       ['assets/Logoss/Logoss/logos/Text/text_1.png',      'assets/Logoss/Logoss/logos/Text/text_2.png',      'assets/Logoss/Logoss/logos/Text/text_3.png'],
    'tools':      ['assets/Logoss/Logoss/logos/Tools/z1.png',         'assets/Logoss/Logoss/logos/Tools/z2.png',         'assets/Logoss/Logoss/logos/Tools/z3.png'],
    'toy':        ['assets/Logoss/Logoss/logos/Toy/toy_1.png',        'assets/Logoss/Logoss/logos/Toy/toy_2.png',        'assets/Logoss/Logoss/logos/Toy/toy_3.png'],
    'video':      ['assets/Logoss/Logoss/logos/Video/vid_1.png',      'assets/Logoss/Logoss/logos/Video/vid_2.png',      'assets/Logoss/Logoss/logos/Video/vid_3.png'],
  };

  // Number of images to show in the horizontal home row
  static const int _homeRowLimit = 8;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((_) => checkLoginStatus());
    sections.value = allSections;
    _loadFolders();
  }

  void checkLoginStatus() {
    isGuest.value = _auth.currentUser == null;
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  /// Converts an asset/url string to a map entry.
  Map<String, String> _entry(String folderName, String imagePathOrUrl) => {
    'title': folderName,
    'image': imagePathOrUrl,
    'textColor': '0xFFFFFFFF',
    'isAsset': imagePathOrUrl.startsWith('assets/') ? 'true' : 'false',
  };

  Future<void> _loadFolders() async {
    await ImageCacheDb.instance.init();

    // ── STEP 1: Show local assets immediately (instant, zero network) ──
    for (final section in allSections) {
      for (final folderName in section.folders) {
        final locals = _localAssets[folderName] ?? [];
        folderData[folderName] = locals.map((p) => _entry(folderName, p)).toList();
      }
    }
    isLoading.value = false; // UI shows instantly with local images

    // ── STEP 2: Load remaining from SQLite cache (fast, offline) ──
    for (final section in allSections) {
      for (final folderName in section.folders) {
        final path = '${section.storagePrefix}/$folderName';
        final cached = await ImageCacheDb.instance.getUrls(path);
        if (cached != null && cached.isNotEmpty) {
          // Skip first 3 (local assets), take up to 5 more = 8 total
          final extras = cached.skip(3).take(_homeRowLimit - 3).toList();
          final locals = _localAssets[folderName] ?? [];
          folderData[folderName] = [
            ...locals.map((p) => _entry(folderName, p)),
            ...extras.map((u) => _entry(folderName, u)),
          ];
        }
      }
    }

    // ── STEP 3: Background Firebase sync (check for changes) ──
    _syncFromFirebase();
  }

  Future<void> _syncFromFirebase() async {
    for (final section in allSections) {
      for (final folderName in section.folders) {
        final path = '${section.storagePrefix}/$folderName';
        try {
          // Fetch all URLs from Firebase
          final allUrls = await StorageService.getImagesFromFolder(path);
          if (allUrls.isEmpty) continue;

          // Check if data changed vs what's stored
          final changed = await ImageCacheDb.instance.hasChanged(path, allUrls);
          if (!changed) continue; // No change, skip UI update

          // Save new URLs to SQLite
          await ImageCacheDb.instance.saveUrls(path, allUrls);

          // Skip first 3 (local assets cover those), use rest from Firebase — cap at 8 for home row
          final firebaseExtras = allUrls.skip(3).take(_homeRowLimit - 3).toList();
          final locals = _localAssets[folderName] ?? [];

          folderData[folderName] = [
            ...locals.map((p) => _entry(folderName, p)),
            ...firebaseExtras.map((u) => _entry(folderName, u)),
          ];
        } catch (_) {
          // Silently fail — local + cached data still shown
        }
      }
    }
  }

  /// Used by CategoryGridView to get ALL images for a folder.
  Future<List<Map<String, String>>> getAllImagesFromFolder(String fullPath) async {
    final folderName = fullPath.split('/').last;
    try {
      // Try SQLite cache first
      final cached = await ImageCacheDb.instance.getUrls(fullPath);
      final locals = _localAssets[folderName] ?? [];

      List<String> firebaseUrls;
      if (cached != null && cached.isNotEmpty) {
        firebaseUrls = cached.skip(3).toList();
      } else {
        // Fetch from Firebase if not cached
        final all = await StorageService.getImagesFromFolder(fullPath);
        await ImageCacheDb.instance.saveUrls(fullPath, all);
        firebaseUrls = all.skip(3).toList();
      }

      return [
        ...locals.map((p) => _entry(folderName, p)),
        ...firebaseUrls.map((u) => _entry(folderName, u)),
      ];
    } catch (_) {
      final locals = _localAssets[folderName] ?? [];
      return locals.map((p) => _entry(folderName, p)).toList();
    }
  }
}
