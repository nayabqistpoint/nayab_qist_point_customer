import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OutboxSyncService {
  // سنگلٹن (Singleton) پیٹرن تاکہ پوری ایپ میں ایک ہی سروس چلے
  static final OutboxSyncService _instance = OutboxSyncService._internal();
  factory OutboxSyncService() => _instance;
  OutboxSyncService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isSyncing = false;

  // 🎯 جب بھی انٹرنیٹ آٹو کنیکٹ ہو، یہ سنک شروع کر دے گا
  void initializeNetworkListener() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi)) {
        debugPrint('🌐 [Network] انٹرنیٹ بحال ہو گیا ہے، آؤٹ باکس سنکنگ شروع کی جا رہی ہے...');
        syncNow();
      }
    });
  }

  // 🎯 سنک کرنے کا مین فنکشن
  Future<void> syncNow() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        debugPrint('⚠️ [Sync] انٹرنیٹ نہیں ہے۔ ڈیٹا آؤٹ باکس میں محفوظ رہے گا۔');
        _isSyncing = false;
        return;
      }

      final Box outboxBox = Hive.box('outboxBox');
      
      if (outboxBox.isEmpty) {
        debugPrint('✅ [Sync] آؤٹ باکس خالی ہے، اپلوڈ کے لیے کوئی نیا ڈیٹا نہیں ہے۔');
        _isSyncing = false;
        return;
      }

      debugPrint('🔄 [Sync] آؤٹ باکس میں ${outboxBox.length} آئیٹمز پائے گئے، اپلوڈ شروع...');

      // آؤٹ باکس کی تمام کیز (Keys) پر لوپ چلائیں
      for (var key in outboxBox.keys.toList()) {
        final Map<dynamic, dynamic> rawData = outboxBox.get(key);
        // Hive کے ڈائنامک میپ کو String میپ میں تبدیل کریں
        final Map<String, dynamic> payload = Map<String, dynamic>.from(rawData);
        final String docId = payload['docId'];
        final String operationType = payload['operationType'];

        bool success = false;

        // 🎯 سائن اپ آپریشن کی ہینڈلنگ
        if (operationType == 'signup') {
          success = await _uploadSignupData(docId, payload);
        }
        // آپ مستقبل میں یہاں purchase اور payment کے لیے else if لگا سکتے ہیں
        // else if (operationType == 'purchase') { ... }

        // 🎯 اگر اپلوڈ کامیاب رہا تو آؤٹ باکس سے فلش کر دیں
        if (success) {
          await outboxBox.delete(key);
          debugPrint('🗑️ [Sync Success] ڈیٹا فائر بیس پر اپلوڈ ہو گیا اور آؤٹ باکس سے فلش کر دیا گیا۔ (DocID: $docId)');
        }
      }
    } catch (e) {
      debugPrint('❌ [Sync Master Error] آؤٹ باکس سنک میں مسئلہ: $e');
    } finally {
      _isSyncing = false;
    }
  }

  // سائن اپ کا ڈیٹا فائر بیس پر بھیجنے کا کام
  Future<bool> _uploadSignupData(String docId, Map<String, dynamic> payload) async {
    try {
      final Map<String, dynamic> customerData = Map<String, dynamic>.from(payload['customerInfo']);
      
      // 1. کسٹمر کلیکشن میں رائٹ کریں
      await _firestore.collection('customerBox').doc(docId).set(customerData);

      // 2. ضامن کلیکشن میں رائٹ کریں (اگر ضامن ہے)
      if (payload['hasGuarantor'] == true && payload['guarantorInfo'] != null) {
        final Map<String, dynamic> guarantorData = Map<String, dynamic>.from(payload['guarantorInfo']);
        await _firestore.collection('guarantorBox').doc(docId).set(guarantorData);
      }
      
      return true; // کامیابی کا سگنل
    } catch (e) {
      debugPrint('❌ [Firebase Upload Error] فائر بیس میں اپلوڈ ناکام: $e');
      return false;
    }
  }
}