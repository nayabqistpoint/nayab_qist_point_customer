class MediaPayloadBuilder {
  static Map<String, dynamic> build(Map<String, dynamic>? d, String phone) {
    final custFront = (d?['customerCnicFront'] ?? '').toString().trim();
    final custBack = (d?['customerCnicBack'] ?? '').toString().trim();
    final custSelfie = (d?['customerSelfie'] ?? '').toString().trim();
    final custAudio = (d?['customerAudio'] ?? '').toString().trim();
    final guarFront = (d?['guarantorCnicFront'] ?? '').toString().trim();
    final guarBack = (d?['guarantorCnicBack'] ?? '').toString().trim();

    final bool isUploaded = custFront.startsWith('https://res.cloudinary.com');

    return {
      'docId': phone,
      'customerPhone': phone,
      'status': isUploaded ? 'ready_to_push' : 'pending_upload',
      'isSynced': !isUploaded, // اپلوڈ ہونے تک تالا (true)، اپلوڈ کے بعد پش کے لیے تیار (false)
      'createdAt': DateTime.now().toIso8601String(),

      'customerCnicFront': custFront,
      'customerCnicBack': custBack,
      'customerSelfie': custSelfie,
      'customerAudio': custAudio,

      'guarantorCnicFront': guarFront,
      'guarantorCnicBack': guarBack,
    };
  }
}