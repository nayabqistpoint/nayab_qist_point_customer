import 'package:flutter/material.dart';

class MarketAppBarUi extends StatelessWidget implements PreferredSizeWidget {
  final String? customerPhone;
  final VoidCallback onCalculatorTap;

  const MarketAppBarUi({
    super.key,
    this.customerPhone,
    required this.onCalculatorTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF0F172A),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'موبائل اقساط مارکیٹ',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 2),
          Text(
            customerPhone == null
                ? 'پبلک شو روم • 28 سمارٹ اقساطی پلانز'
                : 'کھاتہ: $customerPhone • تصدیق شدہ کسٹمر',
            style: const TextStyle(fontSize: 10.5, color: Color(0xFFFDE68A), fontWeight: FontWeight.w700),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'دستی تخمینہ',
          icon: const Icon(Icons.calculate_outlined, color: Color(0xFF34D399)),
          onPressed: onCalculatorTap,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}