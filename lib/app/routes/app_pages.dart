import 'package:get/get.dart';
import '../../modules/ai_generator/view/ai_result_view.dart';
import '../../modules/home/view/home_view.dart';
import '../../modules/home/view_model/home_view_model.dart';
import '../../modules/history/view_model/history_view_model.dart';
import '../../modules/profile/view_model/profile_view_model.dart';
import 'app_routes.dart';

import '../../modules/login/view/login_view.dart';
import '../../modules/login/view_model/login_view_model.dart';
import '../../modules/editor/view/editor_view.dart';
import '../../modules/editor/view_model/editor_view_model.dart';
import '../../modules/splash/view/splash_view.dart';
import '../../modules/splash/view_model/splash_view_model.dart';
import '../../modules/onboarding/view/onboarding_view.dart';
import '../../modules/onboarding/view_model/onboarding_view_model.dart';
import '../../modules/ai_generator/view/ai_generator_view.dart';
import '../../modules/ai_generator/view_model/ai_generator_view_model.dart';
import '../../modules/profile/view/about_view.dart';
import '../../modules/profile/view/personal_information_view.dart';
import '../../modules/profile/view/notifications_view.dart';
import '../../modules/history/view/history_detail_view.dart';
import '../../modules/templates/view/templates_view.dart';
import '../../modules/templates/view_model/templates_view_model.dart';
import '../../modules/welcome_banner/view/welcome_banner_view.dart';
import '../../modules/welcome_banner/view_model/welcome_banner_view_model.dart';
import '../../modules/how_to_use/view/how_to_use_view.dart';
import '../../modules/rate_us/view/rate_us_view.dart';
import '../../modules/support/view/customer_support_view.dart';

class AppPages {
  static const initial = AppRoutes.splash;
  static const notifications = '/notifications'; // Adding constant here or in AppRoutes

  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        Get.put(HistoryViewModel(), permanent: true);
        Get.lazyPut(() => HomeViewModel());
        Get.lazyPut(() => ProfileViewModel());
      }),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LoginViewModel());
      }),
    ),
    GetPage(
      name: AppRoutes.editor,
      page: () => const EditorView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => EditorViewModel());
      }),
    ),
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SplashViewModel());
      }),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => OnboardingViewModel());
      }),
    ),
    GetPage(
      name: AppRoutes.aiGenerator,
      page: () => const AIGeneratorView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AIGeneratorViewModel());
      }),
    ),
    GetPage(
      name: AppRoutes.aiResult,
      page: () => const AIResultView(),
      binding: BindingsBuilder(() {
        // Shared view model
        Get.lazyPut(() => AIGeneratorViewModel());
      }),
    ),
    GetPage(
      name: AppRoutes.about,
      page: () => const AboutView(),
    ),
    GetPage(
      name: '/notifications',
      page: () => const NotificationsView(),
    ),
    GetPage(
      name: '/personal-info',
      page: () => const PersonalInformationView(),
    ),
    GetPage(
      name: AppRoutes.historyDetail,
      page: () => const HistoryDetailView(),
    ),
    GetPage(
      name: AppRoutes.templates,
      page: () => const TemplatesView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => TemplatesViewModel());
      }),
    ),
    GetPage(
      name: AppRoutes.welcomeBanner,
      page: () => const WelcomeBannerView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => WelcomeBannerViewModel());
      }),
    ),
    GetPage(
      name: AppRoutes.howToUse,
      page: () => const HowToUseView(),
    ),
    GetPage(
      name: AppRoutes.rateUs,
      page: () => const RateUsView(),
    ),
    GetPage(
      name: AppRoutes.customerSupport,
      page: () => const CustomerSupportView(),
    ),
  ];
}
