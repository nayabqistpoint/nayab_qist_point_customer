import 'package:flutter/material.dart';

class StockModeToggleCardUi extends StatelessWidget {
  final bool isPromotionalOnOrder;
  final ValueChanged<bool> onToggle;

  const StockModeToggleCardUi({super.key, required this.isPromotionalOnOrder, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPromotionalOnOrder ? const Color(0xFFEFF6FF) : const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isPromotionalOnOrder ? const Color(0xFF93C5FD) : const Color(0xFF86EFAC)),
      ),
      child: Row(
        children: [
          Icon(
            isPromotionalOnOrder ? Icons.campaign_rounded : Icons.store_rounded,
            color: isPromotionalOnOrder ? const Color(0xFF1D4ED8) : const Color(0xFF16A34A),
            size: 26,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPromotionalOnOrder ? 'صرف پروموشنل (Available on Order)' : 'باقاعدہ دکان اسٹاک (خریداری کٹوتی)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isPromotionalOnOrder ? const Color(0xFF1D4ED8) : const Color(0xFF15803D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isPromotionalOnOrder ? 'کھاتے پر صفر اثر۔ موبائل مارکیٹ میں کسٹمر آرڈر پر دستیاب ہوگا' : 'لاگت قیمت نقد ادھار سے منفی (Credit) ہو جائے گی',
                  style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          Switch(
            value: isPromotionalOnOrder,
            activeThumbColor: const Color(0xFF1D4ED8),
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}