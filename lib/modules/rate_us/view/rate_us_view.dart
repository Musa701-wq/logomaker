import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RateUsView extends StatefulWidget {
  const RateUsView({super.key});

  @override
  State<RateUsView> createState() => _RateUsViewState();
}

class _RateUsViewState extends State<RateUsView> {
  int _rating = 0;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _loadRating();
  }

  Future<void> _loadRating() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt('user_rating') ?? 0;
    if (mounted) setState(() { _rating = saved; _saved = saved > 0; });
  }

  Future<void> _saveRating(int rating) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_rating', rating);
    if (mounted) setState(() { _rating = rating; _saved = true; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.black87, size: 24.sp),
          onPressed: () => Get.back(),
        ),
        title: Text('Rate Us', style: GoogleFonts.outfit(
          color: Colors.black87, fontSize: 18.sp, fontWeight: FontWeight.bold,
        )),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100.w, height: 100.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF008080).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.star_rounded, color: const Color(0xFF008080), size: 48.sp),
              ),
              SizedBox(height: 24.h),
              Text(
                _saved ? 'Thank You!' : 'Love our app?',
                style: GoogleFonts.outfit(
                  fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                _saved
                    ? 'You rated us $_rating out of 5'
                    : 'Tap a star to rate your experience',
                style: GoogleFonts.outfit(
                  fontSize: 14.sp, color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final starIdx = i + 1;
                  return GestureDetector(
                    onTap: _saved ? null : () => _saveRating(starIdx),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Icon(
                        starIdx <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                        color: starIdx <= _rating ? const Color(0xFFFFB700) : Colors.black26,
                        size: 44.sp,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 32.h),
              if (_saved)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF008080).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, color: const Color(0xFF008080), size: 20.sp),
                      SizedBox(width: 8.w),
                      Text('Saved locally', style: GoogleFonts.outfit(
                        color: const Color(0xFF008080), fontSize: 13.sp, fontWeight: FontWeight.bold,
                      )),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
