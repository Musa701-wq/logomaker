import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/data/subscription_data.dart';
import '../../../app/models/subscription_plan.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/services/purchase_service.dart';

class WelcomeBannerViewModel extends GetxController {
  final PurchaseService _purchaseService = PurchaseService.to;

  var isAnimating = false.obs;
  var selectedPlanIndex = 1.obs;

  RxBool get isPurchasing => _purchaseService.isPurchasing;

  List<SubscriptionPlan> get plans => SubscriptionData.to.plans;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 300), () {
      isAnimating.value = true;
    });
  }

  Future<void> onGetStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcomeBanner', true);
    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> onSubscribe(int index) async {
    final plan = plans[index];
    await _purchaseService.purchasePlan(plan);
  }
}
