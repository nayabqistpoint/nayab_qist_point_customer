import 'package:flutter/material.dart';
import 'receipt_token_header_ui.dart';
import 'receipt_summary_rows_ui.dart';
import 'receipt_schedule_table_ui.dart';
import 'bank_cheque_input_box_ui.dart';
import 'grace_period_note_ui.dart';
import 'submit_order_button_ui.dart';
import 'sign_up_barrier_dialog_ui.dart';

class OrderReceiptSheet extends StatefulWidget {
  final Map<String, dynamic> plan;
  final String deviceName;
  final String? customerPhone;
  final List<Map<String, dynamic>> installmentSchedule;

  const OrderReceiptSheet({
    super.key,
    required this.plan,
    required this.deviceName,
    this.customerPhone,
    required this.installmentSchedule,
  });

  static void show(
    BuildContext context, {
    required Map<String, dynamic> plan,
    required String deviceName,
    String? customerPhone,
    required List<Map<String, dynamic>> installmentSchedule,
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
      ),
    );
  }

  @override
  State<OrderReceiptSheet> createState() => _OrderReceiptSheetState();
}

class _OrderReceiptSheetState extends State<OrderReceiptSheet> {
  final bankNameCtrl = TextEditingController();
  final chequeNoCtrl = TextEditingController();
  String? localError;
  late final String tokenNo;

  @override
  void initState() {
    super.initState();
    tokenNo = 'NQP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  }

  @override
  void dispose() {
    bankNameCtrl.dispose();
    chequeNoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int advance = widget.plan['advance'] as int;
    final int monthly = widget.plan['monthly'] as int;
    final int months = widget.plan['months'] as int;
    final int totalInstallmentSum = advance + (monthly * months);
    final bool isChequePlan = widget.plan['guarantee'] == 'BANK_CHEQUE';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, -4)),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Opacity(
                  opacity: 0.03,
                  child: Text(
                    'نایاب قسط پوائنٹ\nOFFICIAL SCHEDULE',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.red[900]),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(width: 36, height: 4, decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 12),
                  ReceiptTokenHeaderUi(tokenNo: tokenNo),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(
                      30,
                      (i) => Expanded(
                        child: Container(
                          color: i.isEven ? const Color(0xFFCBD5E1) : Colors.transparent,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ReceiptSummaryRowsUi(
                    deviceName: widget.deviceName,
                    guaranteeTitle: isChequePlan ? 'بینک چیک گارنٹی' : 'اشٹام پرنوٹ ضمانت',
                    months: months,
                    advance: advance,
                    monthly: monthly,
                    totalInstallmentSum: totalInstallmentSum,
                  ),
                  const SizedBox(height: 12),
                  ReceiptScheduleTableUi(installmentSchedule: widget.installmentSchedule),
                  const SizedBox(height: 12),
                  if (isChequePlan) ...[
                    BankChequeInputBoxUi(
                      bankNameCtrl: bankNameCtrl,
                      chequeNoCtrl: chequeNoCtrl,
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (localError != null) ...[
                    Text(
                      localError!,
                      style: const TextStyle(fontSize: 11, color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                  ],
                  const GracePeriodNoteUi(),
                  const SizedBox(height: 14),
                  SubmitOrderButtonUi(
                    onSubmit: () {
                      if (isChequePlan) {
                        if (bankNameCtrl.text.trim().isEmpty || chequeNoCtrl.text.trim().isEmpty) {
                          setState(() => localError = 'برائے مہربانی بینک کا نام اور چیک نمبر درج کریں!');
                          return;
                        }
                      }
                      if (widget.customerPhone == null || widget.customerPhone!.isEmpty) {
                        Navigator.pop(context);
                        SignUpBarrierDialogUi.show(context);
                        return;
                      }
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('آرڈر $tokenNo کسٹمر ${widget.customerPhone} کے کھاتے میں ایڈمن کو ارسال ہو گیا!'),
                          backgroundColor: const Color(0xFF059669),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}