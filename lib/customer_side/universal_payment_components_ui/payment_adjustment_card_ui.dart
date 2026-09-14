import 'package:flutter/material.dart';
import '../universal_payment_controller.dart';

class PaymentAdjustmentCardUi extends StatelessWidget {
  final UniversalPaymentController controller;
  final VoidCallback onStateChange;

  const PaymentAdjustmentCardUi({
    super.key,
    required this.controller,
    required this.onStateChange,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIncome = controller.isIncome;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'ایڈجسٹمنٹ کیٹیگری (رعایت یا اضافی فیس):',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                isIncome ? 'بل میں جمع ہو گی (+)' : 'بل سے منفی ہو گی (-)',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isIncome ? const Color(0xFF2563EB) : const Color(0xFF059669)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: controller.selectedAdjIndex,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      items: List.generate(
                        controller.configAdjustmentCategories.length,
                        (i) => DropdownMenuItem(
                          value: i,
                          child: Text(controller.configAdjustmentCategories[i]['name'], overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      onChanged: (v) {
                        controller.selectedAdjIndex = v ?? 0;
                        onStateChange();
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: controller.adjAmountCtrl,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isIncome ? const Color(0xFF2563EB) : const Color(0xFF059669)),
                  onChanged: (_) => onStateChange(),
                  decoration: InputDecoration(
                    hintText: '0',
                    prefixText: isIncome ? '+ Rs. ' : '- Rs. ',
                    prefixStyle: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: isIncome ? const Color(0xFF2563EB) : const Color(0xFF059669)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}