import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../app/data/subscription_data.dart';
import '../../../app/models/subscription_plan.dart';
import '../../../app/services/purchase_service.dart';

class CreditsViewModel extends GetxController {
  final PurchaseService _purchaseService = PurchaseService.to;

  RxBool get isSubscribed => _purchaseService.isSubscribed;
  RxString get activePlanTitle => _purchaseService.activePlanTitle;
  RxString get expiryDate => _purchaseService.expiryDate;
  RxString get subscribedPlanId => _purchaseService.subscribedPlanId;
  RxBool get isLoadingProducts => _purchaseService.isLoadingProducts;
  RxBool get isPurchasing => _purchaseService.isPurchasing;

  List<SubscriptionPlan> get plans => SubscriptionData.plans;

  ProductDetails? getProductDetails(SubscriptionPlan plan) {
    return _purchaseService.getProductDetails(plan.productId);
  }

  Future<void> subscribe(int index) async {
    final plan = plans[index];
    await _purchaseService.purchasePlan(plan);
  }

  Future<void> restorePurchases() async {
    await _purchaseService.restorePurchases();
  }
}
