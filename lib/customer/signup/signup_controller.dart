import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 🎯 کسٹمر ایپ کے اپنے درست امپورٹ پاتھس:
import 'package:nayab_qist_point_customer/customer/signup/customer_info.dart';
import 'package:nayab_qist_point_customer/customer/signup/guarantor_info.dart';
import 'package:nayab_qist_point_customer/customer/signup/item_package_ui.dart';
import 'package:nayab_qist_point_customer/customer/signup/signup_requests_service.dart';

class SignUpController extends ChangeNotifier {
  final GlobalKey<CustomerInfoWidgetState> customerKey = GlobalKey<CustomerInfoWidgetState>();
  final GlobalKey<GuarantorInfoWidgetState> guarantorKey = GlobalKey<GuarantorInfoWidgetState>();
  final GlobalKey<ItemPackageUIState> packageKey = GlobalKey<ItemPackageUIState>();

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
      final Map<String, dynamic> packageData = packageKey.currentState?.getPackageData() ?? {};

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

      // 🎯 ۱. FirebaseAuth - Non-blocking (بغیر await کے آزاد تھریڈ پر)
      String password = cleanPhone.length >= 4 ? cleanPhone.substring(cleanPhone.length - 4) : cleanPhone;
      String fakeEmail = '$cleanPhone@nayabqist.com';

      // اسے غیر بلاکنگ بنانے کا ٹائپ-سیف طریقہ
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

      // 🎯 ۲. آؤٹ باکس / فائربیس سروس کو فوری کال
      bool isSyncedOnline = false;
      try {
        isSyncedOnline = await SignupRequestsService().sendSignupRequest(
          cleanPhone: cleanPhone,
          customerData: customerData,
          guarantorData: guarantorData,
          packageData: packageData,
          isTermsAccepted: _isTermsAccepted,
        );
      } catch (e) {
        debugPrint('Service execution error: $e');
      }

      _isLoading = false;
      notifyListeners();

      // 🎯 ۳. پیغام دکھانا
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isSyncedOnline 
                ? 'درخواست کامیابی سے سبمٹ ہو گئی ہے!' 
                : 'درخواست آف لائن آؤٹ باکس میں محفوظ ہو گئی ہے!',
            ),
            backgroundColor: isSyncedOnline ? Colors.green : Colors.orange.shade800,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // 🎯 ۴. لازمی true ریٹرن کریں تاکہ SignupPage فوراً بند (Pop) ہو جائے
      return true;
    }
    return false;
  }
}