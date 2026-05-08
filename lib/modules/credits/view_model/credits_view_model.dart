import 'package:get/get.dart';

class CreditsViewModel extends GetxController {
  final RxInt availableCredits = 1250.obs;

  final List<Map<String, dynamic>> topUpPlans = [
    {
      'title': 'Starter',
      'credits': '100',
      'price': '\$9.99',
      'features': ['10 Generations', 'Standard Quality'],
      'isPopular': false,
    },
    {
      'title': 'Creator',
      'credits': '600',
      'price': '\$49.99',
      'features': ['65 Generations', 'High-res Export'],
      'isPopular': true,
    },
    {
      'title': 'Studio',
      'credits': '1500',
      'price': '\$99.99',
      'features': ['Unlimited Drafts', '4K Rendering'],
      'isPopular': false,
    },
  ];

  void buyPlan(int index) {
    // Placeholder for payment logic
    Get.snackbar(
      'Payment',
      'Redirecting to payment gateway for ${topUpPlans[index]['title']} plan...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
