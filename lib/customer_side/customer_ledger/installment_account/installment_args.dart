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

  factory InstallmentArgs.fromMap(Map<String, dynamic>? map) {
    return InstallmentArgs(
      customerPhone: map?['customerPhone']?.toString() ?? '',
      customerName: map?['customerName']?.toString(),
      targetOrderId: map?['targetOrderId']?.toString(),
      initialFilter: map?['initialFilter']?.toString() ?? 'Active',
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