import 'package:flutter/material.dart';

class InstallmentTableHeaderUi extends StatelessWidget {
  final String planName;
  final String orderStatus;
  final int overdueCount;
  final int overdueAmount;
  final String Function(int) formatAmount;

  const InstallmentTableHeaderUi({
    super.key,
    required this.planName,
    required this.orderStatus,
    required this.overdueCount,
    required this.overdueAmount,
    required this.formatAmount,
  });

  Widget _buildAdminStatusCapsule() {
    final bool isApproved = orderStatus == 'APPROVED';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isApproved ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isApproved ? const Color(0xFF86EFAC) : const Color(0xFFFCD34D),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isApproved ? Icons.verified_rounded : Icons.pending_actions_rounded,
            size: 12,
            color: isApproved ? const Color(0xFF16A34A) : const Color(0xFFD97706),
          ),
          const SizedBox(width: 4),
          Text(
            isApproved ? 'منظور شدہ پلان' : 'زیرِ جائزہ (ایڈمن تصدیق)',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isApproved ? const Color(0xFF16A34A) : const Color(0xFFB45309),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasOverdue = overdueCount > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // اوپر کی لائن: پلان کا نام اور ایڈمن اسٹیٹس
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  planName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildAdminStatusCapsule(),
            ],
          ),
          const SizedBox(height: 8),

          // 🎯 اوور ڈیو کی مکمل ریسپانسیو الرٹ پٹی (Zero Overflow)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: hasOverdue ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasOverdue ? const Color(0xFFFECACA) : const Color(0xFFBBF7D0),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  hasOverdue ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
                  size: 14,
                  color: hasOverdue ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                ),
                const SizedBox(width: 5),
                // بائیں جانب کا عنوان (خود کو سکیڑ لے گا اور اوورفلو نہیں ہونے دے گا)
                Expanded(
                  child: Text(
                    hasOverdue
                        ? 'شارٹ اقساط: ($overdueCount قسط شارٹ)'
                        : 'تمام اقساط وقت پر ہیں',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: hasOverdue ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // دائیں جانب کی رقم (FittedBox کے اندر سکیڑ دی گئی ہے)
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      hasOverdue
                          ? 'Rs. ${formatAmount(overdueAmount)} واجب ادا'
                          : 'کوئی قسط شارٹ نہیں',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: hasOverdue ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}