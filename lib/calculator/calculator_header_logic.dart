import 'package:url_launcher/url_launcher.dart';
import 'package:nayab_qist_point_customer/calculator/calculator_list_logic.dart';

class CalculatorHeaderLogic {
  /// ایڈوانس کا ویلیڈیشن میسج دکھانا
  static String? getValidationMessage({
    required double totalAmount,
    required double advanceAmount,
    required bool hasSecurityCheck,
  }) {
    if (totalAmount <= 0) return null;

    double minAdvanceRequired = CalculatorListLogic.getMinimumRequiredAdvance(
      totalAmount: totalAmount,
      hasSecurityCheck: hasSecurityCheck,
    );

    if (advanceAmount > 0 && advanceAmount < minAdvanceRequired) {
      return "یا تو ایڈوانس صفر رکھیں یا کم از کم ${minAdvanceRequired.toStringAsFixed(0)} روپے رکھیں۔";
    }

    return null;
  }

  /// فون ڈائلر پر رابطہ نمبر کھولنا
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }
}