// lib/customer_side/universal_payments/universal_payment_components_ui/payment_adjustment_card_ui.dart

import 'package:flutter/material.dart';
import '../universal_payment_controller.dart';

class PaymentAdjustmentCardUi extends StatefulWidget {
  final UniversalPaymentController controller;

  const PaymentAdjustmentCardUi({super.key, required this.controller});

  @override
  State<PaymentAdjustmentCardUi> createState() => _PaymentAdjustmentCardUiState();
}

class _PaymentAdjustmentCardUiState extends State<PaymentAdjustmentCardUi> {
  bool isClaimExpanded = false;

  @override
  Widget build(BuildContext context) {
    final categories = widget.controller.availableDiscountCategories;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
      ),
      child: Column(
        children: [
          // مشروط کلیم ٹوگل بار
          InkWell(
            onTap: () {
              setState(() {
                isClaimExpanded = !isClaimExpanded;
                if (!isClaimExpanded) {
                  widget.controller.discountCtrl.text = '0';
                }
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    isClaimExpanded ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                    color: isClaimExpanded ? const Color(0xFF0D9488) : const Color(0xFF64748B),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'خصوصی رعایت یا آفر کلیم کریں (اگر ایڈمن سے منظوری یا پیکیج طے شدہ ہو)',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                    ),
                  ),
                  Icon(
                    isClaimExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          if (isClaimExpanded) ...[
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              value: (widget.controller.selectedDiscountCategoryIndex >= 0 &&
                                      widget.controller.selectedDiscountCategoryIndex < categories.length)
                                  ? widget.controller.selectedDiscountCategoryIndex
                                  : 0,
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                              items: List.generate(
                                categories.length,
                                (i) => DropdownMenuItem(
                                  value: i,
                                  child: Text(categories[i], overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              onChanged: (v) => widget.controller.setDiscountCategoryIndex(v ?? 0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: widget.controller.discountCtrl,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                          decoration: InputDecoration(
                            hintText: '0',
                            prefixText: '- Rs. ',
                            prefixStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // ایڈمن تصدیق کا واضح انتباہ
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFCD34D)),
                    ),
                    child: const Text(
                      'ضروری نوٹ: یہ رعایت صرف اس صورت میں قبول ہوگی اگر آپ کو دکان کی جانب سے کسی پروموشنل پیکیج، عید آفر، یا خصوصی منظوری کا استحقاق حاصل ہو۔ یہ رقم حتمی طور پر ایڈمن کی تصدیق کے بعد ہی کھاتے میں لاگو ہوگی۔',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF92400E),
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}