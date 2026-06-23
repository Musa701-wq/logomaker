import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/widgets/cached_image.dart';
import '../view_model/home_view_model.dart';

class CategoryGridView extends StatefulWidget {
  final String title;
  final List<Map<String, String>> items;
  final String? storagePath;

  const CategoryGridView({
    super.key,
    required this.title,
    required this.items,
    this.storagePath,
  });

  @override
  State<CategoryGridView> createState() => _CategoryGridViewState();
}

class _CategoryGridViewState extends State<CategoryGridView> {
  late List<Map<String, String>> _items;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
    // If no items passed and storagePath provided, fetch immediately
    if (_items.isEmpty && widget.storagePath != null) {
      _fetchItems();
    }
  }

  Future<void> _fetchItems() async {
    setState(() => _isLoading = true);
    try {
      final vm = Get.find<HomeViewModel>();
      final result = await vm.getAllImagesFromFolder(widget.storagePath!);
      if (mounted) {
        setState(() {
          _items = result;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Color(0xFF008080)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          widget.title.replaceAll('\n', ' '),
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: _isLoading
          ? _buildLoadingGrid()
          : _items.isEmpty
              ? _buildEmpty()
              : GridView.builder(
                  padding: EdgeInsets.all(16.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final project = _items[index];
                    return GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.editor, arguments: {
                        'templateImage': project['image'],
                        'templateText': project['title'],
                        'templateTextColor': project['textColor'],
                      }),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            project['isAsset'] == 'true'
                                ? Image.asset(
                                    project['image']!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )
                                : CachedImage(
                                    project['image']!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Container(color: Colors.grey[800]),
                                  ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.6),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: 12.h, left: 8.w, right: 8.w),
                                child: Text(
                                  project['title'] ?? '',
                                  style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  // Shimmer-style loading placeholder grid
  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 1.0,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: _ShimmerBox(),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        'No templates found',
        style: GoogleFonts.outfit(color: Colors.black38, fontSize: 14.sp),
      ),
    );
  }
}

// Simple animated shimmer placeholder
class _ShimmerBox extends StatefulWidget {
  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Color.lerp(
            const Color(0xFFE0E0E0),
            const Color(0xFFBDBDBD),
            _animation.value,
          ),
        ),
      ),
    );
  }
}
