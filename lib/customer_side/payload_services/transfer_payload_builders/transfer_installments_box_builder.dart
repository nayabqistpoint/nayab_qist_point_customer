class TransferInstallmentsBoxBuilder {
  static Map<String, dynamic> build({
    required Map<String, dynamic> existingContractDoc,
    required int transferAmount,
  }) {
    final contract = Map<String, dynamic>.from(existingContractDoc);
    final rawInstallments = (contract['installments'] as List?) ?? [];
    final String nowIso = DateTime.now().toIso8601String();
    
    int remainingTransferPool = transferAmount;
    final List<Map<String, dynamic>> updatedInstallments = [];

    for (var rawItem in rawInstallments) {
      final inst = Map<String, dynamic>.from(rawItem as Map);
      final int dueAmount = (inst['dueAmount'] as num?)?.toInt() ?? 0;
      int paidAmount = (inst['paidAmount'] as num?)?.toInt() ?? 0;
      int remainingAmount = (inst['remainingAmount'] as num?)?.toInt() ?? (dueAmount - paidAmount);

      if (remainingAmount > 0 && remainingTransferPool > 0) {
        if (remainingTransferPool >= remainingAmount) {
          paidAmount += remainingAmount;
          remainingTransferPool -= remainingAmount;
          remainingAmount = 0;
          inst['status'] = 'PAID';
          inst['paymentPercentage'] = 100;
        } else {
          paidAmount += remainingTransferPool;
          remainingAmount -= remainingTransferPool;
          remainingTransferPool = 0;
          inst['status'] = 'PENDING';
          inst['paymentPercentage'] = ((paidAmount / dueAmount) * 100).round();
        }
        inst['verificationStatus'] = 'approved';
      }

      inst['paidAmount'] = paidAmount;
      inst['remainingAmount'] = remainingAmount;
      updatedInstallments.add(inst);
    }

    contract['installments'] = updatedInstallments;
    contract['lastAdjustmentNote'] = 'نقد کھاتے سے قسط میں Rs. $transferAmount ایڈجسٹ کیے گئے';
    contract['updatedAt'] = nowIso;
    contract['lastUpdated'] = nowIso;
    contract['isSynced'] = false; // ☁️ सिंक ट्रिगर

    return contract;
  }
}