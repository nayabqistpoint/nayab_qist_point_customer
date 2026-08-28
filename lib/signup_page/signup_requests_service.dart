import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

// 🎯 ایک ہی فولڈر (lib/customer/signup/) میں موجود ہونے کی وجہ سے Relative Import:
import 'outbox_sync_service.dart';

class SignupRequestsService {
  Future<bool> processRegistration({
    required String cleanPhone,
    required Map<String, dynamic> customerData,
    required Map<String, dynamic> guarantorData,
    required bool isTermsAccepted,
  }) async {
    try {
      final String docId = cleanPhone;
      final Box customerBox = Hive.box('customerBox');
      final Box guarantorBox = Hive.box('guarantorBox');
      final Box outboxBox = Hive.box('outboxBox');
      final String nowIso = DateTime.now().toIso8601String();

      // 1️⃣ کسٹمر اور ضامن کا پے لوڈ تیار کرنا
      final Map<String, dynamic> finalCustomerMap = {
        ...customerData,
        'customerPhone': cleanPhone,
        'status': 'pending',
        'createdAt': nowIso,
      };

      bool isGuarantorPresent = guarantorData['isGuarantorPresent'] ?? false;
      final Map<String, dynamic> finalGuarantorMap = {
        ...guarantorData,
        'status': 'pending',
        'createdAt': nowIso,
      };

      // 🎯 STEP 1: لوکل ہائیو کسٹمر اور ضامن باکسز میں سیو کرنا
      await customerBox.put(docId, finalCustomerMap);
      if (isGuarantorPresent) {
        await guarantorBox.put(docId, finalGuarantorMap);
      }
      debugPrint('✅ [STEP 1/2] کسٹمر اور ضامن کا ڈیٹا لوکل Hive باکسز میں محفوظ ہو گیا ہے۔');

      // 🎯 STEP 2: آؤٹ باکس پے لوڈ (فائر بیس کی ہدایات کے ساتھ)
      final Map<String, dynamic> outboxPayload = {
        'docId': docId,
        'operationType': 'signup', // 👈 یہ بتائے گا کہ پروسیس سائن اپ کا ہے
        'customerInfo': finalCustomerMap,
        'hasGuarantor': isGuarantorPresent,
        'guarantorInfo': isGuarantorPresent ? finalGuarantorMap : null,
      };

      await outboxBox.put(docId, outboxPayload);
      debugPrint('✅ [STEP 2/2] ڈیٹا فائر بیس کی ہدایات کے ساتھ outboxBox میں منتقل ہو گیا۔');

      // 🎯 آؤٹ باکس سنک سروس کو الرٹ کرنا
      OutboxSyncService().syncNow();

      return true;
    } catch (e) {
      debugPrint('❌ [Signup Service Error] لوکل سیو میں ناکامی: $e');
      return false;
    }
  }
}