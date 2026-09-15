import 'package:flutter/material.dart';
import '../customer_signup_controller.dart';

class Step1CustomerInfoUi extends StatelessWidget {
  final CustomerSignupController controller;

  const Step1CustomerInfoUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'گاہک کے بنیادی کوائف',
          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 2),
        const Text(
          'شناختی کارڈ کے مطابق معلومات درج کریں تاکہ تصدیق میں آسانی ہو',
          style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 12),
        _buildField(
          controller: controller.nameCtrl,
          label: 'گاہک کا مکمل نام*',
          hint: 'شناختی کارڈ کے مطابق نام لکھیں',
          type: TextInputType.text,
        ),
        const SizedBox(height: 11),
        Row(
          children: [
            Expanded(
              child: _buildField(
                controller: controller.fatherCtrl,
                label: 'ولدیت / سرپرست*',
                hint: 'والد کا نام',
                type: TextInputType.text,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildField(
                controller: controller.casteCtrl,
                label: 'قوم / برادری*',
                hint: 'مثلاً آرائیں، جٹ',
                type: TextInputType.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        _buildField(
          controller: controller.cnicCtrl,
          label: 'شناختی کارڈ نمبر (CNIC)*',
          hint: '31202-xxxxxxx-x',
          type: TextInputType.number,
        ),
        const SizedBox(height: 11),
        _buildField(
          controller: controller.phoneCtrl,
          label: 'موبائل نمبر (یہی یوزر نیم ہوگا)*',
          hint: '03001234567',
          type: TextInputType.phone,
          helper: '💡 یاد رکھیں: نایاب قسط پورٹل میں مستقبل کے لاگ ان کیلئے یہ نمبر استعمال ہوگا',
        ),
        const SizedBox(height: 11),
        _buildField(
          controller: controller.addressCtrl,
          label: 'مکمل رہائشی پتہ مع ڈاکخانہ*',
          hint: 'محلہ، گلی اور گاؤں یا شہر',
          type: TextInputType.streetAddress,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType type,
    String? helper,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: type,
          maxLines: maxLines,
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
        ),
        if (helper != null) ...[
          const SizedBox(height: 3),
          Text(helper, style: const TextStyle(fontSize: 9.5, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
        ],
      ],
    );
  }
}