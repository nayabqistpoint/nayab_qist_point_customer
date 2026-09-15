import 'package:flutter/material.dart';
import '../customer_signup_controller.dart';
import 'cnic_capture_card_ui.dart';

class GuarantorInfoCardUi extends StatelessWidget {
  final CustomerSignupController controller;

  const GuarantorInfoCardUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF34D399), width: 1.1),
          ),
          child: const Row(
            children: [
              Icon(Icons.shield_outlined, color: Color(0xFF059669), size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ضامن (گارنٹر) کی معلومات اختیاری ہیں۔ ضامن نہ ہونے کی صورت میں یہ حصہ خالی چھوڑ سکتے ہیں۔',
                  style: TextStyle(fontSize: 10.5, color: Color(0xFF065F46), height: 1.4, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'ضامن کی معلومات (اختیاری)',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 2),
        const Text(
          'دفتری ریکارڈ کی مضبوطی کیلئے درج کریں',
          style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 11),
        _buildField(controller.gNameCtrl, 'ضامن کا مکمل نام', 'ضامن کا نام لکھیں', TextInputType.text),
        const SizedBox(height: 11),
        Row(
          children: [
            Expanded(child: _buildField(controller.gFatherCtrl, 'ضامن کی ولدیت', 'والد کا نام', TextInputType.text)),
            const SizedBox(width: 10),
            Expanded(child: _buildField(controller.gRelationCtrl, 'کسٹمر سے رشتہ', 'بھائی، والد، دوست', TextInputType.text)),
          ],
        ),
        const SizedBox(height: 11),
        Row(
          children: [
            Expanded(child: _buildField(controller.gPhoneCtrl, 'ضامن موبائل نمبر', '0300xxxxxxx', TextInputType.phone)),
            const SizedBox(width: 10),
            Expanded(child: _buildField(controller.gCnicCtrl, 'ضامن شناختی کارڈ', '31202-xxxxxxx-x', TextInputType.number)),
          ],
        ),
        const SizedBox(height: 11),
        _buildField(controller.gAddressCtrl, 'ضامن کا رہائشی پتہ', 'ضامن کا مستقل پتہ', TextInputType.streetAddress),
        const SizedBox(height: 13),
        Row(
          children: [
            Expanded(
              child: CnicCaptureCardUi(
                label: 'ضامن CNIC فرنٹ',
                icon: Icons.credit_card_rounded,
                hint: 'سامنے کا فوٹو',
                isUploaded: controller.isGuarantorCnicFrontUploaded,
                onTap: () {
                  controller.isGuarantorCnicFrontUploaded = !controller.isGuarantorCnicFrontUploaded;
                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                  controller.notifyListeners();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CnicCaptureCardUi(
                label: 'ضامن CNIC بیک',
                icon: Icons.credit_card_outlined,
                hint: 'پیچھے کا فوٹو',
                isUploaded: controller.isGuarantorCnicBackUploaded,
                onTap: () {
                  controller.isGuarantorCnicBackUploaded = !controller.isGuarantorCnicBackUploaded;
                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                  controller.notifyListeners();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, String hint, TextInputType type) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.bold),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFF9FBF9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1.1)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: Color(0xFF059669), width: 1.4)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      ),
    );
  }
}