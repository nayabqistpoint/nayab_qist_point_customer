import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/order_receipt_page/order_receipt_args.dart';
import 'package:nayab_qist_point_customer/customer_side/order_receipt_page/order_receipt_controller.dart';
import 'package:nayab_qist_point_customer/customer_side/order_receipt_page/components/receipt_token_header_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/order_receipt_page/components/receipt_summary_rows_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/order_receipt_page/components/receipt_schedule_table_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/order_receipt_page/components/bank_cheque_input_box_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/order_receipt_page/components/grace_period_note_ui.dart';
import 'package:nayab_qist_point_customer/customer_side/order_receipt_page/components/submit_order_button_ui.dart';

class OrderReceiptPage extends StatefulWidget {
  final OrderReceiptArgs? args;

  const OrderReceiptPage({super.key, this.args});

  @override
  State<OrderReceiptPage> createState() => _OrderReceiptPageState();
}

class _OrderReceiptPageState extends State<OrderReceiptPage> {
  OrderReceiptController? _controller;
  OrderReceiptArgs? _effectiveArgs;

  @override
  void initState() {
    super.initState();
    if (widget.args != null) {
      _effectiveArgs = widget.args;
      _controller = OrderReceiptController(plan: widget.args!.plan);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      final rawArgs = ModalRoute.of(context)?.settings.arguments;
      if (rawArgs is OrderReceiptArgs) {
        _effectiveArgs = rawArgs;
      } else if (rawArgs is Map<String, dynamic>) {
        _effectiveArgs = OrderReceiptArgs.fromMap(rawArgs);
      }
      if (_effectiveArgs != null) {
        setState(() {
          _controller = OrderReceiptController(plan: _effectiveArgs!.plan);
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _effectiveArgs == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final c = _controller!;
    final args = _effectiveArgs!;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF0F172A),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'باقاعدہ آرڈر رسید و شیڈول',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: ListenableBuilder(
          listenable: c,
          builder: (context, _) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFCBD5E1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReceiptTokenHeaderUi(tokenNo: c.tokenNo),
                  const Divider(height: 20, color: Color(0xFFE2E8F0)),
                  ReceiptSummaryRowsUi(
                    deviceName: args.deviceName,
                    guaranteeTitle: c.isChequePlan ? 'بینک چیک گارنٹی' : 'اشٹام پرنوٹ ضمانت',
                    months: c.months,
                    advance: c.advance,
                    monthly: c.monthly,
                    totalInstallmentSum: c.totalInstallmentSum,
                  ),
                  const SizedBox(height: 14),
                  ReceiptScheduleTableUi(installmentSchedule: args.installmentSchedule),
                  if (c.isChequePlan) ...[
                    const SizedBox(height: 14),
                    BankChequeInputBoxUi(
                      bankNameCtrl: c.bankNameCtrl,
                      chequeNoCtrl: c.chequeNoCtrl,
                    ),
                  ],
                  if (c.localError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      c.localError!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  const GracePeriodNoteUi(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: ListenableBuilder(
          listenable: c,
          builder: (context, _) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: SubmitOrderButtonUi(
                onSubmit: c.isSubmitting
                    ? () {}
                    : () => c.submitOrder(
                          context: context,
                          deviceName: args.deviceName,
                          customerPhone: args.customerPhone,
                          sourceMode: args.sourceMode,
                          imeiNo: args.imeiNo,
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}