import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/utils/color_constants.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D13),
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationItem(notification);
        },
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, String> data) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D25),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF008080).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              data['type'] == 'promo' ? Icons.local_offer_outlined : Icons.notifications_active_outlined,
              color: const Color(0xFF006666),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['title']!,
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      data['time']!,
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  data['message']!,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    color: Colors.white70,
                    height: 1.4,
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

final List<Map<String, String>> notifications = [
  {
    'title': 'New AI Model Released',
    'message': 'Our new v2.0 neural engine is now live. Experience 2x faster generations.',
    'time': '2h ago',
    'type': 'system',
  },
  {
    'title': 'Premium Offer!',
    'message': 'Get 50% off on your first year of pro membership. Valid for 48 hours.',
    'time': '5h ago',
    'type': 'promo',
  },
  {
    'title': 'Project Saved',
    'message': 'Your recent logo design "Neo Brand" has been successfully backed up to the cloud.',
    'time': 'Yesterday',
    'type': 'system',
  },
];
