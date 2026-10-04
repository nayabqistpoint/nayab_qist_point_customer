// lib/customer_side/universal_payments/universal_payment_components_ui/payment_target_card_ui.dart

import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/universal_payments/universal_payment_controller.dart';

class PaymentTargetCardUi extends StatelessWidget {
  final UniversalPaymentController controller;

  const PaymentTargetCardUi({super.key, required this.controller});

  Widget _toggleTab({required String label, required bool active, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF0D9488) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: active ? const Color(0xFF0D9488) : const Color(0xFFCBD5E1), width: 1.2),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: const Color(0xFF0D9488).withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                active ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                size: 16,
                color: active ? Colors.white : const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: active ? Colors.white : const Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String subTitleText = controller.isInstallment
        ? '${controller.itemName ?? "موبائل فون"} • ${controller.planTitle ?? "اقساط پلان"}'
        : 'نقد دستی ادھار کھاتہ واپسی';

    final bool isOverCeiling = controller.isExceedingMaxLimit;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF064E3B), Color(0xFF022C22), Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF34D399).withValues(alpha: 0.3), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF064E3B).withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.receipt_long_rounded, color: Color(0xFFFDE68A), size: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.isInstallment ? 'مقررہ قسط کی رقم' : 'واجب الادا نقد قرض',
                          style: const TextStyle(fontSize: 12.5, color: Color(0xFFD1FAE5), fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subTitleText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text('Rs. ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFDE68A))),
                    Text(
                      controller.formatAmount(controller.baseAmount),
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFFFDE68A), letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _toggleTab(
              label: 'مقررہ قسط',
              active: !controller.isCustomAmountMode,
              onTap: () => controller.toggleCustomMode(false),
            ),
            const SizedBox(width: 10),
            _toggleTab(
              label: 'کسٹم / اضافی رقم',
              active: controller.isCustomAmountMode,
              onTap: () => controller.toggleCustomMode(true),
            ),
          ],
        ),
        if (controller.isCustomAmountMode) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isOverCeiling ? const Color(0xFFEF4444) : const Color(0xFFCBD5E1),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مطلوبہ وصولی کی کل رقم درج کریں (کم یا زیادہ):',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.targetAmountCtrl,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isOverCeiling ? const Color(0xFFDC2626) : const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: 'رقم درج کریں (مثلاً 8000)',
                    hintStyle: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                    prefixText: 'Rs. ',
                    prefixStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isOverCeiling ? const Color(0xFFDC2626) : const Color(0xFF0D9488),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: isOverCeiling ? const Color(0xFFEF4444) : const Color(0xFFCBD5E1)),
                    ),
                    filled: true,
                    fillColor: isOverCeiling ? const Color(0xFFFEF2F2) : const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: 8),
                if (isOverCeiling)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFECACA)),
                    ),
                    child: Text(
                      'غلطی: اس موبائل پلان کا کل واجب الادا بقایا صرف Rs. ${controller.formatAmount(controller.maxAllowedAmount ?? 0)} ہے۔ آپ اس سے زیادہ رقم درج نہیں کر سکتے۔',
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: const Text(
                      'وضاحت: اگر آپ قسط سے کم رقم درج کریں گے تو وہ جزوی ادائیگی شمار ہوگی، اور اگر زیادہ رقم جمع کروائیں گے تو بقیہ رقم خودکار طور پر اگلی اقساط کے کھاتے میں پیشگی جمع کر دی جائے گی۔',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF166534),
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}