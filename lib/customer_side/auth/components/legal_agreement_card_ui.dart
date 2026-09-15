import 'package:flutter/material.dart';

class LegalAgreementCardUi extends StatelessWidget {
  final bool agreementAccepted;
  final ValueChanged<bool?> onAgreementChanged;

  const LegalAgreementCardUi({
    super.key,
    required this.agreementAccepted,
    required this.onAgreementChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF059669).withValues(alpha: 0.5), width: 1.3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF059669).withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.gavel_rounded, color: Color(0xFFFDE68A), size: 17),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'قانونی اقرار نامہ و ضابطہ اخلاق',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: const Text(
                  'لازمی شرط',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                ),
              ),
            ],
          ),
          const Divider(height: 18, color: Color(0xFFCBD5E1)),
          _buildPoint('1', 'میں حلفاً اقرار کرتا ہوں کہ تمام کوائف اور شناختی دستاویزات بالکل درست اور اصلی ہیں۔'),
          const SizedBox(height: 7),
          _buildPoint('2', 'میں نایاب قسط پوائنٹ کے جملہ اقساطی قوانین اور مقررہ تاریخ پر ماہانہ ادائیگی کا پابند رہوں گا۔'),
          const SizedBox(height: 7),
          _buildPoint('3', 'جھوٹی معلومات کی صورت میں ادارے کو تعزیرات دفعہ 420 ت پ کے تحت قانونی کارروائی، ضبطی اور یکمشت ریکوری کا مکمل حق ہوگا۔', isWarning: true),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => onAgreementChanged(!agreementAccepted),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: agreementAccepted ? const Color(0xFFECFDF5) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: agreementAccepted ? const Color(0xFF059669) : const Color(0xFFCBD5E1),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: agreementAccepted,
                    activeColor: const Color(0xFF059669),
                    checkColor: Colors.white,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: onAgreementChanged,
                  ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text(
                      'میں نے تمام شرائط پڑھ کر حلفاً تسلیم کر لی ہیں*',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF065F46)),
                    ),
                  ),
                  if (agreementAccepted)
                    const Icon(Icons.verified_rounded, color: Color(0xFF059669), size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoint(String num, String text, {bool isWarning = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 17,
          height: 17,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isWarning ? const Color(0xFFFEE2E2) : const Color(0xFFE0F2FE),
            shape: BoxShape.circle,
          ),
          child: Text(
            num,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.bold,
              color: isWarning ? const Color(0xFFDC2626) : const Color(0xFF0369A1),
            ),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              height: 1.45,
              fontWeight: isWarning ? FontWeight.bold : FontWeight.w600,
              color: isWarning ? const Color(0xFFB91C1C) : const Color(0xFF334155),
            ),
          ),
        ),
      ],
    );
  }
}