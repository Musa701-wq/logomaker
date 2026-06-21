import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CacheService {
  static CacheService? _instance;
  Database? _db;
  late final String _cacheDir;
  final _mutex = {};

  CacheService._();

  static CacheService get instance {
    _instance ??= CacheService._();
    return _instance!;
  }

  Future<void> init() async {
    if (_db != null) return;
    final appDir = await getApplicationDocumentsDirectory();
    _cacheDir = '${appDir.path}/musaf_cache';
    await Directory(_cacheDir).create(recursive: true);
    _db = await openDatabase(
      p.join(_cacheDir, 'cache.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE cache (url TEXT PRIMARY KEY, local_path TEXT NOT NULL)',
        );
      },
    );
  }

  Future<void> _ensureInit() async {
    if (_db == null) await init();
  }

  Future<String?> getLocalPath(String url) async {
    await _ensureInit();
    try {
      final rows = await _db!.query('cache', where: 'url = ?', whereArgs: [url]);
      if (rows.isNotEmpty) return rows.first['local_path'] as String;
    } catch (_) {}
    return null;
  }

  Future<bool> isCached(String url) async {
    final path = await getLocalPath(url);
    if (path == null) return false;
    return File(path).existsSync();
  }

  Future<String> cacheImage(String url) async {
    await _ensureInit();
    try {
      final existing = await getLocalPath(url);
      if (existing != null && File(existing).existsSync()) return existing;

      final fileName = base64Encode(url.codeUnits);
      final filePath = '$_cacheDir/$fileName';
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode == 200) {
        final bytes = await response.fold<List<int>>([], (p, c) => p..addAll(c));
        await File(filePath).writeAsBytes(bytes);
        await _db!.insert('cache', {'url': url, 'local_path': filePath},
            conflictAlgorithm: ConflictAlgorithm.replace);
        return filePath;
      }
    } catch (_) {}
    return '';
  }

  Future<void> cacheImagesInBatches(
    List<String> urls, {
    int batchSize = 10,
    void Function(int completed, int total)? onProgress,
  }) async {
    await _ensureInit();
    int completed = 0;
    for (int i = 0; i < urls.length; i += batchSize) {
      final batch = urls.skip(i).take(batchSize).toList();
      for (final u in batch) {
        await cacheImage(u);
        completed++;
        onProgress?.call(completed, urls.length);
      }
    }
  }
}

String base64Encode(List<int> codeUnits) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
  final result = StringBuffer();
  for (int i = 0; i < codeUnits.length; i += 3) {
    final b1 = codeUnits[i];
    final b2 = i + 1 < codeUnits.length ? codeUnits[i + 1] : 0;
    final b3 = i + 2 < codeUnits.length ? codeUnits[i + 2] : 0;
    final triple = (b1 << 16) | (b2 << 8) | b3;
    result.write(chars[(triple >> 18) & 0x3F]);
    result.write(chars[(triple >> 12) & 0x3F]);
    if (i + 1 < codeUnits.length) result.write(chars[(triple >> 6) & 0x3F]);
    if (i + 2 < codeUnits.length) result.write(chars[triple & 0x3F]);
  }
  return result.toString();
}
