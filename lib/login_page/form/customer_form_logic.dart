import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger_page.dart';
import '../../services/master_sync_manager.dart';

class CustomerFormLogic {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication _auth = LocalAuthentication();

  Future<void> handleLoginSubmission(
    BuildContext context,
    TextEditingController phoneController,
    TextEditingController passwordController, {
    bool rememberMe = false,
  }) async {
    String rawPhone = phoneController.text.trim();
    String password = passwordController.text.trim();

    // 🟢 فون نمبر کو بالکل صاف کریں (تمام سپیس یا ڈیش ہٹا دیں)
    String cleanPhone = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanPhone.isEmpty || password.isEmpty) {
      _showSnackBar(context, 'براہ کرم صحیح موبائل نمبر اور پاسورڈ درج کریں', isError: true);
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final usersBox = Hive.box('usersBox');
      final settingsBox = Hive.box('settingsBox');

      Map<String, dynamic>? userData;

      // 🟢 ۱۔ پہلی ترجیح (First Preference): لوکل usersBox سے ڈیٹا پڑھنا (100% آف لائن)
      if (usersBox.containsKey(cleanPhone)) {
        final localData = usersBox.get(cleanPhone);
        if (localData != null) {
          userData = Map<String, dynamic>.from(localData as Map);
        }
      }

      // 🟢 ۲۔ دوسری ترجیح (Second Preference): اگر لوکل پر نہ ملے (مثلاً پہلی بار انسٹال ہوئی ہو)، تو فائرسٹور دیکھیں
      if (userData == null) {
        try {
          final docSnap = await _firestore
              .collection('usersBox')
              .doc(cleanPhone)
              .get()
              .timeout(const Duration(seconds: 3));

          if (docSnap.exists && docSnap.data() != null) {
            userData = Map<String, dynamic>.from(docSnap.data()!);
            userData['isSynced'] = true;
            // لوکل usersBox میں محفوظ کریں تاکہ آئندہ آف لائن لاگ ان ہو سکے
            await usersBox.put(cleanPhone, userData);
          }
        } catch (_) {
          // نیٹ نہ ہونے یا ٹائم آؤٹ کی صورت میں خاموشی سے اگلی لائن پر منتقل ہو جائے گا
        }
      }

      if (!context.mounted) return;
      Navigator.pop(context); // ڈائیلاگ بند کریں

      // 🟢 ۳۔ پاسورڈ اور سٹیٹس کی تصدیق
      if (userData != null && userData['pin'].toString() == password) {
        // زیرِ التوا (Pending) کا چیک
        if ((userData['status'] ?? '').toString().trim().toLowerCase() == 'pending') {
          _showSnackBar(context, 'محترم صارف! آپ کی درخواست ابھی زیرِ التوا (Pending) ہے۔', isError: true);
          return;
        }

        // سیٹنگز اپڈیٹ کریں
        if (rememberMe) {
          await settingsBox.put('remembered_phone', cleanPhone);
          await settingsBox.put('remembered_pin', password);
          await settingsBox.put('is_remember_me', true);
        } else {
          await settingsBox.deleteAll(['remembered_phone', 'remembered_pin']);
          await settingsBox.put('is_remember_me', false);
        }
        await settingsBox.put('last_logged_phone', cleanPhone);

        // 🎯 ۴۔ لاگ ان کامیاب ہوتے ہی کسٹمر کے تمام ٹارگٹڈ باکسز اوپن کریں
        await _openTargetedCustomerBoxes();

        // 🎯 ۵۔ بیک گراؤنڈ سنک (فائر اسٹور سے سچ مچ کا سنک)
        Future.microtask(() {
          MasterSyncManager().startAutoSync(cleanPhone);
        });

        if (context.mounted) {
          _showSnackBar(context, 'لاگ ان کامیاب!');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CustomerLedgerPage(customerPhone: cleanPhone)),
          );
        }
      } else {
        _showSnackBar(context, 'غلط موبائل نمبر یا پاسورڈ!', isError: true);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        _showSnackBar(context, 'لاگ ان میں مسئلہ: $e', isError: true);
      }
    }
  }

  /// 🟢 صرف لاگ ان کے بعد ٹارگٹڈ کسٹمر باکسز اوپن کرنے کا میتھڈ
  Future<void> _openTargetedCustomerBoxes() async {
    List<String> targetedBoxes = [
      'mediaBox',
      'customerBox',
      'guarantorBox',
      'packageBox',
      'transactionBox',
    ];

    for (String boxName in targetedBoxes) {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox(boxName);
      }
    }
  }

  /// 🟢 سیو شدہ کریڈینشلز لوڈ کرنا
  Future<Map<String, String>?> loadRememberedCredentials() async {
    final box = Hive.isBoxOpen('settingsBox') ? Hive.box('settingsBox') : await Hive.openBox('settingsBox');
    if (box.get('is_remember_me', defaultValue: false)) {
      String? phone = box.get('remembered_phone');
      String? pin = box.get('remembered_pin');
      if (phone != null && pin != null) return {'phone': phone, 'pin': pin};
    }
    return null;
  }

  /// 🟢 کروم (Web) اور نان بائیومیٹرک پر سیف فنگر پرنٹ ہینڈلنگ
  Future<void> handleFingerprintAuthentication(BuildContext context) async {
    if (kIsWeb) {
      _showSnackBar(context, 'فنگر پرنٹ تصدیق صرف اینڈرائیڈ / موبائل پر دستیاب ہے!', isError: true);
      return;
    }

    try {
      if (!await _auth.canCheckBiometrics && !await _auth.isDeviceSupported()) {
        if (context.mounted) _showSnackBar(context, 'اس ڈیوائس پر فنگر پرنٹ سنسر دستیاب نہیں ہے!', isError: true);
        return;
      }

      final box = Hive.isBoxOpen('settingsBox') ? Hive.box('settingsBox') : await Hive.openBox('settingsBox');
      String? phone = box.get('remembered_phone') ?? box.get('last_logged_phone');
      String? pin = box.get('remembered_pin');

      if (phone == null || pin == null) {
        if (context.mounted) _showSnackBar(context, 'پہلے ایک بار پاسورڈ سے لاگ ان کریں!', isError: true);
        return;
      }

      if (await _auth.authenticate(localizedReason: 'لاگ ان کرنے کے لیے فنگر پرنٹ سکین کریں') && context.mounted) {
        await handleLoginSubmission(
          context,
          TextEditingController(text: phone),
          TextEditingController(text: pin),
          rememberMe: true,
        );
      }
    } catch (e) {
      if (context.mounted) _showSnackBar(context, 'فنگر پرنٹ تصدیق ناکام: $e', isError: true);
    }
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red[800] : Colors.green[800],
        behavior: SnackBarBehavior.floating,
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}