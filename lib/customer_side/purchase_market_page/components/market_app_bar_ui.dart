import 'package:flutter/material.dart';

class MarketAppBarUi extends StatelessWidget implements PreferredSizeWidget {
  final String? customerPhone;
  final VoidCallback? onCalculatorTap;

  const MarketAppBarUi({
    super.key,
    this.customerPhone,
    this.onCalculatorTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPublic = customerPhone == null || customerPhone!.isEmpty;

    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF0F172A),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'نایاب قسط پوائنٹ (قائم پور)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            isPublic
                ? 'پبلک شو روم • 28 سمارٹ اقساطی پلانز'
                : 'کھاتہ: $customerPhone • تصدیق شدہ کسٹمر',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isPublic ? const Color(0xFF94A3B8) : const Color(0xFF34D399),
            ),
          ),
        ],
      ),
      actions: [
        if (onCalculatorTap != null)
          IconButton(
            icon: const Icon(Icons.calculate_outlined, color: Color(0xFFFDE68A)),
            onPressed: onCalculatorTap,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}