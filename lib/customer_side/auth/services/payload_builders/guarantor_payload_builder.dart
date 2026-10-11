class GuarantorPayloadBuilder {
  static Map<String, dynamic> build(Map<String, dynamic>? d, String phone) {
    return {
      'docId': phone,
      'customerPhone': phone,
      'guarantorName': (d?['gName'] ?? d?['guarantorName'] ?? '').toString().trim(),
      'guarantorFatherName': (d?['gFather'] ?? d?['guarantorFatherName'] ?? '').toString().trim(),
      'guarantorCaste': (d?['gCaste'] ?? d?['guarantorCaste'] ?? '').toString().trim(),
      'guarantorPhone': (d?['gPhone'] ?? d?['guarantorPhone'] ?? '').toString().trim(),
      'guarantorCnic': (d?['gCnic'] ?? d?['guarantorCnic'] ?? '').toString().trim(),
      'guarantorRelation': (d?['gRelation'] ?? d?['guarantorRelation'] ?? '').toString().trim(),
      'guarantorAddress': (d?['gAddress'] ?? d?['guarantorAddress'] ?? '').toString().trim(),
      'isSynced': false,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}