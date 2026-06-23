import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RateUsView extends StatefulWidget {
  const RateUsView({super.key});

  @override
  State<RateUsView> createState() => _RateUsViewState();
}

class _RateUsViewState extends State<RateUsView> {
  int _rating = 0;
  bool _saved = false;
  bool _loading = false;
  final TextEditingController _feedbackCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  @override
  void dispose() {
    _feedbackCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadExisting() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('ratings')
          .doc(user.uid)
          .get();
      if (doc.exists && mounted) {
        setState(() {
          _rating = (doc.data()?['rating'] as num?)?.toInt() ?? 0;
          _feedbackCtrl.text =
              doc.data()?['feedback'] as String? ?? '';
          _saved = _rating > 0;
        });
      }
    } catch (_) {}
  }

  Future<void> _submit() async {
    if (_rating == 0) return;
    setState(() => _loading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('ratings')
          .doc(user?.uid ??
              'anon_${DateTime.now().millisecondsSinceEpoch}')
          .set({
        'rating': _rating,
        'feedback': _feedbackCtrl.text.trim(),
        'userId': user?.uid ?? 'anonymous',
        'userEmail': user?.email ?? '',
        'appVersion': '1.0.0',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (mounted) setState(() { _saved = true; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
      Get.snackbar('Error', 'Could not save. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  String get _label {
    switch (_rating) {
      case 1: return 'Poor';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Great';
      case 5: return 'Excellent';
      default: return 'Select a rating';
    }
  }

  Color get _labelColor {
    switch (_rating) {
      case 1: return Colors.red.shade400;
      case 2: return Colors.orange.shade400;
      case 3: return Colors.amber.shade600;
      case 4:
      case 5: return const Color(0xFF008080);
      default: return Colors.black26;
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Rate Us',
            style: GoogleFonts.outfit(
                color: Colors.black87,
                fontSize: 17.sp,
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Hero card ──
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 24.w, vertical: 32.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF8E1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.star_rounded,
                        color: const Color(0xFFFFB700), size: 34.sp),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    _saved
                        ? 'Thank you for your feedback'
                        : 'How would you rate Logo Maker?',
                    style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    _saved
                        ? 'Your feedback helps us improve the app.'
                        : 'Tap a star below to leave your rating.',
                    style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: Colors.black45,
                        height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 28.h),

                  // ── Stars row — fixed overflow ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (i) {
                      final star = i + 1;
                      return GestureDetector(
                        onTap: _saved
                            ? null
                            : () => setState(() => _rating = star),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 4.w),
                          child: Icon(
                            star <= _rating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: star <= _rating
                                ? const Color(0xFFFFB700)
                                : Colors.black26,
                            size: 40.sp,
                          ),
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: 10.h),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Text(
                      _label,
                      key: ValueKey(_rating),
                      style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: _labelColor),
                    ),
                  ),
                ],
              ),
            ),

            if (!_saved) ...[
              SizedBox(height: 16.h),

              // ── Feedback field ──
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: TextField(
                  controller: _feedbackCtrl,
                  maxLines: 4,
                  style: GoogleFonts.outfit(
                      fontSize: 13.sp, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts (optional)',
                    hintStyle: GoogleFonts.outfit(
                        color: Colors.black38, fontSize: 13.sp),
                    contentPadding: EdgeInsets.all(16.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // ── Submit ──
              SizedBox(
                height: 52.h,
                child: ElevatedButton(
                  onPressed:
                      _rating == 0 || _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008080),
                    disabledBackgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r)),
                    elevation: 0,
                  ),
                  child: _loading
                      ? SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: const CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Text('Submit Rating',
                          style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold)),
                ),
              ),
            ],

            // ── Success banner ──
            if (_saved) ...[
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF008080).withOpacity(0.07),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                      color: const Color(0xFF008080).withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        color: const Color(0xFF008080), size: 22.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'You rated us $_rating out of 5 stars.',
                        style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF008080)),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
