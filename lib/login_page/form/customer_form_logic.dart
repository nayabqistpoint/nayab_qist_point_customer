import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nayab_qist_point_customer/ledger/customer_ledger_page.dart';
import '../../services/master_pull_service.dart';

class CustomerFormLogic {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication _auth = LocalAuthentication();

  Future<void> handleLoginSubmission(
    BuildContext context,
    TextEditingController phoneController,
    TextEditingController passwordController, {
    bool rememberMe = false,
  }) async {
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      _showSnackBar(context, 'براہ کرم موبائل نمبر اور پاسورڈ درج کریں', isError: true);
      return;
    }

    try {
      showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

      final usersBox = Hive.isBoxOpen('usersBox') ? Hive.box('usersBox') : await Hive.openBox('usersBox');
      final settingsBox = Hive.isBoxOpen('settingsBox') ? Hive.box('settingsBox') : await Hive.openBox('settingsBox');
      Map<String, dynamic>? userData;

      try {
        final docSnap = await _firestore.collection('usersBox').doc(phone).get();
        if (docSnap.exists && docSnap.data() != null) {
          userData = Map<String, dynamic>.from(docSnap.data()!);
          userData['isSynced'] = true; // 👈 1. فائر اسٹور سے ڈیٹا آتے ہی isSynced: true سیٹ کر دیا
          await usersBox.put(phone, userData);
        }
      } catch (_) {}

      if (userData == null && usersBox.containsKey(phone)) {
        final localData = usersBox.get(phone);
        if (localData != null) {
          userData = Map<String, dynamic>.from(localData as Map);
          userData['isSynced'] = true; // 👈 2. اگر لوکل ڈیٹا بھی ملے تو isSynced: true یقینی بنائیں
        }
      }

      if (!context.mounted) return;
      Navigator.pop(context);

      if (userData != null && userData['pin'].toString() == password) {
        if ((userData['status'] ?? '').toString().trim().toLowerCase() == 'pending') {
          _showSnackBar(context, 'محترم صارف! آپ کی درخواست ابھی زیرِ التوا (Pending) ہے۔', isError: true);
          return;
        }

        if (rememberMe) {
          await settingsBox.put('remembered_phone', phone);
          await settingsBox.put('remembered_pin', password);
          await settingsBox.put('is_remember_me', true);
        } else {
          await settingsBox.deleteAll(['remembered_phone', 'remembered_pin']);
          await settingsBox.put('is_remember_me', false);
        }
        await settingsBox.put('last_logged_phone', phone);

        // 🎯 کسٹمر ڈیش بورڈ پر منتقل ہونے سے پہلے ماسٹر لائیو سنک کا آغاز
        await MasterLiveSyncService().onUserLoggedIn(phone);

        if (context.mounted) {
          _showSnackBar(context, 'لاگ ان کامیاب!');
          Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerLedgerPage(customerPhone: phone)));
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

  Future<Map<String, String>?> loadRememberedCredentials() async {
    final box = Hive.isBoxOpen('settingsBox') ? Hive.box('settingsBox') : await Hive.openBox('settingsBox');
    if (box.get('is_remember_me', defaultValue: false)) {
      String? phone = box.get('remembered_phone');
      String? pin = box.get('remembered_pin');
      if (phone != null && pin != null) return {'phone': phone, 'pin': pin};
    }
    return null;
  }

  Future<void> handleFingerprintAuthentication(BuildContext context) async {
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
        await handleLoginSubmission(context, TextEditingController(text: phone), TextEditingController(text: pin), rememberMe: true);
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
        content: Directionality(textDirection: TextDirection.rtl, child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))),
      ),
    );
  }
}