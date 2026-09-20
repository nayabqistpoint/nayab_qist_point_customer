import 'hive_box_manager.dart';
import '../inspector/inspector_store.dart';

class LoginHiveService {
  /// محفوظ اسناد چیک کر کے لاگ ان پروسیس کرنا
  static Future<Map<String, dynamic>> verifyAndExecuteLogin({
    required String phone,
    required String enteredPin,
    required Map<String, dynamic> sessionPayload,
  }) async {
    final usersBox = await HiveBoxManager.openSafeBox(HiveBoxManager.usersBoxName);
    final userCredentials = usersBox.get(phone);

    if (userCredentials == null) {
      return {'success': false, 'message': 'یہ موبائل نمبر رجسٹرڈ نہیں ہے'};
    }

    // ۱. پن کوڈ کی تصدیق
    final storedPin = (userCredentials['pin'] ?? userCredentials['pinCode'])?.toString().trim();
    final cleanEnteredPin = enteredPin.trim();

    if (storedPin != cleanEnteredPin) {
      return {'success': false, 'message': 'درج کردہ پن کوڈ غلط ہے'};
    }

    // ۲. اسٹیٹس کی سخت تصدیق (صرف approved صارفین کو اجازت ہے)
    final status = (userCredentials['status'] ?? '').toString().trim().toLowerCase();
    
    if (status != 'approved') {
      return {'success': false, 'message': 'آپ کا اکاؤنٹ ابھی ایڈمن کی منظوری کا منتظر ہے'};
    }

    // ۳. سیشن باکسز کھولنا
    await HiveBoxManager.openSessionBoxes();

    // ۴. سیٹنگز باکس میں سیشن کا ڈیٹا درج کرنا
    final settingsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
    for (final entry in sessionPayload.entries) {
      await settingsBox.put(entry.key, entry.value);
    }

    // ۵. انسپکٹر اسٹور میں لاگ بنانا
    InspectorStore.instance.logPayload(
      title: 'کسٹمر لاگ ان کامیاب ($phone)',
      direction: PayloadDirection.localHiveWrite,
      data: sessionPayload,
    );

    return {'success': true};
  }

  /// Remember Me کے تحت محفوظ شدہ ڈیٹا حاصل کرنا
  static Future<Map<String, String>?> getRememberedCredentials() async {
    final settingsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
    final isRemembered = settingsBox.get('is_remember_me', defaultValue: false) as bool;

    if (isRemembered) {
      final phone = settingsBox.get('remembered_phone', defaultValue: '') as String;
      final pin = settingsBox.get('remembered_pin', defaultValue: '') as String;
      if (phone.isNotEmpty && pin.isNotEmpty) {
        return {'phone': phone, 'pin': pin};
      }
    }
    return null;
  }

  /// باقاعدہ لاگ آؤٹ اور سیشن کلیئرنس
  static Future<void> executeLogout() async {
    final settingsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
    await settingsBox.put('isLoggedIn', false);

    final isRemembered = settingsBox.get('is_remember_me', defaultValue: false) as bool;
    if (!isRemembered) {
      await settingsBox.delete('activePhone');
      await settingsBox.delete('remembered_phone');
      await settingsBox.delete('remembered_pin');
    }

    // تمام پرائیویٹ سیشن باکسز بند کرنا
    await HiveBoxManager.closeSessionBoxes();

    InspectorStore.instance.logPayload(
      title: 'کسٹمر لاگ آؤٹ مکمل',
      direction: PayloadDirection.localHiveWrite,
      data: {'isLoggedIn': false},
    );
  }
}