import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StockDetailsService {
  /// کسٹمر یا آئٹم کے موبائل/اسٹاک کا ڈیٹا حاصل کرنے کے لیے
  static Map<String, dynamic>? getStockDataByPhone(String customerPhone) {
    final String phone = customerPhone.replaceAll(RegExp(r'[^0-9]'), '');
    if (phone.isEmpty) return null;

    try {
      // اگر آپ کا اسٹاک ڈیٹا customerBox یا کسی stockBox میں ہے
      if (Hive.isBoxOpen('customerBox')) {
        final box = Hive.box('customerBox');
        for (final item in box.values.whereType<Map>()) {
          final p = (item['phone'] ?? item['customerPhone'] ?? '')
              .toString()
              .replaceAll(RegExp(r'[^0-9]'), '');
          if (p == phone) {
            return Map<String, dynamic>.from(item);
          }
        }
      }
    } catch (e) {
      debugPrint("اسٹاک ڈیٹا حاصل کرنے میں مسئلہ: $e");
    }
    return null;
  }

  /// اسٹاک کی تفصیلات فل اسکرین ڈائیلاگ یا باٹم شیٹ میں دکھانا
  static void showStockDetailsDialog(BuildContext context, String customerPhone) {
    final stockData = getStockDataByPhone(customerPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "اسٹاک کی تفصیلات",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(),
              if (stockData == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: Text("کوئی اسٹاک یا آئٹم کا ڈیٹا نہیں ملا")),
                )
              else ...[
                _infoRow("آئٹم/موبائل:", stockData['itemName'] ?? stockData['mobileModel'] ?? 'N/A'),
                _infoRow("آئی ایم ای آئی / سیریل:", stockData['imei'] ?? stockData['serialNo'] ?? 'N/A'),
                _infoRow("کل قیمت:", "Rs. ${stockData['totalPrice'] ?? stockData['price'] ?? '0'}"),
                _infoRow("اقساط کا پلان:", "${stockData['totalInstallments'] ?? '0'} ماہ"),
                _infoRow("حالت:", stockData['status'] ?? 'Active'),
              ],
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  static Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// ہائپر لنک وزٹ (کسی بھی دوسرے پیج پر استعمال کرنے کے لیے)
  static Widget buildStockHyperlink({
    required BuildContext context,
    required String customerPhone,
    String label = "اسٹاک کی تفصیلات دیکھیں",
  }) {
    return InkWell(
      onTap: () => showStockDetailsDialog(context, customerPhone),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}