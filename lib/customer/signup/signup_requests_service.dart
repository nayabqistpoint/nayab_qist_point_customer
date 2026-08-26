import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupRequestsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔄 بیک گراؤنڈ سنک: آؤٹ باکس میں موجود پینڈنگ آف لائن ڈیٹا کو فائربیس پر اپلوڈ کر کے فلش کرنا
  Future<void> syncOutboxRequests() async {
    if (!Hive.isBoxOpen('outboxBox')) return;
    final Box outboxBox = Hive.box('outboxBox');

    if (outboxBox.isEmpty) return;

    debugPrint('🔄 Checking Hive Outbox for pending offline requests (${outboxBox.length} found)...');

    final List<dynamic> keys = outboxBox.keys.toList();
    for (var key in keys) {
      final data = outboxBox.get(key);
      if (data is Map) {
        final Map<String, dynamic> payload = Map<String, dynamic>.from(data);
        final String docId = key.toString();

        try {
          await _firestore
              .collection('signupRequests')
              .doc(docId)
              .set(payload)
              .timeout(const Duration(seconds: 3));

          debugPrint('☁️ STEP 2 (Background Sync): $docId successfully uploaded to Firestore!');

          await outboxBox.delete(key);
          debugPrint('🧹 STEP 3 (Background Sync): $docId flushed from Hive Outbox.');
        } catch (e) {
          debugPrint('⚠️ Background Sync failed for $docId: $e (Will retry when online)');
        }
      }
    }
  }

  /// 📩 سائن اپ درخواست کا مرکزی پروسیس
  Future<bool> sendSignupRequest({
    required String cleanPhone,
    required Map<String, dynamic> customerData,
    required Map<String, dynamic> guarantorData,
    required Map<String, dynamic> packageData,
    required bool isTermsAccepted,
  }) async {
    final String currentTimestamp = DateTime.now().toString();

    final Map<String, dynamic> signupRequestPayload = {
      'customerPhone': cleanPhone,
      'phone': cleanPhone,
      'status': 'Pending',
      'createdAt': currentTimestamp,
      'isPurchaseRequested': packageData['isPurchaseRequested'] == true,
      'customerData': {
        ...customerData,
        'customerPhone': cleanPhone,
        'isTermsAccepted': isTermsAccepted,
        'status': 'Pending',
        'timestamp': currentTimestamp,
      },
      'guarantorData': guarantorData['isGuarantorPresent'] == true
          ? {
              'customerPhone': cleanPhone,
              ...guarantorData,
              'timestamp': currentTimestamp,
            }
          : null,
      'packageData': packageData['isPurchaseRequested'] == true
          ? {
              'customerPhone': cleanPhone,
              ...packageData,
              'status': 'Pending',
              'timestamp': currentTimestamp,
            }
          : null,
    };

    // 🎯 STEP 1: آؤٹ باکس میں لازمی محفوظ کرنا (نیٹ آف پر بھی چلے گا)
    if (Hive.isBoxOpen('outboxBox')) {
      final Box outboxBox = Hive.box('outboxBox');
      await outboxBox.put(cleanPhone, signupRequestPayload);
      debugPrint('📦 STEP 1: Request safely stored in Hive Outbox.');
    }

    // 🎯 STEP 2: فائربیس اپلوڈ (۳ سیکنڈ کے ٹائم آؤٹ گارڈ کے ساتھ)
    try {
      await _firestore
          .collection('signupRequests')
          .doc(cleanPhone)
          .set(signupRequestPayload)
          .timeout(const Duration(seconds: 3)); // 👈 آف لائن ہونے پر کوڈ ۳ سیکنڈ میں خود آگے بڑھے گا

      debugPrint('☁️ STEP 2: Request successfully uploaded to Firestore!');

      // 🎯 STEP 3: آؤٹ باکس سے فلش کرنا
      if (Hive.isBoxOpen('outboxBox')) {
        await Hive.box('outboxBox').delete(cleanPhone);
        debugPrint('🧹 STEP 3: Request successfully flushed from Hive Outbox.');
      }

      return true;
    } catch (e) {
      // آف لائن موڈ یا ۳ سیکنڈ گزرنے کے بعد کنٹرول فوراً یہاں آئے گا اور پیج واپس جا سکے گا
      debugPrint('⚠️ STEP 2 TIMEOUT / OFFLINE: Data remains safe in Hive Outbox ($e)');
      return false;
    }
  }
}