import 'package:flutter/material.dart';
import '../customer_ledger_controller.dart';
import 'shop_notice_ticker_ui.dart';
import 'wallet_master_card_ui.dart';
import 'installment_gateway_card_ui.dart';
import 'cash_account_gateway_card_ui.dart';

class LedgerDashboardBodyUi extends StatelessWidget {
  final CustomerLedgerController controller;

  const LedgerDashboardBodyUi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShopNoticeTickerUi(),
          const SizedBox(height: 14),
          WalletMasterCardUi(
            netAmount: controller.grandNetTotal,
            isDebtor: controller.isDebtor,
            formatAmount: controller.formatAmount,
          ),
          const SizedBox(height: 18),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              'کھاتہ تفصیلات و انتظام',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          InstallmentGatewayCardUi(
            itemName: controller.activeMobileTitle,
            planTitle: controller.activePlanSubtitle,
            remainingAmount: controller.totalInstallmentDue,
            overdueCount: controller.overdueInstallmentCount,
            overdueAmount: controller.overdueInstallmentAmount,
            formatAmount: controller.formatAmount,
            onTap: () => controller.openInstallmentPage(context),
          ),
          const SizedBox(height: 14),
          CashAccountGatewayCardUi(
            balance: controller.cashLoanBalance,
            hasAdvance: controller.hasAdvance,
            formatAmount: controller.formatAmount,
            onTap: () => controller.openCashLoanPage(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}