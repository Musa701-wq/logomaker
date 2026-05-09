import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import '../../../models/editor_element.dart';
import '../../history/view_model/history_view_model.dart';

class EditorViewModel extends GetxController {
  // Navigation & General State
  final selectedTool = 'DEFAULT'.obs;
  final subCategory = 'COLOR'.obs; 
  final activeSubTool = ''.obs;
  final currentTab = 'TEXT'.obs;
  
  // Panel tab states
  final colorTab = 'SOLID'.obs;
  final bgTab = 'SOLID'.obs;
  
  final isLoading = false.obs;
  final isEditingText = false.obs;
  
  final ScreenshotController screenshotController = ScreenshotController();
  final ImagePicker _picker = ImagePicker();

  // Canvas State
  final components = <EditorElement>[].obs;
  final selectedIndex = (-1).obs;
  final selectedFontCategory = 'All Styles'.obs;
  final aspectRatio = 1.0.obs;

  // Gesture State (Temporary variables for smooth scaling/rotation)
  double _baseScale = 1.0;
  double _baseRotation = 0.0;
  Offset _basePosition = Offset.zero;

  void onScaleStart(int index) {
    if (index != -1 && index < components.length) {
      _pushHistory(); // Save state before change
      selectedIndex.value = index;
      _baseScale = components[index].scale;
      _baseRotation = components[index].rotation;
      _basePosition = components[index].position;
    }
  }

  void onScaleUpdate(int index, ScaleUpdateDetails details) {
    if (index != -1 && index < components.length) {
      _basePosition += details.focalPointDelta;
      final double newScale = (_baseScale * details.scale).clamp(0.1, 10.0);
      final double newRotation = _baseRotation + details.rotation;

      // Direct assignment without triggering full list rebuild
      components[index] = components[index].copyWith(
        position: _basePosition,
        scale: newScale,
        rotation: newRotation,
      );
      // Only notify the specific index change, not full refresh
      components.refresh();
    }
  }

  // Undo / Redo stacks
  final canUndo = false.obs;
  final canRedo = false.obs;

  // Full snapshot: components + bg color + bg gradient + aspect ratio
  Map<String, dynamic> _snapshot() => {
    'components': List<EditorElement>.from(components),
    'bgColor': backgroundColor.value,
    'bgGradient': backgroundGradient.value != null ? List<Color>.from(backgroundGradient.value!) : null,
    'aspectRatio': aspectRatio.value,
    'selectedIndex': selectedIndex.value,
  };

  void _applySnapshot(Map<String, dynamic> s) {
    components.assignAll(s['components'] as List<EditorElement>);
    backgroundColor.value = s['bgColor'] as Color;
    backgroundGradient.value = s['bgGradient'] as List<Color>?;
    aspectRatio.value = s['aspectRatio'] as double;
    selectedIndex.value = s['selectedIndex'] as int? ?? -1;
  }

  void _pushHistory() {
    _undoSnapshots.add(_snapshot());
    if (_undoSnapshots.length > 50) _undoSnapshots.removeAt(0);
    _redoSnapshots.clear();
    canUndo.value = _undoSnapshots.isNotEmpty;
    canRedo.value = false;
  }

  final List<Map<String, dynamic>> _undoSnapshots = [];
  final List<Map<String, dynamic>> _redoSnapshots = [];

  void undo() {
    if (_undoSnapshots.isEmpty) return;
    _redoSnapshots.add(_snapshot());
    final prev = _undoSnapshots.removeLast();
    _applySnapshot(prev);
    canUndo.value = _undoSnapshots.isNotEmpty;
    canRedo.value = _redoSnapshots.isNotEmpty;
  }

  void redo() {
    if (_redoSnapshots.isEmpty) return;
    _undoSnapshots.add(_snapshot());
    final next = _redoSnapshots.removeLast();
    _applySnapshot(next);
    canUndo.value = _undoSnapshots.isNotEmpty;
    canRedo.value = _redoSnapshots.isNotEmpty;
  }
  
  // Background State
  final backgroundColor = const Color(0xFF0B0D13).obs; // AppColors.premiumDark
  final backgroundGradient = Rx<List<Color>?>(null);
  
  final List<String> fonts = [
    // GAMING
    'Press Start 2P', 'Orbitron', 'Russo One', 'Black Ops One', 'Michroma', 'Silkscreen', 'Chakra Petch', 'Wallpoet', 'Megrim', 'Saira Stencil One',
    // EDITORIAL
    'Bodoni Moda', 'Playfair Display', 'Prata', 'Cinzel', 'Cormorant Garamond', 'Libre Baskerville', 'Fraunces', 'Noto Serif', 'Libre Caslon Display', 'Spectral',
    // MONO
    'Space Mono', 'Fira Code', 'Source Code Pro', 'JetBrains Mono', 'Nova Mono', 'Ubuntu Mono', 'Roboto Mono', 'Anonymous Pro', 'Courier Prime',
    // DISPLAY
    'Monoton', 'Bungee', 'Alfa Slab One', 'Bangers', 'Faster One', 'Righteous', 'Permanent Marker', 'Lobster', 'Pacifico', 'Dancing Script', 'Caveat', 'Satisfy', 'Great Vibes',
    // SANS
    'Manrope', 'Inter', 'Roboto', 'Lato', 'Montserrat', 'Poppins', 'Raleway', 'Nunito', 'Josefin Sans', 'Space Grotesk',
  ];

  List<String> get filteredFonts {
    if (selectedFontCategory.value == 'All Styles') return fonts;
    if (selectedFontCategory.value == 'Gaming') return ['Press Start 2P', 'Orbitron', 'Russo One', 'Black Ops One', 'Michroma', 'Silkscreen', 'Chakra Petch', 'Wallpoet', 'Megrim', 'Saira Stencil One', 'Audiowide', 'Staatliches'];
    if (selectedFontCategory.value == 'Editorial') return ['Bodoni Moda', 'Playfair Display', 'Prata', 'Cinzel', 'Cormorant Garamond', 'Libre Baskerville', 'Abril Fatface', 'Crimson Text', 'Fraunces', 'Cardo', 'Noto Serif', 'Libre Caslon Display', 'Spectral'];
    if (selectedFontCategory.value == 'Monospace') return ['Space Mono', 'Fira Code', 'Source Code Pro', 'JetBrains Mono', 'Nova Mono', 'Ubuntu Mono', 'Inconsolata', 'Major Mono Display', 'Roboto Mono', 'Anonymous Pro', 'Courier Prime'];
    return fonts;
  }

  final List<Map<String, dynamic>> ratios = [
    {'name': 'Square', 'ratio': 1.0, 'icon': Icons.crop_square},
    {'name': 'Story', 'ratio': 9/16, 'icon': Icons.stay_current_portrait},
    {'name': '3:2 (Web)', 'ratio': 3/2, 'icon': Icons.aspect_ratio},
    {'name': 'Post', 'ratio': 4/5, 'icon': Icons.portrait},
    {'name': 'Landscape', 'ratio': 16/9, 'icon': Icons.stay_current_landscape},
    {'name': 'UltraWide', 'ratio': 21/9, 'icon': Icons.panorama},
    {'name': 'A4 Paper', 'ratio': 1/1.414, 'icon': Icons.description},
  ];

  @override
  void onInit() {
    super.onInit();
    // Shuffle fonts to show variety at the top
    fonts.shuffle();

    // When text editing ends, return to the TEXT sub-panel automatically
    ever(isEditingText, (bool editing) {
      if (!editing) {
        subCategory.value = 'TEXT';
        activeSubTool.value = '';
      }
    });

    final args = Get.arguments;
    if (args != null && args['statePath'] != null) {
      // Restore from saved history state
      WidgetsBinding.instance.addPostFrameCallback((_) {
        restoreFromStatePath(args['statePath'] as String);
      });
    } else if (args != null && args['templateImage'] != null) {
      // Clear any previous state
      components.clear();
      selectedIndex.value = -1;

      // Match the screenshot: dark indigo/blue background
      backgroundColor.value = const Color(0xFF2B2E7A);

      final imgElement = EditorElement(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_img',
        type: ElementType.image,
        position: const Offset(60, 40),
        content: args['templateImage'],
        scale: 2.2,
        opacity: 1.0,
      );

      final txtElement = EditorElement(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_txt',
        type: ElementType.text,
        position: const Offset(20, 270),
        content: args['templateText'] ?? 'Esport',
        scale: 1.0,
        fontSize: 52,
        color: args['templateTextColor'] != null
            ? Color(int.parse(args['templateTextColor'] as String))
            : Colors.white,
        fontFamily: 'Oswald',
        fontWeight: FontWeight.w900,
        letterSpacing: 4.0,
        outlineColor: const Color(0xFF9C6FFF),
        outlineWidth: 3.0,
        glowColor: const Color(0xFF9C6FFF),
        glowRadius: 10.0,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        components.addAll([imgElement, txtElement]);
        selectElement(-1);
      });
    }
  }

  void selectTool(String tool) {
    selectedTool.value = tool;
  }

  void setSubCategory(String cat) {
    subCategory.value = cat;
    activeSubTool.value = ''; // Reset drill-down
  }

  void setAspectRatio(double ratio) {
    _pushHistory();
    aspectRatio.value = ratio;
  }

  void setActiveSubTool(String tool) {
    activeSubTool.value = tool;
  }

  // --- Element Management ---
  
  void addText() {
    final newElement = EditorElement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ElementType.text,
      position: const Offset(100, 100),
      content: 'Tap to edit',
      fontSize: 32,
      color: Colors.white,
      fontFamily: 'Manrope',
      fontWeight: FontWeight.bold,
    );
    _pushHistory();
    components.add(newElement);
    selectElement(components.length - 1);
  }

  Future<void> addImage() async {
    final status = await Permission.photos.request();
    if (status.isGranted || status.isLimited) {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        for (int i = 0; i < images.length; i++) {
          final newElement = EditorElement(
            id: DateTime.now().millisecondsSinceEpoch.toString() + '_$i',
            type: ElementType.image,
            position: Offset(80.0 + (i * 20), 80.0 + (i * 20)),
            content: images[i].path,
            scale: 1.0,
          );
          components.add(newElement);
        }
        _pushHistory();
        selectElement(components.length - 1);
      }
    }
  }

  void addShape(String shapeType) {
    final newElement = EditorElement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ElementType.shape,
      position: const Offset(120, 120),
      content: shapeType,
      color: Colors.blueAccent.withOpacity(0.5),
      outlineColor: Colors.blueAccent,
      outlineWidth: 2,
    );
    _pushHistory();
    components.add(newElement);
    selectElement(components.length - 1);
  }

  void selectElement(int index) {
    selectedIndex.value = index;
    isEditingText.value = false;
    activeSubTool.value = '';
    if (index != -1) {
      final type = components[index].type;
      if (type == ElementType.text) {
        selectedTool.value = 'TEXT';
        subCategory.value = 'TEXT';
        currentTab.value = 'TEXT';
      } else if (type == ElementType.image) {
        selectedTool.value = 'IMAGE';
        subCategory.value = 'FILTER';
        currentTab.value = 'EFFECTS';
      } else {
        selectedTool.value = 'SHAPE';
        subCategory.value = 'STYLE';
        currentTab.value = 'COLORS';
      }
    } else {
      selectedTool.value = 'DEFAULT';
    }
  }

  void updateElementPosition(int index, Offset delta) {
    if (index != -1 && index < components.length) {
      components[index] = components[index].copyWith(
        position: components[index].position + delta,
      );
      components.refresh();
    }
  }

  void updateSelectedElement(EditorElement Function(EditorElement) update, {bool saveHistory = true}) {
    if (selectedIndex.value != -1) {
      if (saveHistory) _pushHistory();
      components[selectedIndex.value] = update(components[selectedIndex.value]);
      components.refresh();
    }
  }

  // Called when slider drag begins — saves state before change
  void startSliderChange() {
    _pushHistory();
  }

  // Called when slider drag ends
  void commitSliderHistory() {
    // We already save at start, but we can keep this for other non-start based updates if needed
    // For now, we'll rely on startSliderChange for undo consistency
  }

  void removeSelected() {
    if (selectedIndex.value != -1) {
      _pushHistory();
      components.removeAt(selectedIndex.value);
      selectedIndex.value = -1;
      selectedTool.value = 'DEFAULT';
    }
  }

  void duplicateSelected() {
    if (selectedIndex.value != -1) {
      _pushHistory();
      final el = components[selectedIndex.value];
      final newEl = el.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        position: el.position + const Offset(20, 20),
      );
      components.add(newEl);
      selectElement(components.length - 1);
    }
  }

  void moveLayer(int oldIndex, int newIndex) {
    if (newIndex < 0 || newIndex >= components.length) return;
    _pushHistory();
    final item = components.removeAt(oldIndex);
    components.insert(newIndex, item);
    selectedIndex.value = newIndex;
    components.refresh();
  }

  // --- Adjustments ---

  List<double> getAdjustmentMatrix(EditorElement e) {
    double b = e.brightness * 255;
    double c = e.contrast;
    double s = e.saturation;
    double ex = e.exposure + 1.0; // 0 to 2 range practically
    double hue = e.hue * 3.14159; // range -pi to pi
    
    // Identity Matrix
    List<double> matrix = [
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 1, 0,
    ];

    // Exposure
    double ev = ex;
    matrix = _multiplyMatrices(matrix, [
      ev, 0, 0, 0, 0,
      0, ev, 0, 0, 0,
      0, 0, ev, 0, 0,
      0, 0, 0, 1, 0,
    ]);

    // Contrast & Brightness
    double t = 128 * (1 - c);
    matrix = _multiplyMatrices(matrix, [
      c, 0, 0, 0, t + b,
      0, c, 0, 0, t + b,
      0, 0, c, 0, t + b,
      0, 0, 0, 1, 0,
    ]);

    // Saturation
    double lr = 0.2126, lg = 0.7152, lb = 0.0722;
    double sr = (1 - s) * lr;
    double sg = (1 - s) * lg;
    double sb = (1 - s) * lb;
    matrix = _multiplyMatrices(matrix, [
      sr + s, sg, sb, 0, 0,
      sr, sg + s, sb, 0, 0,
      sr, sg, sb + s, 0, 0,
      0, 0, 0, 1, 0,
    ]);

    // Hue
    if (hue != 0) {
      double cosVal = Math.cos(hue);
      double sinVal = Math.sin(hue);
      double lumR = 0.213, lumG = 0.715, lumB = 0.072;
      matrix = _multiplyMatrices(matrix, [
        lumR + cosVal * (1 - lumR) + sinVal * (-lumR), lumG + cosVal * (-lumG) + sinVal * (-lumG), lumB + cosVal * (-lumB) + sinVal * (1 - lumB), 0, 0,
        lumR + cosVal * (-lumR) + sinVal * (0.143), lumG + cosVal * (1 - lumG) + sinVal * (0.140), lumB + cosVal * (-lumB) + sinVal * (-0.283), 0, 0,
        lumR + cosVal * (-lumR) + sinVal * (-(1 - lumR)), lumG + cosVal * (-lumG) + sinVal * (lumG), lumB + cosVal * (1 - lumB) + sinVal * (lumB), 0, 0,
        0, 0, 0, 1, 0,
      ]);
    }

    // Sepia
    if (e.sepia > 0) {
      double sep = e.sepia;
      double invSep = 1 - sep;
      matrix = _multiplyMatrices(matrix, [
        invSep + sep * 0.393, sep * 0.769, sep * 0.189, 0, 0,
        sep * 0.349, invSep + sep * 0.686, sep * 0.168, 0, 0,
        sep * 0.272, sep * 0.534, invSep + sep * 0.131, 0, 0,
        0, 0, 0, 1, 0,
      ]);
    }

    return matrix;
  }

  List<double> _multiplyMatrices(List<double> m1, List<double> m2) {
    List<double> result = List.filled(20, 0.0);
    for (int y = 0; y < 4; y++) {
      for (int x = 0; x < 5; x++) {
        double sum = 0;
        for (int i = 0; i < 4; i++) {
          sum += m1[y * 5 + i] * m2[i * 5 + (x == 4 ? 4 : x)];
        }
        if (x == 4) sum += m1[y * 5 + 4];
        result[y * 5 + x] = sum;
      }
    }
    return result;
  }

  final List<Map<String, dynamic>> filters = [
    {'name': 'Original', 'matrix': [1.0,0.0,0.0,0.0,0.0, 0.0,1.0,0.0,0.0,0.0, 0.0,0.0,1.0,0.0,0.0, 0.0,0.0,0.0,1.0,0.0]},
    {'name': 'Clarendon', 'matrix': [1.2,0.0,0.0,0.0,0.1, 0.0,1.2,0.0,0.0,0.1, 0.0,0.0,1.2,0.0,0.1, 0.0,0.0,0.0,1.0,0.0]},
    {'name': 'Gingham', 'matrix': [0.9,0.0,0.0,0.0,0.0, 0.0,0.9,0.0,0.0,0.0, 0.0,0.0,0.9,0.0,0.0, 0.0,0.0,0.0,1.0,0.0]},
    {'name': 'Moon', 'matrix': [0.21,0.72,0.07,0.0,0.0, 0.21,0.72,0.07,0.0,0.0, 0.21,0.72,0.07,0.0,0.0, 0.0,0.0,0.0,1.0,0.0]},
    {'name': 'Lark', 'matrix': [1.1,0.0,0.0,0.0,0.0, 0.0,1.1,0.0,0.0,0.0, 0.0,0.0,1.1,0.0,0.0, 0.0,0.0,0.0,1.0,0.0]},
    {'name': 'Vintage', 'matrix': [0.9,0.4,0.2,0.0,0.0, 0.3,0.8,0.1,0.0,0.0, 0.2,0.3,0.5,0.0,0.0, 0.0,0.0,0.0,1.0,0.0]},
    {'name': 'Chrome', 'matrix': [1.4,0.0,0.0,0.0,0.0, 0.0,1.2,0.0,0.0,0.0, 0.0,0.0,1.0,0.0,0.0, 0.0,0.0,0.0,1.0,0.0]},
    {'name': 'Faded', 'matrix': [1.0,0.0,0.0,0.0,0.2, 0.0,1.0,0.0,0.0,0.2, 0.0,0.0,1.0,0.0,0.2, 0.0,0.0,0.0,1.0,0.0]},
    {'name': 'Forest', 'matrix': [0.8,0.0,0.0,0.0,0.0, 0.0,1.3,0.0,0.0,0.0, 0.0,0.0,0.9,0.0,0.0, 0.0,0.0,0.0,1.0,0.0]},
    {'name': 'Sunset', 'matrix': [1.3,0.0,0.0,0.0,0.1, 0.0,1.0,0.0,0.0,0.0, 0.0,0.0,0.7,0.0,0.0, 0.0,0.0,0.0,1.0,0.0]},
    {'name': 'Cold', 'matrix': [0.9,0.0,0.0,0.0,0.0, 0.0,1.1,0.0,0.0,0.0, 0.0,0.0,1.5,0.0,0.0, 0.0,0.0,0.0,1.0,0.0]},
    {'name': 'Invert', 'matrix': [-1.0,0.0,0.0,0.0,1.0, 0.0,-1.0,0.0,0.0,1.0, 0.0,0.0,-1.0,0.0,1.0, 0.0,0.0,0.0,1.0,0.0]},
  ];

  void setBackgroundColor(Color color) {
    _pushHistory();
    backgroundColor.value = color;
    backgroundGradient.value = null;
  }

  void setBackgroundGradient(List<Color> colors) {
    _pushHistory();
    backgroundGradient.value = colors;
  }

  Future<void> exportDesign() async {
    try {
      isLoading.value = true;
      int prevSelected = selectedIndex.value;
      selectedIndex.value = -1;
      await Future.delayed(const Duration(milliseconds: 100));
      final Uint8List? imageBytes = await screenshotController.capture();
      if (imageBytes != null) {
        final result = await ImageGallerySaverPlus.saveImage(imageBytes);
        if (result != null && result['isSuccess'] == true) {
          Get.snackbar('Success', 'Design exported!');
        }
      }
      selectedIndex.value = prevSelected;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Auto-save snapshot to history when leaving editor
  Future<void> autoSaveToHistory() async {
    if (components.isEmpty) return;
    try {
      final int prevSelected = selectedIndex.value;
      selectedIndex.value = -1;
      await Future.delayed(const Duration(milliseconds: 80));
      final Uint8List? imageBytes = await screenshotController.capture();
      selectedIndex.value = prevSelected;
      if (imageBytes == null) return;

      // Save to app documents directory (persistent)
      final dir = await getApplicationDocumentsDirectory();
      final histDir = Directory('${dir.path}/luminous_history');
      if (!await histDir.exists()) await histDir.create(recursive: true);

      final String fileName = 'design_${DateTime.now().millisecondsSinceEpoch}.png';
      final String filePath = '${histDir.path}/$fileName';
      await File(filePath).writeAsBytes(imageBytes);

      // Add to history
      try {
        final historyVm = Get.find<HistoryViewModel>();
        final now = DateTime.now();
        await historyVm.addEntry({
          'title': 'Design ${now.day}/${now.month} ${now.hour}:${now.minute.toString().padLeft(2, '0')}',
          'subtitle': 'Just now',
          'image': filePath,
          'isAsset': 'false',
          'genType': 'custom',
        });
      } catch (_) {}
    } catch (_) {}
  }

  // Save template changes to history
  Future<void> saveTemplateChangesToHistory() async {
    if (components.isEmpty) return;
    try {
      final int prevSelected = selectedIndex.value;
      selectedIndex.value = -1;
      await Future.delayed(const Duration(milliseconds: 100));
      final Uint8List? imageBytes = await screenshotController.capture();
      selectedIndex.value = prevSelected;
      if (imageBytes == null) return;

      // Save screenshot
      final dir = await getApplicationDocumentsDirectory();
      final histDir = Directory('${dir.path}/luminous_history');
      if (!await histDir.exists()) await histDir.create(recursive: true);

      final String ts = DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath = '${histDir.path}/template_$ts.png';
      await File(filePath).writeAsBytes(imageBytes);

      // Serialize full editor state to JSON file
      final stateData = {
        'components': components.map((e) => e.toJson()).toList(),
        'bgColor': backgroundColor.value.value,
        'bgGradient': backgroundGradient.value?.map((c) => c.value).toList(),
        'aspectRatio': aspectRatio.value,
      };
      final String statePath = '${histDir.path}/state_$ts.json';
      await File(statePath).writeAsString(jsonEncode(stateData));

      try {
        final historyVm = Get.find<HistoryViewModel>();
        final now = DateTime.now();
        await historyVm.addEntry({
          'title': 'Template Design ${now.day}/${now.month} ${now.hour}:${now.minute.toString().padLeft(2, '0')}',
          'subtitle': 'Template modified',
          'image': filePath,
          'isAsset': 'false',
          'genType': 'template',
          'statePath': statePath,
        });
      } catch (_) {}
    } catch (_) {}
  }

  // Restore full editor state from a saved JSON state file
  Future<void> restoreFromStatePath(String statePath) async {
    try {
      final file = File(statePath);
      if (!await file.exists()) return;
      final raw = await file.readAsString();
      final data = jsonDecode(raw) as Map<String, dynamic>;

      final restored = (data['components'] as List)
          .map((e) => EditorElement.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();

      components.assignAll(restored);
      backgroundColor.value = Color(data['bgColor'] as int);
      backgroundGradient.value = (data['bgGradient'] as List?)
          ?.map((v) => Color(v as int))
          .toList();
      aspectRatio.value = (data['aspectRatio'] as num).toDouble();
      selectedIndex.value = -1;
    } catch (_) {}
  }
}
