import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../app/routes/app_routes.dart';
import '../../profile/view_model/profile_view_model.dart';

class SplashViewModel extends GetxController {
  // All local asset paths that need to be precached for instant display
  static const List<String> _assetsToPrecache = [
    'assets/Logoss/Logoss/logos/Sports/sport_1.png',
    'assets/Logoss/Logoss/logos/Sports/sport_2.png',
    'assets/Logoss/Logoss/logos/Sports/sport_3.png',
    'assets/Logoss/Logoss/logos/Farmar/far1.png',
    'assets/Logoss/Logoss/logos/Farmar/far2.png',
    'assets/Logoss/Logoss/logos/Farmar/far3.png',
    'assets/Logoss/Logoss/logos/Functions/fn1.png',
    'assets/Logoss/Logoss/logos/Functions/fn2.png',
    'assets/Logoss/Logoss/logos/Functions/fn3.png',
    'assets/Logoss/abstract/lg1.png',
    'assets/Logoss/abstract/lg2.png',
    'assets/Logoss/abstract/lg3.png',
    'assets/Logoss/Logoss/logos/Animals/ani_1.png',
    'assets/Logoss/Logoss/logos/Animals/ani_2.png',
    'assets/Logoss/Logoss/logos/Animals/ani_3.png',
    'assets/Logoss/Logoss/logos/Butterfly/but_1.png',
    'assets/Logoss/Logoss/logos/Butterfly/but_2.png',
    'assets/Logoss/Logoss/logos/Butterfly/but_3.png',
    'assets/Logoss/Logoss/logos/Camera/cam_1.png',
    'assets/Logoss/Logoss/logos/Camera/cam_2.png',
    'assets/Logoss/Logoss/logos/Camera/cam_3.png',
    'assets/Logoss/Logoss/logos/Car/car_1.png',
    'assets/Logoss/Logoss/logos/Car/car_2.png',
    'assets/Logoss/Logoss/logos/Car/car_3.png',
    'assets/Logoss/Logoss/logos/Circle/cir_1.png',
    'assets/Logoss/Logoss/logos/Circle/cir_2.png',
    'assets/Logoss/Logoss/logos/Circle/cir_3.png',
    'assets/Logoss/Logoss/logos/Corporal/corp_3.png',
    'assets/Logoss/Logoss/logos/Corporal/corp_4.png',
    'assets/Logoss/Logoss/logos/Corporal/corp_5.png',
    'assets/Logoss/Logoss/logos/Dog/dog1.png',
    'assets/Logoss/Logoss/logos/Dog/dog2.png',
    'assets/Logoss/Logoss/logos/Dog/dog3.png',
    'assets/Logoss/Logoss/logos/Festival/fes_1.png',
    'assets/Logoss/Logoss/logos/Festival/fes_2.png',
    'assets/Logoss/Logoss/logos/Festival/fes_3.png',
    'assets/Logoss/Logoss/logos/Field/fl1.png',
    'assets/Logoss/Logoss/logos/Field/fl2.png',
    'assets/Logoss/Logoss/logos/Field/fl3.png',
    'assets/Logoss/Logoss/logos/Flowers/flow_1.png',
    'assets/Logoss/Logoss/logos/Flowers/flow_2.png',
    'assets/Logoss/Logoss/logos/Flowers/flow_3.png',
    'assets/Logoss/Logoss/logos/Fly/fly1.png',
    'assets/Logoss/Logoss/logos/Fly/fly2.png',
    'assets/Logoss/Logoss/logos/Fly/fly3.png',
    'assets/Logoss/Logoss/logos/Games/gm1.png',
    'assets/Logoss/Logoss/logos/Games/gm2.png',
    'assets/Logoss/Logoss/logos/Games/gm3.png',
    'assets/Logoss/Logoss/logos/Hallowean/hall_1.png',
    'assets/Logoss/Logoss/logos/Hallowean/hall_2.png',
    'assets/Logoss/Logoss/logos/Hallowean/hall_3.png',
    'assets/Logoss/Logoss/logos/Heart/hea_1.png',
    'assets/Logoss/Logoss/logos/Heart/hea_2.png',
    'assets/Logoss/Logoss/logos/Heart/hea_3.png',
    'assets/Logoss/Logoss/logos/Holiday/hol_1.png',
    'assets/Logoss/Logoss/logos/Holiday/hol_2.png',
    'assets/Logoss/Logoss/logos/Holiday/hol_3.png',
    'assets/Logoss/Logoss/logos/Leaf/lea_1.png',
    'assets/Logoss/Logoss/logos/Leaf/lea_2.png',
    'assets/Logoss/Logoss/logos/Leaf/lea_3.png',
    'assets/Logoss/Logoss/logos/Music/mus_1.png',
    'assets/Logoss/Logoss/logos/Music/mus_2.png',
    'assets/Logoss/Logoss/logos/Music/mus_3.png',
    'assets/Logoss/Logoss/logos/NGO/ngo_1.png',
    'assets/Logoss/Logoss/logos/NGO/ngo_2.png',
    'assets/Logoss/Logoss/logos/NGO/ngo_3.png',
    'assets/Logoss/Logoss/logos/Party/par_1.png',
    'assets/Logoss/Logoss/logos/Party/par_2.png',
    'assets/Logoss/Logoss/logos/Party/par_3.png',
    'assets/Logoss/Logoss/logos/Profession/pro_1.png',
    'assets/Logoss/Logoss/logos/Profession/pro_2.png',
    'assets/Logoss/Logoss/logos/Profession/pro_3.png',
    'assets/Logoss/Logoss/logos/Resturant/rest_1.png',
    'assets/Logoss/Logoss/logos/Resturant/rest_2.png',
    'assets/Logoss/Logoss/logos/Resturant/rest_3.png',
    'assets/Logoss/Logoss/logos/Simple/s1.png',
    'assets/Logoss/Logoss/logos/Simple/s2.png',
    'assets/Logoss/Logoss/logos/Simple/s3.png',
    'assets/Logoss/Logoss/logos/Social/soc_1.png',
    'assets/Logoss/Logoss/logos/Social/soc_2.png',
    'assets/Logoss/Logoss/logos/Social/soc_3.png',
    'assets/Logoss/Logoss/logos/Square/squ_1.png',
    'assets/Logoss/Logoss/logos/Square/squ_2.png',
    'assets/Logoss/Logoss/logos/Square/squ_3.png',
    'assets/Logoss/Logoss/logos/Star/star_1.png',
    'assets/Logoss/Logoss/logos/Star/star_2.png',
    'assets/Logoss/Logoss/logos/Star/star_3.png',
    'assets/Logoss/Logoss/logos/Text/text_1.png',
    'assets/Logoss/Logoss/logos/Text/text_2.png',
    'assets/Logoss/Logoss/logos/Text/text_3.png',
    'assets/Logoss/Logoss/logos/Tools/z1.png',
    'assets/Logoss/Logoss/logos/Tools/z2.png',
    'assets/Logoss/Logoss/logos/Tools/z3.png',
    'assets/Logoss/Logoss/logos/Toy/toy_1.png',
    'assets/Logoss/Logoss/logos/Toy/toy_2.png',
    'assets/Logoss/Logoss/logos/Toy/toy_3.png',
    'assets/Logoss/Logoss/logos/Video/vid_1.png',
    'assets/Logoss/Logoss/logos/Video/vid_2.png',
    'assets/Logoss/Logoss/logos/Video/vid_3.png',
  ];

  @override
  void onInit() {
    super.onInit();
    _startNavigation();
  }

  Future<void> _startNavigation() async {
    // Precache all local logo assets during splash (2.5s window)
    final context = Get.context;
    if (context != null) {
      await Future.wait(
        _assetsToPrecache.map(
          (path) => precacheImage(AssetImage(path), context).catchError((_) {}),
        ),
      );
    }

    await Future.delayed(const Duration(milliseconds: 2500));

    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;
    final hasSeenBanner = prefs.getBool('hasSeenWelcomeBanner') ?? false;

    if (user != null) {
      Get.offAllNamed(AppRoutes.home);
    } else if (isFirstTime) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else if (!hasSeenBanner) {
      Get.offAllNamed(AppRoutes.welcomeBanner);
    } else {
      Get.offAllNamed(AppRoutes.home);
    }
  }
}
