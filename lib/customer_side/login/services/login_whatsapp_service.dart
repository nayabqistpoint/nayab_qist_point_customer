import 'package:url_launcher/url_launcher.dart';

class LoginWhatsappService {
  static const String whatsappNumber = '923012700351';

  Future<void> openWhatsApp({String? customMessage}) async {
    final String msg = customMessage ?? 'السلام علیکم! نایاب قسط پوائنٹ کسٹمر ایپ سے رابطہ کر رہا ہوں۔';
    final Uri whatsappUri = Uri.parse('https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(msg)}');
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }
}