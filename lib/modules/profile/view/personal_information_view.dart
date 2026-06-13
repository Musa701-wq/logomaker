import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_model/profile_view_model.dart';

class PersonalInformationView extends GetView<ProfileViewModel> {
  const PersonalInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F8),
      appBar: AppBar(
        title: Text(
          'Personal Information',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            // Profile Image from Google
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF008080), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF008080).withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60.r),
                      child: Image.asset(
                        'assets/images/logo1.jpg', // Placeholder, in real app would use user photo url
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFF7B2FBE),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.verified_user_rounded, color: Colors.white, size: 16.sp),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40.h),
            
            // Info Cards
            _buildInfoTile('Full Name', controller.userName.value, Icons.person_outline_rounded),
            _buildInfoTile('Email Address', controller.userEmail.value, Icons.email_outlined),
            _buildInfoTile('Account Status', 'Verified Google Account', Icons.verified_outlined),
            _buildInfoTile('Creative Tier', 'Professional Designer', Icons.auto_awesome_outlined),
            
            SizedBox(height: 40.h),
            
            Text(
              'Your personal data is synced with your Google account for a seamless experience across all Atelier Studio platforms.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF008080).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: const Color(0xFF008080), size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 12.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
