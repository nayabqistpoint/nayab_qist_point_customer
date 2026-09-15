import 'package:url_launcher/url_launcher.dart';

class LoginContactService {
  static const String supportNumber = '03012700351';

  Future<void> makePhoneCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: supportNumber);
    await launchUrl(launchUri);
  }
}