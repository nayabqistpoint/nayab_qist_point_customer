import 'package:flutter/material.dart';

class InstallmentEmptyStateUi extends StatelessWidget {
  const InstallmentEmptyStateUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.inventory_2_outlined, size: 36, color: Color(0xFF94A3B8)),
          SizedBox(height: 10),
          Text(
            'اس کسٹمر کے نام پر کوئی فعال اقساط کا پلان موجود نہیں ہے۔',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}