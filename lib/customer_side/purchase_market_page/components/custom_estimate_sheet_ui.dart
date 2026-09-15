import 'package:flutter/material.dart';
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
              // 🌟 نایاب قسط پوائنٹ کی مستند 28 بیج والی پٹی
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
                    // 🟡 عنبر 28 بیج
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDE68A),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '28',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 📜 تفصیلی متن
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نایاب 28 اقساطی پیکجز کا مکمل جدول',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '7 مدتیں (6 تا 12 ماہ) • 14 چیک مع 14 اشٹام پلانز • زیرو ایڈوانس سہولت',
                            style: TextStyle(
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
              EstimateSheetFormUi(onSubmit: onSubmit),
            ],
          ),
        ),
      ),
    );
  }
}