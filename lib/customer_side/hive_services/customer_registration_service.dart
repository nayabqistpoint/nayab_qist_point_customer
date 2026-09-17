import 'hive_box_manager.dart';
import '../inspector/inspector_store.dart';

class CustomerRegistrationService {
  static Future<bool> executeRegistration({
    required String phone,
    required Map<String, dynamic> customerPayload,
    required Map<String, dynamic> guarantorPayload,
    required Map<String, dynamic> mediaPayload,
    required Map<String, dynamic> usersPayload,
  }) async {
    try {
      // ۱. usersBox میں اسناد محفوظ کرنا
      final usersBox = await HiveBoxManager.openSafeBox(HiveBoxManager.usersBoxName);
      await usersBox.put(phone, usersPayload);

      // ۲. سیشن باکسز اوپن کرنا
      await HiveBoxManager.openSessionBoxes();

      // ۳. متعلقہ فکسڈ باکسز میں ڈیٹا ڈالنا
      final customerBox = await HiveBoxManager.openSafeBox(HiveBoxManager.customerBoxName);
      await customerBox.put(phone, customerPayload);

      final guarantorBox = await HiveBoxManager.openSafeBox(HiveBoxManager.guarantorBoxName);
      await guarantorBox.put(phone, guarantorPayload);

      final mediaBox = await HiveBoxManager.openSafeBox(HiveBoxManager.mediaBoxName);
      await mediaBox.put(phone, mediaPayload);

      // وقتی ٹیسٹنگ کے لیے settingsBox لاگ ان سٹیٹ (بعد میں پروڈکشن میں صرف لاگ ان سروس کرے گی)
      final settingsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
      await settingsBox.put('isLoggedIn', true);
      await settingsBox.put('activePhone', phone);

      // ۴. شفاف انسپکٹر لاگ
      InspectorStore.instance.logPayload(
        title: 'کسٹمر رجسٹریشن مکمل (Phone: $phone)',
        direction: PayloadDirection.localHiveWrite,
        data: {
          'usersBox': usersPayload,
          'customerBox': customerPayload,
          'guarantorBox': guarantorPayload,
          'mediaBox': mediaPayload,
          'settingsBox': {'isLoggedIn': true, 'activePhone': phone},
        },
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}