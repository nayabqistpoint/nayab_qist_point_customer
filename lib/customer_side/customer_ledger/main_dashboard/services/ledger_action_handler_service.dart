import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/payload_services/installment_allocation_service.dart';
import 'package:nayab_qist_point_customer/customer_side/payload_services/cash_loan_repayment_service.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/shared/customer_session_context_service.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/cash_loan_subview/services/transaction_ledger_service.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/main_dashboard/components/customer_statement_sheet_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/main_dashboard/customer_ledger_controller.dart';

class LedgerActionHandlerService {
  // ڈمی ڈیٹا کی شروعات
  static List<Map<String, dynamic>> get initialCashLoanEntries => [
    {
      'title': 'دکان سے نقد دستی کیش لیا',
      'date': '10 اگست 2026',
      'amount': 50000,
      'type': 'DEBIT',
    }
  ];

  static List<Map<String, dynamic>> get initialServiceTransactions => [
    {
      'title': 'ماہانہ کریانہ راشن بل',
      'nature': 'EXPENSE',
      'natureTitle': 'دکان و راشن خرچہ',
      'isExpanded': false,
      'status': 'APPROVED',
      'items': [
        {'name': 'چینی (10 کلو)', 'amount': 1500},
        {'name': 'گھی کا ڈبہ (5 لیٹر)', 'amount': 2850},
      ],
      'totalAmount': 4350,
      'target': 'قسط کھاتہ',
      'hasAudio': true,
      'hasPhoto': true,
      'date': '09 ستمبر 2026',
    }
  ];

  // کسٹمر اسٹیٹمنٹ پاس بک کھولنا
  static Future<void> openCustomerStatement(
    BuildContext context,
    String phone,
    String Function(int) format,
  ) async {
    await TransactionLedgerService.ensureBoxOpen();
    final txs = await TransactionLedgerService.getCustomerTransactions(phone);
    if (context.mounted) {
      CustomerStatementSheetUi.show(
        context,
        transactions: txs,
        formatAmount: format,
      );
    }
  }

  // قسط کی ادائیگی کا مکمل ہینڈلر
  static Future<bool> payInstallment(
    BuildContext context,
    CustomerLedgerController controller,
    Map<String, dynamic> schedItem, {
    String? itemName,
    String? planTitle,
  }) async {
    if (controller.customerProducts.isEmpty) return false;
    final currentProduct = controller.customerProducts[controller.selectedProductIndex];

    if (currentProduct['hasPendingReview'] == true) {
      _showMsg(
        context,
        'پچھلی ادائیگی ایڈمن کی زیرِ تصدیق ہے۔ مزید ادائیگی مقفل ہے',
        isError: true,
      );
      return false;
    }

    final remaining = (schedItem['remainingAmount'] as int?) ?? (schedItem['amount'] as int);
    final totalRemaining = (currentProduct['remaining'] as int?) ?? remaining;

    final result = await CustomerSessionContextService.openUniversalPayment(
      context,
      title: 'قسط نمبر ${schedItem['no']} کی ادائیگی',
      baseAmount: remaining,
      isInstallment: true,
      itemName: itemName ?? currentProduct['name']?.toString() ?? 'موبائل فون',
      planTitle: planTitle ?? currentProduct['plan']?.toString() ?? 'اقساط پلان',
      installmentNo: schedItem['no'] as int?,
      maxAllowedAmount: totalRemaining,
    );

    if (result != null && result is Map<String, dynamic>) {
      final success = await InstallmentAllocationService.processPaymentAllocation(
        customerPhone: controller.customerPhone,
        orderKey: currentProduct['orderKey'],
        rawOrder: currentProduct['rawOrder'],
        totalPaidAmount: (result['paid'] as num?)?.toInt() ?? 0,
        discountAmount: (result['discount'] as num?)?.toInt() ?? 0,
        extraAmount: (result['extra'] as num?)?.toInt() ?? 0,
        splits: (result['splits'] as List?)?.cast<Map<String, dynamic>>() ?? [],
        note: (result['note'] ?? '').toString(),
        receiptImagePath: (result['receiptImagePath'] ?? '').toString(),
        voiceNotePath: (result['voiceNotePath'] ?? '').toString(),
      );

      if (success && context.mounted) {
        _showMsg(
          context,
          'وصولی تصدیق کے لیے جمع ہو گئی: Rs. ${controller.formatAmount(result['paid'])}',
        );
        return true;
      }
    }
    return false;
  }

  // نقد ادھار واپسی کا مکمل ہینڈلر
  static Future<bool> payCashLoan(
    BuildContext context,
    CustomerLedgerController controller,
  ) async {
    final result = await CustomerSessionContextService.openUniversalPayment(
      context,
      title: 'نقد دستی ادھار کی واپسی',
      baseAmount: controller.cashLoanBalance > 0 ? controller.cashLoanBalance : 0,
      isInstallment: false,
      itemName: 'نقد ادھار کھاتہ',
      planTitle: 'دستی قرض کھاتہ',
    );

    if (result != null && result is Map<String, dynamic>) {
      final int paid = (result['paid'] as num?)?.toInt() ?? 0;
      final int discount = (result['discount'] as num?)?.toInt() ?? 0;

      final success = await CashLoanRepaymentService.processRepayment(
        customerPhone: controller.customerPhone,
        paidAmount: paid,
        discountAmount: discount,
        splits: (result['splits'] as List?)?.cast<Map<String, dynamic>>() ?? [],
        note: (result['note'] ?? '').toString(),
        receiptImagePath: (result['receiptImagePath'] ?? '').toString(),
        voiceNotePath: (result['voiceNotePath'] ?? '').toString(),
      );

      if (success) {
        final now = DateTime.now();
        controller.cashLoanBalance -= (paid + discount);
        controller.cashLoanEntries.insert(0, {
          'title': 'دستی قرض واپسی ادا کی',
          'date': '${now.day}-${now.month}-${now.year}',
          'amount': paid,
          'type': 'CREDIT',
        });
        if (context.mounted) {
          _showMsg(
            context,
            'نقد واپسی رسید تصدیق کے لیے جمع ہو گئی: Rs. ${controller.formatAmount(paid)}',
          );
        }
        return true;
      }
    }
    return false;
  }

  // سروس و اسٹاک اندراج نیویگیشن
  static Future<Map<String, dynamic>?> addNewService(
    BuildContext context,
    String phone,
    List<Map<String, dynamic>> products,
  ) async {
    final res = await CustomerSessionContextService.openServiceStockEntry(
      context,
      customerPhone: phone,
      products: products,
    );
    return (res is Map<String, dynamic>) ? res : null;
  }

  static void _showMsg(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? const Color(0xFFDC2626) : const Color(0xFF059669),
      ),
    );
  }
}