import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryViewModel extends GetxController {
  final historyProjects = <Map<String, String>>[].obs;

  static const _key = 'luminous_history';

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_key) ?? [];
      final loaded = raw
          .map((e) => Map<String, String>.from(jsonDecode(e) as Map))
          .where((e) {
            // Only show entries where image file exists (or is asset)
            if (e['isAsset'] == 'true') return true;
            final f = File(e['image'] ?? '');
            return f.existsSync();
          })
          .toList();
      historyProjects.assignAll(loaded);
    } catch (_) {}
  }

  Future<void> addEntry(Map<String, String> entry) async {
    historyProjects.insert(0, entry);
    await _persist();
  }

  Future<void> removeEntry(int index) async {
    if (index < 0 || index >= historyProjects.length) return;
    final entry = historyProjects[index];
    if (entry['isAsset'] != 'true') {
      try { File(entry['image']!).deleteSync(); } catch (_) {}
      // Also delete the state JSON if exists
      try {
        final sp = entry['statePath'];
        if (sp != null && sp.isNotEmpty) File(sp).deleteSync();
      } catch (_) {}
    }
    historyProjects.removeAt(index);
    await _persist();
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = historyProjects.map((e) => jsonEncode(e)).toList();
      await prefs.setStringList(_key, raw);
    } catch (_) {}
  }

  Future<void> reload() => _loadHistory();
}
