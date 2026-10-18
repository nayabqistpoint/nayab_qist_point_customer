class DevicePlanDetailArgs {
  final Map<String, dynamic> device;
  final String? customerPhone;

  const DevicePlanDetailArgs({
    required this.device,
    this.customerPhone,
  });

  Map<String, dynamic> toMap() {
    return {
      'device': device,
      'customerPhone': customerPhone,
    };
  }

  factory DevicePlanDetailArgs.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const DevicePlanDetailArgs(device: {});
    }
    return DevicePlanDetailArgs(
      device: (map['device'] as Map<dynamic, dynamic>?)?.cast<String, dynamic>() ?? {},
      customerPhone: map['customerPhone']?.toString(),
    );
  }
}