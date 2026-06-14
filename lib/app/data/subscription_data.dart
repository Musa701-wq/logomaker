import 'package:untitled1/app/models/subscription_plan.dart';

class SubscriptionData {
  static const List<SubscriptionPlan> plans = [
    SubscriptionPlan(
      id: 'weekly_subscription_id',
      productId: 'com.musaf.app.subscription.weekly',
      title: 'Weekly',
      price: '\$4.99',
      period: '/week',
      features: ['Unlimited logo generations', 'AI-powered design tools', 'HD quality exports', 'No ads'],
      isPopular: false,
      color: 0xFF00B4D8,
    ),
    SubscriptionPlan(
      id: 'monthly_subscription_id',
      productId: 'com.musaf.app.subscription.monthly',
      title: 'Monthly',
      price: '\$9.99',
      period: '/month',
      features: ['Everything in Weekly', 'Background removal', 'Priority support', 'Custom templates'],
      isPopular: true,
      color: 0xFF008080,
    ),
    SubscriptionPlan(
      id: 'yearly_subscription_id',
      productId: 'com.musaf.app.subscription.yearly',
      title: 'Yearly',
      price: '\$79.99',
      period: '/year',
      features: ['Everything in Monthly', '4K ultra HD export', 'Team collaboration', 'Early access features'],
      isPopular: false,
      color: 0xFF2D6A4F,
    ),
  ];

  static SubscriptionPlan getById(String id) {
    return plans.firstWhere((p) => p.id == id);
  }

  static SubscriptionPlan? getByProductId(String productId) {
    try {
      return plans.firstWhere((p) => p.productId == productId);
    } catch (_) {
      return null;
    }
  }
}
