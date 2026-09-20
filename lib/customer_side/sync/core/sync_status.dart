enum SyncStatus {
  idle,
  syncing,
  synced,
  offline,
  error,
}

class SyncResult {
  final bool success;
  final String message;
  final int recordsProcessed;

  const SyncResult({
    required this.success,
    required this.message,
    this.recordsProcessed = 0,
  });

  factory SyncResult.success([int count = 0]) => SyncResult(
        success: true,
        message: 'کامیابی سے سنک ہو گیا',
        recordsProcessed: count,
      );

  factory SyncResult.failure(String err) => SyncResult(
        success: false,
        message: err,
        recordsProcessed: 0,
      );
}