import 'package:flutter/material.dart';
import 'zero_advance_pill_badge_ui.dart';
import 'inline_quick_ribbon_trigger_ui.dart';
import 'inline_two_plan_drawer_ui.dart';

class StockPhoneCardUi extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isRibbonExpanded;
  final int totalPlans;
  final VoidCallback onCardTap;
  final VoidCallback onToggleRibbon;

  const StockPhoneCardUi({
    super.key,
    required this.item,
    required this.isRibbonExpanded,
    required this.totalPlans,
    required this.onCardTap,
    required this.onToggleRibbon,
  });

  @override
  Widget build(BuildContext context) {
    final List images = (item['images'] as List?) ?? [];
    final bool hasValidImage = images.isNotEmpty && images.first.toString().trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isRibbonExpanded ? const Color(0xFF0D9488) : const Color(0xFFCBD5E1),
          width: isRibbonExpanded ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onCardTap,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 88,
                      height: 94,
                      color: const Color(0xFFF8FAFC),
                      child: hasValidImage
                          ? Image.network(
                              images.first.toString(),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(
                                  Icons.phone_android_rounded,
                                  size: 38,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.phone_android_rounded,
                                size: 38,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item['name'] ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                item['status'] ?? '',
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${item['ramRom']} • ${item['condition']}',
                          style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 6),
                        ZeroAdvancePillBadgeUi(monthlyAmount: item['zeroAdvMonthly'] ?? 0),
                        const SizedBox(height: 4),
                        Text(
                          'یا ایڈوانس کے ساتھ صرف: Rs. ${item['minMonthlyWithAdv'] ?? 0} /ماہ',
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InlineQuickRibbonTriggerUi(
            isExpanded: isRibbonExpanded,
            onTap: onToggleRibbon,
          ),
          if (isRibbonExpanded)
            InlineTwoPlanDrawerUi(
              zeroAdvMonthly: item['zeroAdvMonthly'] ?? 0,
              withAdvMonthly: item['minMonthlyWithAdv'] ?? 0,
              totalPlans: totalPlans,
              onOpenFullPlan: onCardTap,
            ),
        ],
      ),
    );
  }
}