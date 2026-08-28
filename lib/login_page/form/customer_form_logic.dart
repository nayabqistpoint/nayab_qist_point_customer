import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 🎯 shared ڈائریکٹری کے اندر فائل کا درست پاتھ:
import 'package:nayab_qist_point_customer/ledger/customer_ledger_page.dart';

class CustomerFormLogic {
  // 🎯 Lazy Getter: جب بٹن دبائیں گے صرف تب فائر بیس کال ہوگا
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

      // 🎯 فائر بیس کنیکشن کی لائیو چیکنگ
      final QuerySnapshot result = await _firestore
          .collection('customerbox')
          .where('phone', isEqualTo: phone)
          .where('pin', isEqualTo: password)
          .get();

      if (context.mounted) Navigator.pop(context);

      if (result.docs.isNotEmpty) {
        final userData = result.docs.first.data() as Map<String, dynamic>;
        bool isAdmin = userData['isAdmin'] ?? false;

        if (context.mounted) {
          _showSnackBar(context, 'لاگ ان کامیاب!');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerLedgerPage(isAdmin: isAdmin),
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
        _showSnackBar(context, 'فائر بیس کنیکشن ایرر: $e');
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