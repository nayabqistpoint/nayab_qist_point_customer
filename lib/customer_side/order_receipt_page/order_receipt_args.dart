class OrderReceiptArgs {
  final Map<String, dynamic> plan;
  final String deviceName;
  final String? customerPhone;
  final List<Map<String, dynamic>> installmentSchedule;
  final String? sourceMode;
  final String? imeiNo;

  const OrderReceiptArgs({
    required this.plan,
    required this.deviceName,
    this.customerPhone,
    required this.installmentSchedule,
    this.sourceMode,
    this.imeiNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'plan': plan,
      'deviceName': deviceName,
      'customerPhone': customerPhone,
      'installmentSchedule': installmentSchedule,
      'sourceMode': sourceMode,
      'imeiNo': imeiNo,
    };
  }

  factory OrderReceiptArgs.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const OrderReceiptArgs(
        plan: {},
        deviceName: '',
        installmentSchedule: [],
      );
    }
    return OrderReceiptArgs(
      plan: (map['plan'] as Map<dynamic, dynamic>?)?.cast<String, dynamic>() ?? {},
      deviceName: map['deviceName']?.toString() ?? '',
      customerPhone: map['customerPhone']?.toString(),
      installmentSchedule: (map['installmentSchedule'] as List?)
              ?.map((e) => (e as Map<dynamic, dynamic>).cast<String, dynamic>())
              .toList() ??
          [],
      sourceMode: map['sourceMode']?.toString(),
      imeiNo: map['imeiNo']?.toString(),
    );
  }
}