import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/utils/color_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'modules/profile/view_model/profile_view_model.dart';
import 'app/services/purchase_service.dart';
import 'app/services/cache_service.dart';
import 'app/data/subscription_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase Initialized Successfully');
    // Sign in anonymously so Storage requests have a valid token
    try {
      await FirebaseAuth.instance.signInAnonymously();
      print('✅ Anonymous auth OK');
    } catch (e) {
      print('❌ Anonymous auth failed: $e');
      print('⚠️ Enable Anonymous sign-in in Firebase Console > Authentication > Sign-in method');
    }
    // Global Profile Controller
    Get.put(ProfileViewModel(), permanent: true);
    // Subscription Data must load BEFORE PurchaseService
    final subData = Get.put(SubscriptionData(), permanent: true);
    await subData.load();
    // Purchase Service (in-app purchases & subscriptions)
    Get.put(PurchaseService(), permanent: true);
    // Initialize image cache (SQLite)
    await CacheService.instance.init();
  } catch (e) {
    print('FIREBASE INITIALIZATION ERROR: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the design size (width and height of the design mockup)
    // Based on typical mobile screen dimensions
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 13/14 size as base
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'The Ethereal Studio',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.scaffoldBackground,
            ),
            scaffoldBackgroundColor: AppColors.scaffoldBackground,
          ),
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
