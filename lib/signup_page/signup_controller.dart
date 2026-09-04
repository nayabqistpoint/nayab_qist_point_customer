import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 🎯 کسٹمر ایپ کے اپنے درست امپورٹ پاتھس:
import 'package:nayab_qist_point_customer/signup_page/customer_info.dart';
import 'package:nayab_qist_point_customer/signup_page/guarantor_info.dart';
import 'package:nayab_qist_point_customer/services/signup_sync_service.dart';
import 'package:nayab_qist_point_customer/services/pending_media_service.dart'; // 👈 نیا پینڈنگ میڈیا سروس امپورٹ

class SignUpController extends ChangeNotifier {
  final GlobalKey<CustomerInfoWidgetState> customerKey = GlobalKey<CustomerInfoWidgetState>();
  final GlobalKey<GuarantorInfoWidgetState> guarantorKey = GlobalKey<GuarantorInfoWidgetState>();

  bool _isTermsAccepted = false;
  bool get isTermsAccepted => _isTermsAccepted;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void updateTerms(bool accepted) {
    _isTermsAccepted = accepted;
    notifyListeners();
  }

  Future<bool> submitRegistration(BuildContext context, GlobalKey<FormState> formKey) async {
    if (_isLoading) return false;

    if (!_isTermsAccepted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('براہ کرم پہلے شرائط کو پڑھ کر ٹک کریں')),
        );
      }
      return false;
    }

    if (formKey.currentState!.validate()) {
      final Map<String, dynamic> customerData = customerKey.currentState?.getCustomerData() ?? {};
      final Map<String, dynamic> guarantorData = guarantorKey.currentState?.getGuarantorData() ?? {};

      String rawPhone = customerData['customerPhone'] ?? '';
      if (rawPhone.trim().isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('براہ کرم کسٹمر کا موبائل نمبر درج کریں'), backgroundColor: Colors.red),
          );
        }
        return false;
      }

      String cleanPhone = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');

      _isLoading = true;
      notifyListeners();

      // 🎯 ۱. FirebaseAuth - Non-blocking (آزاد تھریڈ پر)
      String password = cleanPhone.length >= 4 ? cleanPhone.substring(cleanPhone.length - 4) : cleanPhone;
      String fakeEmail = '$cleanPhone@nayabqist.com';

      () async {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: fakeEmail,
            password: password,
          );
        } catch (e) {
          debugPrint('Non-blocking Auth Note (Offline/Error): $e');
        }
      }();

      // 🎯 ۲. لوکل باکسز میں ڈیٹا پروسیسنگ کے لیے سروس کو کال
      bool isSavedLocally = false;
      try {
        isSavedLocally = await SignupRequestsService().processRegistration(
          cleanPhone: cleanPhone,
          customerData: customerData,
          guarantorData: guarantorData,
          isTermsAccepted: _isTermsAccepted,
        );

        // 🎯 لوکل سیو کے بعد mediaBox کے Base64 کو کلاؤڈ نری لنک میں بدلنے کے لیے کال
        if (isSavedLocally) {
          PendingMediaService.processPendingMedia();
        }
      } catch (e) {
        debugPrint('❌ [Controller Error] Registration Process Failed: $e');
      }

      _isLoading = false;
      notifyListeners();

      // 🎯 ۳. پیغام دکھانا
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isSavedLocally 
                ? 'درخواست کامیابی سے محفوظ ہو گئی ہے!' 
                : 'درخواست محفوظ کرنے میں ناکامی ہوئی!',
            ),
            backgroundColor: isSavedLocally ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      return isSavedLocally;
    }
    return false;
  }
}