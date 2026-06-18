class SubscriptionPlan {
  final String id;
  final String productId;
  final String title;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;
  final int color;
  final int durationDays;

  const SubscriptionPlan({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    required this.isPopular,
    required this.color,
    this.durationDays = 0,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      productId: json['productId'] as String,
      title: json['title'] as String,
      price: json['price'] as String? ?? '\$0.00',
      period: json['period'] as String,
      features: (json['features'] as List).cast<String>(),
      isPopular: json['isPopular'] as bool,
      color: json['color'] as int,
      durationDays: json['durationDays'] as int? ?? 0,
    );
  }

  SubscriptionPlan copyWith({
    String? title,
    String? price,
  }) {
    return SubscriptionPlan(
      id: id,
      productId: productId,
      title: title ?? this.title,
      price: price ?? this.price,
      period: period,
      features: features,
      isPopular: isPopular,
      color: color,
      durationDays: durationDays,
    );
  }
}
