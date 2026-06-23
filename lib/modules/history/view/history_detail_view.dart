import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../../app/utils/color_constants.dart';
import '../../../app/routes/app_routes.dart';

class HistoryDetailView extends StatefulWidget {
  const HistoryDetailView({super.key});

  @override
  State<HistoryDetailView> createState() => _HistoryDetailViewState();
}

class _HistoryDetailViewState extends State<HistoryDetailView> {
  bool _saving = false;
  bool _sharing = false;

  late final Map<String, String> project;

  @override
  void initState() {
    super.initState();
    project = Get.arguments as Map<String, String>;
  }

  // ── Get image bytes from any source ──
  Future<Uint8List?> _getImageBytes() async {
    final imgPath = project['image'] ?? '';
    try {
      if (project['isAsset'] == 'true') {
        // Assets can't be shared directly — return null
        return null;
      } else if (imgPath.startsWith('http')) {
        final client = HttpClient();
        final request = await client.getUrl(Uri.parse(imgPath));
        final response = await request.close();
        final lists = await response.toList();
        client.close();
        final totalLen = lists.fold<int>(0, (p, c) => p + c.length);
        final result = Uint8List(totalLen);
        int offset = 0;
        for (final list in lists) {
          result.setRange(offset, offset + list.length, list);
          offset += list.length;
        }
        return result;
      } else if (imgPath.isNotEmpty) {
        final file = File(imgPath);
        if (await file.exists()) return await file.readAsBytes();
      }
    } catch (_) {}
    return null;
  }

  Future<void> _saveToGallery() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final bytes = await _getImageBytes();
      if (bytes == null) {
        Get.snackbar('Error', 'Cannot save this image type',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      final result = await ImageGallerySaverPlus.saveImage(bytes,
          name: 'logo_${DateTime.now().millisecondsSinceEpoch}');
      if (result != null && result['isSuccess'] == true) {
        Get.snackbar(
          'Saved',
          'Image saved to Gallery',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF008080),
          colorText: Colors.white,
          mainButton: TextButton(
            onPressed: () {},
            child: Text('View',
                style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp)),
          ),
        );
      } else {
        Get.snackbar('Error', 'Could not save image',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _shareImage() async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      final imgPath = project['image'] ?? '';
      XFile? xFile;

      if (imgPath.startsWith('http')) {
        // Download to temp and share
        final bytes = await _getImageBytes();
        if (bytes == null) throw Exception('Failed to download image');
        final dir = await getTemporaryDirectory();
        final tmpFile = File(
            '${dir.path}/share_${DateTime.now().millisecondsSinceEpoch}.png');
        await tmpFile.writeAsBytes(bytes);
        xFile = XFile(tmpFile.path);
      } else if (imgPath.isNotEmpty && project['isAsset'] != 'true') {
        final file = File(imgPath);
        if (await file.exists()) xFile = XFile(imgPath);
      }

      if (xFile != null) {
        await Share.shareXFiles(
          [xFile],
          text: 'Check out my logo made with Logo Maker!',
        );
      } else {
        Get.snackbar('Share', 'Cannot share asset images directly',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not share: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isAi = project['genType'] == 'ai';
    final bool hasState = project['statePath'] != null &&
        project['statePath']!.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: Colors.black87, size: 22.sp),
          onPressed: () => Get.back(),
        ),
        title: Text('Creation Detail',
            style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                fontSize: 17.sp)),
        actions: [
          if (hasState)
            IconButton(
              icon: Icon(Icons.edit_rounded,
                  color: const Color(0xFF008080), size: 22.sp),
              tooltip: 'Edit in Editor',
              onPressed: () => Get.toNamed(AppRoutes.editor,
                  arguments: {'statePath': project['statePath']}),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──
            _buildImage(),
            SizedBox(height: 20.h),

            // ── Title & subtitle ──
            Text(project['title'] ?? '',
                style: GoogleFonts.outfit(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            SizedBox(height: 4.h),
            Text(project['subtitle'] ?? '',
                style: GoogleFonts.outfit(
                    fontSize: 13.sp, color: Colors.black45)),

            if (isAi) ...[
              SizedBox(height: 24.h),
              _label('CATEGORY'),
              SizedBox(height: 8.h),
              _infoChip(project['category'] ?? '', Icons.category_outlined),
              SizedBox(height: 20.h),
              _label('PROMPT'),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Text(project['prompt'] ?? '',
                    style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: Colors.black54,
                        height: 1.5,
                        fontStyle: FontStyle.italic)),
              ),
            ],

            SizedBox(height: 32.h),

            // ── Action buttons ──
            Row(
              children: [
                Expanded(
                  child: _actionBtn(
                    label: _saving ? 'Saving...' : 'Save',
                    icon: Icons.download_rounded,
                    primary: true,
                    loading: _saving,
                    onTap: _saveToGallery,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _actionBtn(
                    label: _sharing ? 'Sharing...' : 'Share',
                    icon: Icons.share_rounded,
                    primary: false,
                    loading: _sharing,
                    onTap: _shareImage,
                  ),
                ),
              ],
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imgPath = project['image'] ?? '';
    Widget img;
    if (project['isAsset'] == 'true') {
      img = Image.asset(imgPath, fit: BoxFit.contain);
    } else if (imgPath.startsWith('http')) {
      img = Image.network(imgPath, fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
              Icons.broken_image_rounded,
              color: Colors.grey[400],
              size: 60.sp));
    } else {
      img = Image.file(File(imgPath), fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
              Icons.broken_image_rounded,
              color: Colors.grey[400],
              size: 60.sp));
    }

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 280.h, maxHeight: 400.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, 6))
        ],
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r), child: img),
    );
  }

  Widget _label(String text) {
    return Text(text,
        style: GoogleFonts.outfit(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black38,
            letterSpacing: 1.4));
  }

  Widget _infoChip(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 18.sp),
          SizedBox(width: 10.w),
          Text(text,
              style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _actionBtn({
    required String label,
    required IconData icon,
    required bool primary,
    required bool loading,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        decoration: BoxDecoration(
          color: primary
              ? const Color(0xFF008080)
              : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: primary
              ? null
              : Border.all(
                  color: const Color(0xFF008080).withOpacity(0.4)),
          boxShadow: primary
              ? [
                  BoxShadow(
                      color: const Color(0xFF008080).withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              SizedBox(
                width: 16.w,
                height: 16.w,
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: primary
                        ? Colors.white
                        : const Color(0xFF008080)),
              )
            else
              Icon(icon,
                  color: primary
                      ? Colors.white
                      : const Color(0xFF008080),
                  size: 18.sp),
            SizedBox(width: 8.w),
            Text(label,
                style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: primary
                        ? Colors.white
                        : const Color(0xFF008080))),
          ],
        ),
      ),
    );
  }
}
