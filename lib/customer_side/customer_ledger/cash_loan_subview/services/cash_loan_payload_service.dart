import 'payload_builders/cash_loan_transaction_builder.dart';

class CashLoanPayloadService {
  /// نقد واپسی کا ٹرانزیکشن ریکارڈ بناتا ہے (زیرو ہائیو امپورٹ)
  static Map<String, dynamic> buildRepaymentPayload({
    required String customerPhone,
    required int paidAmount,
    required int discountAmount,
    required List<Map<String, dynamic>> splits,
    required String note,
    String receiptImagePath = '',
    String voiceNotePath = '',
  }) {
    return CashLoanTransactionBuilder.buildTransactionRecord(
      customerPhone: customerPhone,
      paidAmount: paidAmount,
      discountAmount: discountAmount,
      splits: splits,
      note: note,
      receiptImagePath: receiptImagePath,
      voiceNotePath: voiceNotePath,
    );
  }
}