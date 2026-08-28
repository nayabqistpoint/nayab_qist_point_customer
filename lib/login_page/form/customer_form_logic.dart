import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

// 🎯 shared / ledger پاتھ
import 'package:nayab_qist_point_customer/ledger/customer_ledger_page.dart';

class CustomerFormLogic {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Future<void> handleLoginSubmission(
    BuildContext context,
    TextEditingController phoneController,
    TextEditingController passwordController,
  ) async {
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      _showSnackBar(context, 'براہ کرم موبائل نمبر اور پاسورڈ درج کریں');
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      bool isAuthenticated = false;

      // 1️⃣ پہلے لوکل ہائیو باکس (usersBox) میں فوری چیکنگ
      final usersBox = Hive.box('usersBox');
      final localUserData = usersBox.get(phone);

      if (localUserData != null) {
        final Map<String, dynamic> userMap = Map<String, dynamic>.from(localUserData as Map);
        if (userMap['pin'].toString() == password) {
          isAuthenticated = true;
        }
      }

      // 2️⃣ اگر لوکل ہائیو میں نہ ملے تو فائر اسٹور (usersBox) سے تصدیق
      if (!isAuthenticated) {
        final docSnap = await _firestore.collection('usersBox').doc(phone).get();

        if (docSnap.exists) {
          final userData = docSnap.data() as Map<String, dynamic>;
          if (userData['pin'].toString() == password) {
            isAuthenticated = true;
            // لوکل ہائیو میں بھی سیو کر لیں
            usersBox.put(phone, userData);
          }
        }
      }

      if (context.mounted) Navigator.pop(context); // ڈائیلاگ بند کریں

      if (isAuthenticated) {
        if (context.mounted) {
          _showSnackBar(context, 'لاگ ان کامیاب!');
          
          // 🎯 کسٹمر کا موبائل نمبر بطور پرائمری ID اگلی اسکرین کو پاس کر دیا گیا ہے
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerLedgerPage(
                customerPhone: phone, // 🎯 صرف فون نمبر پاس ہو رہا ہے
              ),
            ),
          );
        }
      } else {
        if (context.mounted) {
          _showSnackBar(context, 'غلط موبائل نمبر یا پاسورڈ!');
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        _showSnackBar(context, 'لاگ ان میں مسئلہ: $e');
      }
    }
  }

  void handleFingerprintAuthentication() {}

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}