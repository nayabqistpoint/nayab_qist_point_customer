import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/main_dashboard/components/logout_confirm_dialog_ui.dart';

class LedgerAppBarUi extends StatelessWidget implements PreferredSizeWidget {
  const LedgerAppBarUi({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              // لاگ آؤٹ بٹن
              InkWell(
                onTap: () => LogoutConfirmDialogUi.show(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.power_settings_new_rounded,
                    color: Color(0xFFFCA5A5),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // ٹائٹل اور سب ٹائٹل
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'میرا کھاتہ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'نایاب قسط پوائنٹ کسٹمر پورٹل',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFDE68A),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              // 🎯 صرف ایک ہلکا آئیکن بٹن (کل کو ہٹانا ہو تو صرف یہ 4 لائنیں ڈیلیٹ کر دیں)
              IconButton(
                icon: const Icon(Icons.terminal_rounded, color: Color(0xFF5EEAD4), size: 22),
                tooltip: 'کنٹرول ٹاور',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.benchmark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}