import 'package:flutter/foundation.dart';

@immutable
class InstallmentArgs {
  final String customerPhone;
  final String? customerName;
  final String? targetOrderId;
  final String initialFilter;

  const InstallmentArgs({
    required this.customerPhone,
    this.customerName,
    this.targetOrderId,
    this.initialFilter = 'Active',
  });

  factory InstallmentArgs.fromMap(Map<String, dynamic> map) {
    return InstallmentArgs(
      customerPhone: map['customerPhone'] as String? ?? '',
      customerName: map['customerName'] as String?,
      targetOrderId: map['targetOrderId'] as String?,
      initialFilter: map['initialFilter'] as String? ?? 'Active',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerPhone': customerPhone,
      'customerName': customerName,
      'targetOrderId': targetOrderId,
      'initialFilter': initialFilter,
    };
  }
}