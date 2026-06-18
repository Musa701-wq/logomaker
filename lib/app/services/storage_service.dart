import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<List<String>> getImagesFromFolder(String folderPath) async {
    final ref = _storage.ref(folderPath);
    final result = await ref.listAll();
    final futures = result.items.map((item) => item.getDownloadURL());
    return Future.wait<String>(futures);
  }

  static Future<List<String>> getImagesFromFolderLimited(
    String folderPath, {
    int limit = 10,
  }) async {
    final ref = _storage.ref(folderPath);
    final result = await ref.listAll();
    final items = result.items.take(limit).toList();
    final futures = items.map((item) => item.getDownloadURL());
    return Future.wait<String>(futures);
  }

  static Future<void> getImagesOneByOne(
    String folderPath, {
    int limit = 10,
    required void Function(String url) onUrl,
  }) async {
    final ref = _storage.ref(folderPath);
    final result = await ref.listAll();
    final items = result.items.take(limit).toList();
    for (final item in items) {
      try {
        final url = await item.getDownloadURL();
        onUrl(url);
      } catch (_) {}
    }
  }

  static Future<List<String>> getFileNames(String folderPath) async {
    final ref = _storage.ref(folderPath);
    final result = await ref.listAll();
    return result.items.map((item) => item.name).toList();
  }

  static Future<Map<String, String>> getFolderPreviews(
    List<String> folderPaths,
  ) async {
    final Map<String, String> previews = {};
    await Future.wait(
      folderPaths.map((path) async {
        try {
          final urls = await getImagesFromFolderLimited(path, limit: 1);
          if (urls.isNotEmpty) {
            final folderName = path.split('/').last;
            previews[folderName] = urls.first;
          }
        } catch (_) {}
      }),
    );
    return previews;
  }
}
