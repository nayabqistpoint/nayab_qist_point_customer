import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/customer_side/customer_ledger/service_stock_section/service_stock_entry_page.dart';

class CustomerSessionContextService {
  static Future<dynamic> openServiceStockEntry(
    BuildContext context, {
    required String customerPhone,
    required List<Map<String, dynamic>> products,
  }) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceStockEntryPage(
          customerPhone: customerPhone,
          customerProducts: products,
        ),
      ),
    );
  }
}