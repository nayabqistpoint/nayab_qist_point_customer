class CustomerPayloadBuilder {
  static Map<String, dynamic> build(Map<String, dynamic>? d, String phone) {
    return {
      'docId': phone,
      'customerPhone': phone,
      'customerName': (d?['name'] ?? d?['customerName'] ?? 'محمد محیب').toString().trim(),
      'customerFatherName': (d?['fatherName'] ?? d?['customerFatherName'] ?? 'احمد علی').toString().trim(),
      'customerCaste': (d?['caste'] ?? d?['customerCaste'] ?? 'آرائیں').toString().trim(),
      'customerCnic': (d?['cnic'] ?? d?['customerCnic'] ?? '31202-1234567-1').toString().trim(),
      'customerAddress': (d?['address'] ?? d?['customerAddress'] ?? 'مین بازار، حاصل پور').toString().trim(),
      'isAgreementAccepted': d?['agreementAccepted'] ?? true,
      'status': 'pending',
      
      // 🌟 فنانشل سمرائزڈ فیلڈز (ایڈمن اور کسٹمر دونوں اینڈز کے لیے)
      'cashLoanBalance': 0,        // نقد کھاتہ (+ مقروض، - ایڈوانس)
      'installmentDueBalance': 0, // تمام موبائلز کی اقساط کا کل واجب الادا
      'grandNetTotal': 0,         // دونوں کا مجموعی خالص میزان
      'currentBalance': 0,        // پسماندہ مطابقت (Backward Compatibility)
      
      'isSynced': false,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}