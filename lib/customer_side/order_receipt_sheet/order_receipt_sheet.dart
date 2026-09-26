import 'package:flutter/material.dart';
import 'order_receipt_sheet_controller.dart';
import 'components/receipt_token_header_ui.dart';
import 'components/receipt_summary_rows_ui.dart';
import 'components/receipt_schedule_table_ui.dart';
import 'components/bank_cheque_input_box_ui.dart';
import 'components/grace_period_note_ui.dart';
import 'components/submit_order_button_ui.dart';

class OrderReceiptSheet extends StatefulWidget {
  final Map<String, dynamic> plan;
  final String deviceName;
  final String? customerPhone;
  final List<Map<String, dynamic>> installmentSchedule;
  final String? sourceMode;
  final String? imeiNo;

  const OrderReceiptSheet({
    super.key,
    required this.plan,
    required this.deviceName,
    this.customerPhone,
    required this.installmentSchedule,
    this.sourceMode,
    this.imeiNo,
  });

  static void show(
    BuildContext context, {
    required Map<String, dynamic> plan,
    required String deviceName,
    String? customerPhone,
    required List<Map<String, dynamic>> installmentSchedule,
    String? sourceMode,
    String? imeiNo,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OrderReceiptSheet(
        plan: plan,
        deviceName: deviceName,
        customerPhone: customerPhone,
        installmentSchedule: installmentSchedule,
        sourceMode: sourceMode,
        imeiNo: imeiNo,
      ),
    );
  }

  @override
  State<OrderReceiptSheet> createState() => _OrderReceiptSheetState();
}

class _OrderReceiptSheetState extends State<OrderReceiptSheet> {
  late final OrderReceiptSheetController _c;

  @override
  void initState() {
    super.initState();
    _c = OrderReceiptSheetController(plan: widget.plan);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListenableBuilder(
        listenable: _c,
        builder: (context, _) => Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.90),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20)],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 12),
                ReceiptTokenHeaderUi(tokenNo: _c.tokenNo),
                const Divider(height: 20, color: Color(0xFFE2E8F0)),
                ReceiptSummaryRowsUi(
                  deviceName: widget.deviceName,
                  guaranteeTitle: _c.isChequePlan ? 'بینک چیک گارنٹی' : 'اشٹام پرنوٹ ضمانت',
                  months: _c.months,
                  advance: _c.advance,
                  monthly: _c.monthly,
                  totalInstallmentSum: _c.totalInstallmentSum,
                ),
                const SizedBox(height: 12),
                ReceiptScheduleTableUi(installmentSchedule: widget.installmentSchedule),
                if (_c.isChequePlan) ...[
                  const SizedBox(height: 12),
                  BankChequeInputBoxUi(bankNameCtrl: _c.bankNameCtrl, chequeNoCtrl: _c.chequeNoCtrl),
                ],
                if (_c.localError != null) ...[
                  const SizedBox(height: 8),
                  Text(_c.localError!, style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626), fontWeight: FontWeight.bold)),
                ],
                const SizedBox(height: 12),
                const GracePeriodNoteUi(),
                const SizedBox(height: 14),
                SubmitOrderButtonUi(
                  onSubmit: _c.isSubmitting ? () {} : () => _c.submitOrder(
                    context: context,
                    deviceName: widget.deviceName,
                    customerPhone: widget.customerPhone,
                    sourceMode: widget.sourceMode,
                    imeiNo: widget.imeiNo,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}