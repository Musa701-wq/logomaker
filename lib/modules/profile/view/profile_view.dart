import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/color_constants.dart';
import '../view_model/profile_view_model.dart';
import '../../home/view_model/home_view_model.dart';

class ProfileView extends GetView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light background
      body: SafeArea(
        child: Obx(() => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Row(
                  children: [
                    const Spacer(),
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [const Color(0xFF008080), const Color(0xFF008080)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'The Ethereal Studio',
                        style: GoogleFonts.outfit(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: const Color(0xFF008080).withOpacity(0.1),
                      backgroundImage: const AssetImage('assets/images/logo.png'),
                    ),
                  ],
                ),
              ),
            ),

            // Profile Header Card (gradient banner style)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF008080),
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF008080).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.r),
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: 100.w,
                                height: 100.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (!controller.isGuest.value)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                'PRO',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF008080),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      if (controller.isGuest.value) ...[
                        Text(
                          'Welcome to Atelier',
                          style: GoogleFonts.outfit(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Sign in to sync your designs across devices',
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.login),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'SIGN IN / REGISTER',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF008080),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        Text(
                          controller.userName.value,
                          style: GoogleFonts.outfit(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          controller.userEmail.value,
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.white.withOpacity(0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 16.sp),
                              SizedBox(width: 8.w),
                              Text(
                                'PREMIUM MEMBER',
                                style: GoogleFonts.outfit(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            if (!controller.isGuest.value) ...[
              // Subscription Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 4))],
                    ),
                    child: InkWell(
                      onTap: () => Get.find<HomeViewModel>().selectedIndex.value = 2,
                      borderRadius: BorderRadius.circular(25.r),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF008080).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(Icons.subscriptions_rounded, color: const Color(0xFF008080), size: 20.sp),
                              ),
                              SizedBox(width: 16.w),
                              Text('Subscription Plan', style: GoogleFonts.outfit(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Colors.black87)),
                              const Spacer(),
                              Text('MANAGE', style: GoogleFonts.outfit(fontSize: 12.sp, fontWeight: FontWeight.bold, color: const Color(0xFF008080))),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Monthly Premium', style: GoogleFonts.outfit(fontSize: 13.sp, color: Colors.black54)),
                                    Text('\$24.99/mo', style: GoogleFonts.outfit(fontSize: 15.sp, fontWeight: FontWeight.bold, color: const Color(0xFF008080))),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: LinearProgressIndicator(
                                    value: 0.75,
                                    minHeight: 6.h,
                                    backgroundColor: Colors.grey.withOpacity(0.15),
                                    valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF008080)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Account Settings
              _buildSectionTitle('ACCOUNT SETTINGS'),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      children: [
                        _buildSettingsRow(Icons.person_outline_rounded, 'Personal Information', 'Manage name and contact details', onTap: () => Get.toNamed('/personal-info')),
                        _buildDivider(),
                        _buildSettingsRow(Icons.info_outline_rounded, 'About Us', 'Learn more about Atelier Studio', onTap: () => Get.toNamed(AppRoutes.about)),
                        _buildDivider(),
                        _buildSettingsRow(Icons.payment_rounded, 'Payment Methods', 'Manage your cards and billing', onTap: () {}),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            // Legal & About
            _buildSectionTitle('LEGAL & ABOUT'),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    children: [
                      _buildSettingsRow(
                        Icons.privacy_tip_outlined,
                        'Privacy Policy',
                        'How we handle and protect your data',
                        onTap: () async {
                          final url = Uri.parse('https://logomaker-6d294.web.app/privacy.html');
                          if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsRow(
                        Icons.description_outlined,
                        'Terms and Conditions',
                        'Our service agreements',
                        onTap: () async {
                          final url = Uri.parse('https://logomaker-6d294.web.app/terms.html');
                          if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (!controller.isGuest.value)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => controller.logout(),
                        child: Container(
                          width: double.infinity,
                          height: 54.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: Colors.grey.withOpacity(0.2)),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          alignment: Alignment.center,
                          child: Text('SIGN OUT', style: GoogleFonts.outfit(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black54)),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: () => _showDeleteDialog(),
                        child: Text('DELETE ACCOUNT', style: GoogleFonts.outfit(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.red[400], letterSpacing: 1)),
                      ),
                    ],
                  ),
                ),
              ),

            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        )),
      ),
    );
  }

  void _showDeleteDialog() {
    Get.defaultDialog(
      title: 'Delete Account?',
      middleText: 'This action is permanent and cannot be undone.',
      backgroundColor: Colors.white,
      titleStyle: GoogleFonts.outfit(color: Colors.black87, fontWeight: FontWeight.bold),
      middleTextStyle: GoogleFonts.outfit(color: Colors.black54),
      textConfirm: 'DELETE',
      textCancel: 'CANCEL',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red[400],
      cancelTextColor: Colors.black54,
      onConfirm: () => controller.deleteAccount(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(25.w, 28.h, 25.w, 10.h),
        child: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black38,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() => Divider(height: 1, indent: 54.w, color: Colors.grey.withOpacity(0.12));

  Widget _buildSettingsRow(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(15.r),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: const Color(0xFF008080).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: const Color(0xFF008080), size: 20.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.outfit(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.black87)),
                  SizedBox(height: 2.h),
                  Text(subtitle, style: GoogleFonts.outfit(fontSize: 11.sp, color: Colors.black38)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.black26, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
