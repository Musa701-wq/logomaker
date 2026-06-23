import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/subscription_plan.dart';
import '../services/purchase_service.dart';

class SubscriptionData extends GetxService {
  static SubscriptionData get to => Get.find();

  final RxList<SubscriptionPlan> plans = <SubscriptionPlan>[].obs;
  final RxBool isLoaded = false.obs;

  Future<void> load() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/config/plans.json');
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final list = data['plans'] as List;
      plans.value = list.map((p) => SubscriptionPlan.fromJson(p)).toList();
      mergeWithRealProducts();
      isLoaded.value = true;
    } catch (e) {
      plans.value = _fallbackPlans();
      isLoaded.value = true;
    }
  }

  void mergeWithRealProducts() {
    try {
      final ps = PurchaseService.to;
      if (ps.productDetails.isNotEmpty) {
        for (int i = 0; i < plans.length; i++) {
          final detail = ps.productDetails[plans[i].productId];
          if (detail != null) {
            debugPrint('💲 Merged price for ${plans[i].id}: ${detail.price}');
            plans[i] = plans[i].copyWith(
              title: detail.title,
              price: detail.price,
            );
          }
        }
      }
    } catch (_) {
      // PurchaseService not yet registered — will merge later when it initializes
    }
  }

  List<SubscriptionPlan> _fallbackPlans() => [
    SubscriptionPlan(
      id: 'com.xenderservices.logo.maker.weekly',
      productId: 'com.xenderservices.logo.maker.weekly',
      title: 'Weekly',
      price: '\$4.99',
      period: '/week',
      features: ['Unlimited logo generations', 'AI-powered design tools', 'HD quality exports', 'No ads'],
      isPopular: false,
      color: 0xFF00B4D8,
    ),
    SubscriptionPlan(
      id: 'com.xenderservices.logo.maker.monthly',
      productId: 'com.xenderservices.logo.maker.monthly',
      title: 'Monthly',
      price: '\$9.99',
      period: '/month',
      features: ['Everything in Weekly', 'Background removal', 'Priority support', 'Custom templates'],
      isPopular: false,
      color: 0xFF008080,
    ),
    SubscriptionPlan(
      id: 'com.xenderservices.logo.maker.yearly',
      productId: 'com.xenderservices.logo.maker.yearly',
      title: 'Yearly',
      price: '\$79.99',
      period: '/year',
      features: ['Everything in Monthly', '4K ultra HD export', 'Team collaboration', 'Early access features'],
      isPopular: false,
      color: 0xFF2D6A4F,
    ),
  ];

  SubscriptionPlan getById(String id) => plans.firstWhere((p) => p.id == id);

  SubscriptionPlan? getByProductId(String productId) {
    try {
      return plans.firstWhere((p) => p.productId == productId);
    } catch (_) {
      return null;
    }
  }

  Duration periodForPlan(String planId) {
    try {
      final plan = getById(planId);
      if (plan.durationDays > 0) return Duration(days: plan.durationDays);
    } catch (_) {}
    return const Duration(days: 30);
  }
}
