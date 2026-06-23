import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerSupportView extends StatelessWidget {
  const CustomerSupportView({super.key});

  static const String _supportEmail = 'contentcreation197@gmail.com';
  static const String _supportEmail2 = 'xendersservices@gmail.com';

  Future<void> _openEmail(String email, String subject) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': 'App: Logo Maker\n\nDescribe your issue:\n',
      },
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not open email app',
          snackPosition: SnackPosition.BOTTOM);
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
          icon: Icon(Icons.arrow_back_rounded, color: Colors.black87, size: 24.sp),
          onPressed: () => Get.back(),
        ),
        title: Text('Customer Support',
            style: GoogleFonts.outfit(
                color: Colors.black87,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(28.w),
              decoration: BoxDecoration(
                color: const Color(0xFF008080),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.support_agent_rounded,
                        color: Colors.white, size: 36.sp),
                  ),
                  SizedBox(height: 16.h),
                  Text('We\'re here to help',
                      style: GoogleFonts.outfit(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 8.h),
                  Text(
                    'Our team typically responds within 24 hours.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: Colors.white70,
                        height: 1.5),
                  ),
                ],
              ),
            ),

            SizedBox(height: 28.h),

            Text('GET IN TOUCH',
                style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                    letterSpacing: 1.5)),
            SizedBox(height: 12.h),

            // ── Email cards ──
            _contactCard(
              icon: Icons.email_outlined,
              title: 'Primary Support',
              subtitle: _supportEmail,
              buttonLabel: 'Email',
              onTap: () => _openEmail(_supportEmail, 'Support Request — Logo Maker'),
            ),
            SizedBox(height: 10.h),
            _contactCard(
              icon: Icons.alternate_email_rounded,
              title: 'Business Inquiries',
              subtitle: _supportEmail2,
              buttonLabel: 'Email',
              onTap: () => _openEmail(_supportEmail2, 'Business Inquiry — Logo Maker'),
            ),

            SizedBox(height: 28.h),

            Text('COMMON TOPICS',
                style: GoogleFonts.outfit(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                    letterSpacing: 1.5)),
            SizedBox(height: 12.h),

            _topicTile(
              icon: Icons.payment_rounded,
              title: 'Billing & Subscription',
              subtitle: 'Issues with payments, refunds, or plan changes',
              onTap: () => _openEmail(_supportEmail, 'Billing Issue — Logo Maker'),
            ),
            _topicTile(
              icon: Icons.bug_report_outlined,
              title: 'Report a Bug',
              subtitle: 'App crash, glitch, or unexpected behavior',
              onTap: () => _openEmail(_supportEmail, 'Bug Report — Logo Maker'),
            ),
            _topicTile(
              icon: Icons.lock_outline_rounded,
              title: 'Account Access',
              subtitle: 'Login problems or account recovery',
              onTap: () => _openEmail(_supportEmail, 'Account Issue — Logo Maker'),
            ),
            _topicTile(
              icon: Icons.help_outline_rounded,
              title: 'General Inquiry',
              subtitle: 'Any other questions or feedback',
              onTap: () => _openEmail(_supportEmail, 'General Inquiry — Logo Maker'),
            ),

            SizedBox(height: 32.h),

            // ── Response time note ──
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF008080).withOpacity(0.06),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                    color: const Color(0xFF008080).withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time_rounded,
                      color: const Color(0xFF008080), size: 20.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Average response time: under 24 hours on business days.',
                      style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          color: Colors.black54,
                          height: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _contactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonLabel,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFF008080).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: const Color(0xFF008080), size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                SizedBox(height: 2.h),
                Text(subtitle,
                    style: GoogleFonts.outfit(
                        fontSize: 11.sp, color: Colors.black45)),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFF008080),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(buttonLabel,
                  style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topicTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xFF008080).withOpacity(0.06),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child:
                  Icon(icon, color: const Color(0xFF008080), size: 18.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  SizedBox(height: 2.h),
                  Text(subtitle,
                      style: GoogleFonts.outfit(
                          fontSize: 11.sp, color: Colors.black45)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.black26, size: 14.sp),
          ],
        ),
      ),
    );
  }
}
