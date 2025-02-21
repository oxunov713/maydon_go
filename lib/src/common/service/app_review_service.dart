import 'package:in_app_review/in_app_review.dart';

class ReviewService {
  static final InAppReview _inAppReview = InAppReview.instance;

  /// 📢 Ilovani baholashni ochish
  static Future<void> requestReview() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    } else {}
  }
}
