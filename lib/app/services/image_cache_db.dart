import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// SQLite-based cache for Firebase image URLs per folder.
/// Stores: folder path → list of URLs + a version hash.
/// If Firebase returns a different hash, cache is refreshed.
class ImageCacheDb {
  static ImageCacheDb? _instance;
  Database? _db;

  ImageCacheDb._();

  static ImageCacheDb get instance {
    _instance ??= ImageCacheDb._();
    return _instance!;
  }

  Future<void> init() async {
    if (_db != null) return;
    final dir = await getApplicationDocumentsDirectory();
    _db = await openDatabase(
      p.join(dir.path, 'image_cache_v2.db'),
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE folder_cache (
            folder_path TEXT PRIMARY KEY,
            urls        TEXT NOT NULL,
            url_hash    TEXT NOT NULL,
            cached_at   INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> _ensure() async {
    if (_db == null) await init();
  }

  /// Returns cached URLs for [folderPath], or null if not cached.
  Future<List<String>?> getUrls(String folderPath) async {
    await _ensure();
    final rows = await _db!.query(
      'folder_cache',
      where: 'folder_path = ?',
      whereArgs: [folderPath],
    );
    if (rows.isEmpty) return null;
    final raw = rows.first['urls'] as String;
    return raw.split('|||').where((s) => s.isNotEmpty).toList();
  }

  /// Returns stored hash for [folderPath], or null.
  Future<String?> getHash(String folderPath) async {
    await _ensure();
    final rows = await _db!.query(
      'folder_cache',
      where: 'folder_path = ?',
      whereArgs: [folderPath],
    );
    if (rows.isEmpty) return null;
    return rows.first['url_hash'] as String?;
  }

  /// Saves [urls] with a [hash] for [folderPath].
  Future<void> saveUrls(String folderPath, List<String> urls) async {
    await _ensure();
    final hash = _computeHash(urls);
    await _db!.insert(
      'folder_cache',
      {
        'folder_path': folderPath,
        'urls': urls.join('|||'),
        'url_hash': hash,
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Returns true if stored hash differs from hash of [newUrls].
  Future<bool> hasChanged(String folderPath, List<String> newUrls) async {
    final stored = await getHash(folderPath);
    if (stored == null) return true;
    return stored != _computeHash(newUrls);
  }

  String _computeHash(List<String> urls) {
    // Simple deterministic hash: join + length checksum
    final joined = urls.join('|');
    int hash = 0;
    for (final c in joined.codeUnits) {
      hash = (hash * 31 + c) & 0xFFFFFFFF;
    }
    return '${urls.length}_$hash';
  }
}
