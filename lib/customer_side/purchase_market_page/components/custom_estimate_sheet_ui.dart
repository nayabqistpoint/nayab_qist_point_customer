import 'package:flutter/material.dart';
import '../../device_plan_detail_page/services/calculator_config_service.dart';
import '../../device_plan_detail_page/services/plan_generator_service.dart';
import 'estimate_sheet_form_ui.dart';

class CustomEstimateSheetUi extends StatelessWidget {
  final Function(String name, int estimatePrice, int advance) onSubmit;

  const CustomEstimateSheetUi({super.key, required this.onSubmit});

  static void show(
    BuildContext context, {
    required Function(String name, int estimatePrice, int advance) onSubmit,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomEstimateSheetUi(onSubmit: onSubmit),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🚀 ہائیو کنفگریشن اور حقیقی پلانز کی گنتی
    final config = CalculatorConfigService().getConfig();
    final int durationCount = config.allowedDurations.length;
    final int minDuration = config.allowedDurations.isNotEmpty ? config.allowedDurations.first : 6;
    final int maxDuration = config.allowedDurations.isNotEmpty ? config.allowedDurations.last : 12;

    final rawPlans = PlanGeneratorService.generateAllPlans(
      baseValue: 50000,
      userCustomAdvance: 0,
      config: config,
    );
    final int totalPlans = rawPlans.length;
    final int chequeCount = rawPlans.where((p) => p['guarantee'] == 'BANK_CHEQUE').length;
    final int stampCount = rawPlans.where((p) => p['guarantee'] == 'LEGAL_STAMP').length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🌟 نایاب قسط پوائنٹ کی مستند ڈائنامک بیج والی پٹی
              Container(
                margin: const EdgeInsets.fromLTRB(14, 14, 14, 6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // 🟡 متحرک بیج
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDE68A),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$totalPlans',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 📜 تفصیلی متحرک متن
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نایاب $totalPlans اقساطی پیکجز کا مکمل جدول',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$durationCount مدتیں ($minDuration تا $maxDuration ماہ) • $chequeCount چیک مع $stampCount اشٹام پلانز • زیرو ایڈوانس سہولت',
                            style: const TextStyle(
                              fontSize: 9.5,
                              color: Color(0xFFCBD5E1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // فارم باڈی
              EstimateSheetFormUi(
                totalPlans: totalPlans,
                onSubmit: onSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}