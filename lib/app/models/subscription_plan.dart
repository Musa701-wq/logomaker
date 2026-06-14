class SubscriptionPlan {
  final String id;
  final String productId;
  final String title;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;
  final int color;

  const SubscriptionPlan({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    required this.isPopular,
    required this.color,
  });
}
