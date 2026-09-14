import 'package:flutter/material.dart';

class InlineTwoPlanDrawerUi extends StatelessWidget {
  final int zeroAdvMonthly;
  final int withAdvMonthly;
  final VoidCallback onOpenFullPlan;

  const InlineTwoPlanDrawerUi({
    super.key,
    required this.zeroAdvMonthly,
    required this.withAdvMonthly,
    required this.onOpenFullPlan,
  });

  Widget _buildMiniRateBadge(String title, int monthly, {required bool isGreen}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isGreen ? const Color(0xFFECFDF5) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isGreen ? const Color(0xFFA7F3D0) : const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 9.5,
              color: isGreen ? const Color(0xFF065F46) : const Color(0xFF64748B),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Rs. $monthly /ماہ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: isGreen ? const Color(0xFF059669) : const Color(0xFF0D9488),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color(0xFFF8FAFC),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMiniRateBadge('6 ماہ (بغیر ایڈوانس)', zeroAdvMonthly, isGreen: true),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMiniRateBadge('6 ماہ (ایڈوانس کے ساتھ)', withAdvMonthly, isGreen: false),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onOpenFullPlan,
              icon: const Icon(Icons.fullscreen_rounded, size: 15),
              label: const Text('مکمل 28 اقساطی پلانز کھولیں اور آرڈر بک کریں'),
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                foregroundColor: const Color(0xFF0F172A),
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}