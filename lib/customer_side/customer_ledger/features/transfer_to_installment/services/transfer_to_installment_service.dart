class TransferToInstallmentService {
  TransferToInstallmentService._();

  static String? validateTransferAmount({
    required int amount,
    required int maxRemaining,
    required int availableGreenAdvance,
  }) {
    if (amount <= 0) {
      return 'برائے مہربانی درست رقم درج کریں';
    }
    if (amount > availableGreenAdvance) {
      return 'رقم دستیاب ایڈوانس سے زیادہ نہیں ہو سکتی';
    }
    if (amount > maxRemaining) {
      return 'رقم اس پلان کے کل بقایا سے زیادہ نہیں ہو سکتی';
    }
    return null;
  }

  static int calculateMaxAllowed({
    required int availableGreenAdvance,
    required int maxRemaining,
  }) {
    if (availableGreenAdvance < maxRemaining) {
      return availableGreenAdvance;
    }
    return maxRemaining;
  }

  static String formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}