class LoginPayloadService {
  static Map<String, dynamic> buildLoginSessionPayload({
    required String phone,
    required bool rememberMe,
    String? pin,
  }) {
    return {
      'isLoggedIn': true,
      'activePhone': phone,
      'is_remember_me': rememberMe,
      'remembered_phone': rememberMe ? phone : '',
      'remembered_pin': rememberMe ? (pin ?? '') : '',
      'last_logged_phone': phone,
      'loginTimestamp': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> getBenchmarkPayload() {
    return {
      '1. Session & Preferences (settingsBox)': buildLoginSessionPayload(
        phone: '03231988351',
        rememberMe: true,
        pin: '1234',
      ),
    };
  }
}