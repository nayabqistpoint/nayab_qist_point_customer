import 'package:url_launcher/url_launcher.dart';

class CustomerContactLogic {
  Future<void> makePhoneCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '03012700351');
    await launchUrl(launchUri);
  }

  Future<void> openWhatsApp() async {
    final Uri whatsappUri = Uri.parse('https://wa.me/923012700351');
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }
}