class UserAuthPayloadBuilder {
  static Map<String, dynamic> build(Map<String, dynamic>? d, String phone) {
    return {
      'docId': phone,
      'customerPhone': phone,
      'pin': (d?['pin'] ?? '7860').toString().trim(),
      'status': 'pending',
      'isSynced': false,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }
}