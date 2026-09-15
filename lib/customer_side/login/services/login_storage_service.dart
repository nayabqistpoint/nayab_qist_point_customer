import 'package:hive_flutter/hive_flutter.dart';

class LoginStorageService {
  Future<Map<String, String>?> loadSavedCredentials() async {
    final box = Hive.isBoxOpen('settingsBox')
        ? Hive.box('settingsBox')
        : await Hive.openBox('settingsBox');

    if (box.get('is_remember_me', defaultValue: false)) {
      final String? phone = box.get('remembered_phone');
      final String? pin = box.get('remembered_pin');
      if (phone != null && pin != null) {
        return {'phone': phone, 'pin': pin};
      }
    }
    return null;
  }

  Future<void> saveCredentials(String phone, String pin, bool rememberMe) async {
    final box = Hive.isBoxOpen('settingsBox')
        ? Hive.box('settingsBox')
        : await Hive.openBox('settingsBox');

    if (rememberMe) {
      await box.put('remembered_phone', phone);
      await box.put('remembered_pin', pin);
      await box.put('is_remember_me', true);
    } else {
      await box.deleteAll(['remembered_phone', 'remembered_pin']);
      await box.put('is_remember_me', false);
    }
    await box.put('last_logged_phone', phone);
  }

  Future<void> openTargetedCustomerBoxes() async {
    const targetedBoxes = [
      'mediaBox',
      'customerBox',
      'guarantorBox',
      'packageBox',
      'transactionBox',
    ];

    for (final boxName in targetedBoxes) {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox(boxName);
      }
    }
  }
}