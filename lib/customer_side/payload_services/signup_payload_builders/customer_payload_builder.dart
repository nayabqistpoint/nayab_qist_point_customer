class CustomerPayloadBuilder {
  static Map<String, dynamic> build(Map<String, dynamic>? d, String phone) {
    return {
      'docId': phone,
      'customerPhone': phone,
      'customerName': (d?['name'] ?? d?['customerName'] ?? 'محمد محیب').toString().trim(),
      'customerFatherName': (d?['fatherName'] ?? d?['customerFatherName'] ?? 'احمد علی').toString().trim(),
      'customerCaste': (d?['caste'] ?? d?['customerCaste'] ?? 'آرائیں').toString().trim(),
      'customerCnic': (d?['cnic'] ?? d?['customerCnic'] ?? '31202-1234567-1').toString().trim(),
      'customerAddress': (d?['address'] ?? d?['customerAddress'] ?? 'مین بازار، قائم پور').toString().trim(),
      'isAgreementAccepted': d?['agreementAccepted'] ?? true,
      'status': 'pending',
      'currentBalance': 0,
      'isSynced': false,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}