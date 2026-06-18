import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/subscription_data.dart';
import '../models/subscription_plan.dart';

class PurchaseService extends GetxService {
  static PurchaseService get to => Get.find();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  final RxBool isAvailable = false.obs;
  final RxBool isSubscribed = false.obs;
  final RxString subscribedPlanId = ''.obs;
  final RxString expiryDate = ''.obs;
  final RxString activePlanTitle = ''.obs;
  final RxMap<String, ProductDetails> productDetails = <String, ProductDetails>{}.obs;
  final RxBool isLoadingProducts = false.obs;
  final RxBool isPurchasing = false.obs;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    isAvailable.value = await _inAppPurchase.isAvailable();

    if (isAvailable.value) {
      _subscription = _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdate,
        onError: (error) => debugPrint('Purchase stream error: $error'),
      );
      _loadProducts();
    } else {
      _loadFallbackProducts();
    }

    await _restoreSubscriptionStatus();
  }

  void _loadFallbackProducts() {
    isLoadingProducts.value = true;
    productDetails.clear();

    // Hardcoded fallback prices when Google Play is unavailable
    const fallbackPrices = {
      'com.xenderservices.logo.maker.weekly': '\$4.99',
      'com.xenderservices.logo.maker.monthly': '\$9.99',
      'com.xenderservices.logo.maker.yearly': '\$79.99',
    };

    for (final plan in SubscriptionData.to.plans) {
      final price = fallbackPrices[plan.id] ?? plan.price;
      debugPrint('📦 FALLBACK product: ${plan.id} -> $price');
      productDetails[plan.id] = ProductDetails(
        id: plan.id,
        title: '${plan.title} ($price)',
        description: plan.features.join(', '),
        price: price,
        rawPrice: double.tryParse(price.replaceAll(RegExp(r'[$,]'), '')) ?? 0,
        currencyCode: 'USD',
      );
    }

    // Sync fallback prices back into plan data
    SubscriptionData.to.mergeWithRealProducts();
    isLoadingProducts.value = false;
  }

  Future<void> _loadProducts() async {
    isLoadingProducts.value = true;
    try {
      final ids = SubscriptionData.to.plans.map((p) => p.productId).toSet();
      final response = await _inAppPurchase.queryProductDetails(ids);

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('❌ Products NOT found in Play Console: ${response.notFoundIDs}');
      }

      if (response.productDetails.isEmpty) {
        debugPrint('⚠️ No product details returned from Google Play');
        _loadFallbackProducts();
        return;
      }

      productDetails.clear();
      for (final detail in response.productDetails) {
        debugPrint('✅ REAL product loaded: ${detail.id} -> ${detail.price}');
        productDetails[detail.id] = detail;
      }

      // Merge real prices back into plan data
      SubscriptionData.to.mergeWithRealProducts();
    } catch (e) {
      debugPrint('❌ Error loading products: $e');
      _loadFallbackProducts();
    }
    isLoadingProducts.value = false;
  }

  ProductDetails? getProductDetails(String planId) {
    return productDetails[planId];
  }

  Future<void> purchasePlan(SubscriptionPlan plan) async {
    if (isPurchasing.value) return;
    isPurchasing.value = true;

    try {
      final details = productDetails[plan.productId];
      if (details != null && isAvailable.value) {
        final param = PurchaseParam(productDetails: details);
        await _inAppPurchase.buyNonConsumable(purchaseParam: param);
      } else {
        _simulatePurchase(plan);
      }
    } catch (e) {
      debugPrint('Purchase error: $e');
      isPurchasing.value = false;
    }
  }

  void _simulatePurchase(SubscriptionPlan plan) {
    final now = DateTime.now();
    final period = SubscriptionData.to.periodForPlan(plan.id);
    _activateSubscription(plan.id, now.add(period));
    isPurchasing.value = false;
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        _handlePurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        debugPrint('Purchase error: ${purchase.error}');
        isPurchasing.value = false;
      } else if (purchase.status == PurchaseStatus.canceled) {
        isPurchasing.value = false;
      }
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchase) async {
    try {
      if (purchase.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchase);
      }

      final plan = SubscriptionData.to.getByProductId(purchase.productID);
      if (plan != null) {
        final expiry = DateTime.now().add(SubscriptionData.to.periodForPlan(plan.id));
        await _activateSubscription(plan.id, expiry);
      }
    } catch (e) {
      debugPrint('Error completing purchase: $e');
    }
    isPurchasing.value = false;
  }

  Future<void> _activateSubscription(String planId, DateTime expiry) async {
    final plan = SubscriptionData.to.getById(planId);
    subscribedPlanId.value = planId;
    activePlanTitle.value = plan.title;
    expiryDate.value = '${expiry.month}/${expiry.day}/${expiry.year}';
    isSubscribed.value = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('subscription_plan_id', planId);
    await prefs.setString('subscription_expiry', expiry.toIso8601String());
  }

  Future<void> _restoreSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final planId = prefs.getString('subscription_plan_id');
    final expiryStr = prefs.getString('subscription_expiry');

    if (planId != null && expiryStr != null) {
      final expiry = DateTime.tryParse(expiryStr);
      if (expiry != null && expiry.isAfter(DateTime.now())) {
        final plan = SubscriptionData.to.getById(planId);
        subscribedPlanId.value = planId;
        activePlanTitle.value = plan.title;
        expiryDate.value = '${expiry.month}/${expiry.day}/${expiry.year}';
        isSubscribed.value = true;
      } else {
        await prefs.remove('subscription_plan_id');
        await prefs.remove('subscription_expiry');
      }
    }
  }

  Future<void> restorePurchases() async {
    if (isAvailable.value) {
      await _inAppPurchase.restorePurchases();
    } else {
      Get.snackbar('Restore', 'No purchases to restore', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
