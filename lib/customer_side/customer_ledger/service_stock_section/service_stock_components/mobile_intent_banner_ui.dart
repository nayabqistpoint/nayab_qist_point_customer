import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_section/service_stock_controller.dart';

class MobileIntentBannerUi extends StatelessWidget {
  final ServiceStockController controller;
  const MobileIntentBannerUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isPromo = controller.mobileIntent == 1;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF99F6E4), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'موبائل کا مقصد منتخب کریں:',
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF134E4A)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => controller.setMobileIntent(1),
                  borderRadius: BorderRadius.circular(9),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: isPromo ? const Color(0xFF0D9488) : Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: isPromo ? const Color(0xFF0D9488) : const Color(0xFFCBD5E1)),
                      boxShadow: isPromo
                          ? [BoxShadow(color: const Color(0xFF0D9488).withValues(alpha: 0.25), blurRadius: 4, offset: const Offset(0, 2))]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isPromo) ...[
                          const Icon(Icons.check_circle_rounded, size: 15, color: Colors.white),
                          const SizedBox(width: 5),
                        ],
                        Text(
                          'پروموشنل (آن آرڈر ڈسپلے)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isPromo ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () => controller.setMobileIntent(0),
                  borderRadius: BorderRadius.circular(9),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: !isPromo ? const Color(0xFF0D9488) : Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: !isPromo ? const Color(0xFF0D9488) : const Color(0xFFCBD5E1)),
                      boxShadow: !isPromo
                          ? [BoxShadow(color: const Color(0xFF0D9488).withValues(alpha: 0.25), blurRadius: 4, offset: const Offset(0, 2))]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isPromo) ...[
                          const Icon(Icons.check_circle_rounded, size: 15, color: Colors.white),
                          const SizedBox(width: 5),
                        ],
                        Text(
                          'فوری فروخت (دکان اسٹاک)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: !isPromo ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF0F766E)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  isPromo
                      ? 'یہ موبائل نایاب قسط پوائنٹ ایپ پر "طلب پر دستیاب" شو ہوگا اور قسط کیلکولیٹر میں نظر آئے گا۔'
                      : 'یہ موبائل نایاب قسط پوائنٹ کی اصل انوینٹری میں براہ راست ایڈ ہونے کے لیے جائے گا۔',
                  style: const TextStyle(fontSize: 10, color: Color(0xFF0F766E), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}