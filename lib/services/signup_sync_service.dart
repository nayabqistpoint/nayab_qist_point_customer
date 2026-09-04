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

      // 1️⃣ تمام ضروری ہائیو باکسز حاصل کرنا
      final Box customerBox = Hive.isBoxOpen('customerBox')
          ? Hive.box('customerBox')
          : await Hive.openBox('customerBox');

      final Box guarantorBox = Hive.isBoxOpen('guarantorBox')
          ? Hive.box('guarantorBox')
          : await Hive.openBox('guarantorBox');

      final Box usersBox = Hive.isBoxOpen('usersBox')
          ? Hive.box('usersBox')
          : await Hive.openBox('usersBox');

      final Box mediaBox = Hive.isBoxOpen('mediaBox')
          ? Hive.box('mediaBox')
          : await Hive.openBox('mediaBox');

      final String nowIso = DateTime.now().toIso8601String();

      // 2️⃣ 🎯 کسٹمر کا پے لوڈ (صرف ڈپلیکیٹ customerPhone، customerSelfie اور docId ہٹا کر)
      Map<String, dynamic> cleanedCustomerData = Map<String, dynamic>.from(customerData);
      String? customerSelfieData = cleanedCustomerData.remove('customerSelfie');
      cleanedCustomerData.remove('customerPhone'); // 👈 صرف کسٹمر کا ڈپلیکیٹ نمبر ختم
      cleanedCustomerData.remove('docId');

      final Map<String, dynamic> finalCustomerMap = {
        'customerId': cleanPhone, // 👈 کسٹمر کی مین آئی ڈی
        ...cleanedCustomerData,
        'status': 'pending',
        'isSynced': false,
        'createdAt': nowIso,
      };

      // 3️⃣ 🎯 ضامن (Guarantor) کا پے لوڈ (guarantorPhone بحال ہے)
      bool isGuarantorPresent = guarantorData['isGuarantorPresent'] ?? false;
      Map<String, dynamic> cleanedGuarantorData = Map<String, dynamic>.from(guarantorData);
      String? guarantorSelfieData = cleanedGuarantorData.remove('guarantorSelfie');
      cleanedGuarantorData.remove('docId');

      final Map<String, dynamic> finalGuarantorMap = {
        'customerId': cleanPhone, // 👈 کسٹمر کا فون نمبر بطور حوالہ
        ...cleanedGuarantorData,  // 👈 اس کے اندر guarantorPhone موجود رہے گا
        'status': 'pending',
        'isSynced': false,
        'createdAt': nowIso,
      };

      // 4️⃣ 🎯 یوزرز (UsersBox) کا پے لوڈ
      String generatedPin = cleanPhone.length >= 4 
          ? cleanPhone.substring(cleanPhone.length - 4) 
          : cleanPhone;

      final Map<String, dynamic> finalUserMap = {
        'customerId': cleanPhone,
        'pin': generatedPin,
        'isAdmin': false,
        'status': 'pending',
        'isSynced': false,
        'createdAt': nowIso,
      };

      // 🎯 STEP 1: کسٹمر باکس میں سیو کرنا
      await customerBox.put(customerKey, finalCustomerMap);

      // 🎯 STEP 2: ضامن باکس میں سیو کرنا (اگر موجود ہو)
      if (isGuarantorPresent) {
        await guarantorBox.put(customerKey, finalGuarantorMap);
        debugPrint('✅ ضامن کا ڈیٹا guarantorBox میں محفوظ ہو گیا۔');
      }

      // 🎯 STEP 3: یوزرز باکس میں سیو کرنا
      await usersBox.put(customerKey, finalUserMap);

      // 🎯 STEP 4: کسٹمر سیلفی کا mediaBox پے لوڈ (Key = mobile_customer)
      if (customerSelfieData != null && customerSelfieData.isNotEmpty) {
        String customerMediaDocKey = "${cleanPhone}_customer";

        final Map<String, dynamic> customerMediaMap = {
          'customerId': cleanPhone,
          'sourcePage': 'signup',
          'category': 'customer_selfie',
          'mediaData': customerSelfieData,
          'mediaStatus': 'PENDING_UPLOAD',
          'isSynced': true,
          'createdAt': nowIso,
        };

        await mediaBox.put(customerMediaDocKey, customerMediaMap);
        debugPrint('📸 کسٹمر سیلفی mediaBox میں محفوظ ہو گئی ($customerMediaDocKey)');
      }

      // 🎯 STEP 5: گرینٹر سیلفی کا mediaBox پے لوڈ (Key = mobile_guarantor)
      if (isGuarantorPresent && guarantorSelfieData != null && guarantorSelfieData.isNotEmpty) {
        String guarantorMediaDocKey = "${cleanPhone}_guarantor";

        final Map<String, dynamic> guarantorMediaMap = {
          'customerId': cleanPhone,
          'sourcePage': 'signup',
          'category': 'guarantor_selfie',
          'mediaData': guarantorSelfieData,
          'mediaStatus': 'PENDING_UPLOAD',
          'isSynced': true,
          'createdAt': nowIso,
        };

        await mediaBox.put(guarantorMediaDocKey, guarantorMediaMap);
        debugPrint('📸 گرینٹر سیلفی mediaBox میں محفوظ ہو گئی ($guarantorMediaDocKey)');
      }

      return true;
    } catch (e) {
      debugPrint('❌ [Signup Service Error] لوکل سیو میں ناکامی: $e');
      return false;
    }
  }
}