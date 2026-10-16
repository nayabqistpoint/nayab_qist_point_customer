import 'package:flutter/material.dart';

class FrozenBottomActionBarUi extends StatelessWidget {
  final VoidCallback onStatementPressed;
  final VoidCallback onPurchasePressed;

  const FrozenBottomActionBarUi({
    super.key,
    required this.onStatementPressed,
    required this.onPurchasePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFCBD5E1), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: OutlinedButton.icon(
                onPressed: onStatementPressed,
                icon: const Icon(Icons.receipt_long_rounded, size: 18),
                label: const Text(
                  'پاس بک و رسیدیں',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F172A),
                  backgroundColor: const Color(0xFFF8FAFC),
                  side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 6,
              child: ElevatedButton.icon(
                onPressed: onPurchasePressed,
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                label: const Text(
                  'نیا موبائل لیں (+)',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: const Color(0xFFFDE68A),
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}