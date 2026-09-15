import 'package:flutter/material.dart';
import '../universal_payment_controller.dart';

class PaymentTargetCardUi extends StatelessWidget {
  final UniversalPaymentController controller;
  final VoidCallback onStateChange;

  const PaymentTargetCardUi({
    super.key,
    required this.controller,
    required this.onStateChange,
  });

  Widget _toggleBtn({required String label, required bool active, required VoidCallback onTap}) {
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
            boxShadow: active ? [BoxShadow(color: const Color(0xFF0D9488).withValues(alpha: 0.25), blurRadius: 6, offset: const Offset(0, 2))] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(active ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, size: 16, color: active ? Colors.white : const Color(0xFF94A3B8)),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: active ? Colors.white : const Color(0xFF475569))),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            boxShadow: [BoxShadow(color: const Color(0xFF064E3B).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
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
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                          child: const Icon(Icons.receipt_long_rounded, color: Color(0xFFFDE68A), size: 16),
                        ),
                        const SizedBox(width: 8),
                        const Text('کل مقررہ بل', style: TextStyle(fontSize: 12.5, color: Color(0xFFD1FAE5), fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.isInstallment ? 'کل اقساط: 10 ماہ پلان (${controller.title})' : 'نقد دستی ادھار کھاتہ واپسی',
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
            _toggleBtn(label: 'پوری ادائیگی', active: !controller.isPartial, onTap: () {
              controller.togglePartial(false);
              onStateChange();
            }),
            const SizedBox(width: 10),
            _toggleBtn(label: 'جزوی ادائیگی', active: controller.isPartial, onTap: () {
              controller.togglePartial(true);
              onStateChange();
            }),
          ],
        ),
        if (controller.isPartial) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('مطلوبہ ادائیگی کی رقم درج کریں:', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.targetAmountCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  onChanged: (val) {
                    controller.updateTargetAmount(val);
                    onStateChange();
                  },
                  decoration: InputDecoration(
                    prefixText: 'Rs. ',
                    prefixStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
                if (controller.shortAmount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'بقیہ Rs. ${controller.formatAmount(controller.shortAmount)} اگلے ماہ کے لیے واجب الادا رہیں گے۔',
                      style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
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