import 'package:flutter/material.dart';
import 'service_transaction_card_ui.dart';

class ServiceTransactionsSectionUi extends StatelessWidget {
  final List<Map<String, dynamic>> serviceTransactions;
  final String Function(int) formatAmount;
  final VoidCallback onNewServicePressed;
  final ValueChanged<Map<String, dynamic>> onToggleExpand;

  const ServiceTransactionsSectionUi({
    super.key,
    required this.serviceTransactions,
    required this.formatAmount,
    required this.onNewServicePressed,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // نیا فارم کھولنے کا بٹن
        InkWell(
          onTap: onNewServicePressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.post_add_rounded, color: Colors.white, size: 19),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'نئی خدمات، راشن یا اسٹاک تبادلہ درج کریں (مکمل فارم)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        if (serviceTransactions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Center(
              child: Text(
                'کوئی سروس یا اسٹاک ٹرانزیکشن موجود نہیں ہے۔',
                style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
              ),
            ),
          )
        else
          ...serviceTransactions.map(
            (tx) => ServiceTransactionCardUi(
              tx: tx,
              formatAmount: formatAmount,
              onToggleExpand: () => onToggleExpand(tx),
            ),
          ),
      ],
    );
  }
}