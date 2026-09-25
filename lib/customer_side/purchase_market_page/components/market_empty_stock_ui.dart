import 'package:flutter/material.dart';

class MarketEmptyStockUi extends StatelessWidget {
  const MarketEmptyStockUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: Color(0xFF94A3B8),
          ),
          SizedBox(height: 10),
          Text(
            'فی الحال اسٹاک میں کوئی موبائل موجود نہیں ہے',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'اپنی مرضی کی قیمت کا تخمینہ لگانے کے لیے اوپر والا بینر استعمال کریں',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}