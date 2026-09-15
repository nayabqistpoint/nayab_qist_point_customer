import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';
import 'login_storage_service.dart';

class LoginAuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LoginStorageService _storageService = LoginStorageService();

  Future<void> performLogin({
    required BuildContext context,
    required String phone,
    required String password,
    required bool rememberMe,
  }) async {
    final String cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanPhone.isEmpty || password.isEmpty) {
      showToast(context, 'براہ کرم صحیح موبائل نمبر اور پاسورڈ درج کریں', isError: true);
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final usersBox = Hive.box('usersBox');
      Map<String, dynamic>? userData;

      // 1. لوکل کیشے (100% آف لائن سپورٹ)
      if (usersBox.containsKey(cleanPhone)) {
        final localData = usersBox.get(cleanPhone);
        if (localData != null) {
          userData = Map<String, dynamic>.from(localData as Map);
        }
      }

      // 2. کلاؤڈ چیک (فائر اسٹور سے تصدیق)
      if (userData == null) {
        try {
          final docSnap = await _firestore
              .collection('usersBox')
              .doc(cleanPhone)
              .get()
              .timeout(const Duration(seconds: 4));

          if (docSnap.exists && docSnap.data() != null) {
            userData = Map<String, dynamic>.from(docSnap.data()!);
            await usersBox.put(cleanPhone, userData);
          }
        } catch (_) {
          // نیٹ ورک ٹائم آؤٹ
        }
      }

      if (!context.mounted) return;
      Navigator.pop(context); // لوڈر بند کریں

      // 3. کریڈینشلز اور اکاؤنٹ اسٹیٹس چیک
      if (userData != null && userData['pin'].toString() == password) {
        if ((userData['status'] ?? '').toString().trim().toLowerCase() == 'pending') {
          showToast(context, 'محترم صارف! آپ کی درخواست ابھی زیرِ التوا (Pending) ہے۔', isError: true);
          return;
        }

        // کریڈینشلز اور بنیادی لوکل باکسز محفوظ کریں
        await _storageService.saveCredentials(cleanPhone, password, rememberMe);
        await _storageService.openTargetedCustomerBoxes();

        if (context.mounted) {
          showToast(context, 'لاگ ان کامیاب!');
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.ledger,
            arguments: {'customerPhone': cleanPhone},
          );
        }
      } else {
        showToast(context, 'غلط موبائل نمبر یا پاسورڈ!', isError: true);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        showToast(context, 'لاگ ان میں مسئلہ: $e', isError: true);
      }
    }
  }

  void showToast(BuildContext context, String message, {bool isError = false}) {
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