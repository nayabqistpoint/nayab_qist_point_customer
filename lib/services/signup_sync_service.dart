import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SignupRequestsService {
  Future<bool> processRegistration({
    required String cleanPhone,
    required Map<String, dynamic> customerData,
    required Map<String, dynamic> guarantorData,
    required bool isTermsAccepted,
  }) async {
    try {
      final String customerKey = cleanPhone;

      // 1️⃣ تینوں ہائیو باکسز حاصل کرنا
      final Box customerBox = Hive.isBoxOpen('customerBox')
          ? Hive.box('customerBox')
          : await Hive.openBox('customerBox');

      final Box guarantorBox = Hive.isBoxOpen('guarantorBox')
          ? Hive.box('guarantorBox')
          : await Hive.openBox('guarantorBox');

      final Box usersBox = Hive.isBoxOpen('usersBox')
          ? Hive.box('usersBox')
          : await Hive.openBox('usersBox');

      final String nowIso = DateTime.now().toIso8601String();

      // 2️⃣ 🎯 کسٹمر کا پے لوڈ
      final Map<String, dynamic> finalCustomerMap = {
        'customerId': cleanPhone,
        ...customerData,
        'status': 'Pending',
        'isSynced': false,
        'createdAt': nowIso,
      };

      // 3️⃣ 🎯 ضامن (Guarantor) کا پے لوڈ
      bool isGuarantorPresent = guarantorData['isGuarantorPresent'] ?? false;
      final Map<String, dynamic> finalGuarantorMap = {
        'customerId': cleanPhone,
        ...guarantorData,
        'status': 'Pending',
        'isSynced': false,
        'createdAt': nowIso,
      };

      // 4️⃣ 🎯 یوزرز (UsersBox) کا پے لوڈ (docId ہٹا کر customerId شامل کر دیا گیا ہے)
      String generatedPin = cleanPhone.length >= 4 
          ? cleanPhone.substring(cleanPhone.length - 4) 
          : cleanPhone;

      final Map<String, dynamic> finalUserMap = {
        'customerId': cleanPhone,       // 👈 docId کی جگہ یونیورسل customerId
        'phone': cleanPhone,            // 👈 لاگ ان / یوزر نیم
        'pin': generatedPin,
        'isAdmin': false,
        'status': 'Pending',
        'isSynced': false,
        'createdAt': nowIso,
      };

      // 🎯 STEP 1: کسٹمر باکس میں ڈیٹا سیو کرنا
      await customerBox.put(customerKey, finalCustomerMap);

      // 🎯 STEP 2: ضامن باکس میں ڈیٹا سیو کرنا (اگر موجود ہو)
      if (isGuarantorPresent) {
        await guarantorBox.put(customerKey, finalGuarantorMap);
        debugPrint('✅ ضامن کا ڈیٹا guarantorBox میں محفوظ ہو گیا۔');
      }

      // 🎯 STEP 3: یوزرز باکس میں پینڈنگ اتھینٹیکیشن ڈیٹا سیو کرنا
      await usersBox.put(customerKey, finalUserMap);
      debugPrint('✅ یوزر کا محفوظ لاگ ان ڈیٹا (Status: Pending) usersBox میں محفوظ ہو گیا۔');

      return true;
    } catch (e) {
      debugPrint('❌ [Signup Service Error] لوکل سیو میں ناکامی: $e');
      return false;
    }
  }
}