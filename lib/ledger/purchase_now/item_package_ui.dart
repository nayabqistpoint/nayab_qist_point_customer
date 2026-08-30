import 'package:flutter/material.dart';

// 🎯 سٹرکچر کے مطابق درست امپورٹ پاتھس:
import 'package:nayab_qist_point_customer/calculator/installment_calculator_page.dart';
import 'package:nayab_qist_point_customer/ledger/purchase_now/item_package_logic.dart';
import 'package:nayab_qist_point_customer/shared_widgets/imei_details_dialog.dart';
import 'package:nayab_qist_point_customer/shared_widgets/audio_record_player_widget.dart';

class ItemPackageUI extends StatefulWidget {
  const ItemPackageUI({super.key});

  @override
  State<ItemPackageUI> createState() => ItemPackageUIState();
}

class ItemPackageUIState extends State<ItemPackageUI> with AutomaticKeepAliveClientMixin {
  late final ItemPackageLogic _logic;
  
  // آڈیو کا پاتھ Reusable AudioRecordPlayerWidget سے آئے گا
  String? _audioPath;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _logic = ItemPackageLogic();
  }

  /// پیرنٹ یا سائن ان پیج کی مطابقت کے لیے محفوظ ہیلپر فنکشن
  void setPurchaseRequested(bool value) {
    // فارم اب مستقل آن رہتا ہے
  }

  /// 🎯 صاف ستھرا پے لوڈ ڈیٹا (isPurchaseRequested ختم کر دیا گیا ہے)
  Map<String, dynamic> getPackageData() {
    return {
      'hasAudioRecorded': _audioPath != null && _audioPath!.isNotEmpty,
      'audioPath': _audioPath,
      ..._logic.getPackageData(),
    };
  }

  void _openCalculator(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InstallmentCalculaterPage(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _logic.updatePackageData(
          name: result['mobileName'] ?? '',
          pkgName: result['packageName'] ?? '',
          cash: result['cashPrice'] ?? '',
          advance: result['advanceAmount'] ?? '',
          installment: result['monthlyInstallment'] ?? '',
          total: result['totalPrice'] ?? '',
          buyStock: result['isBuyStockMode'] ?? false,
          stockImei: result['imei'],
          chqNumber: result['checkNumber'],
          bnkName: result['bankName'],
        );
      });
    }
  }

  // --- ڈائنامک IMEI / نقد قیمت باکس ---
  Widget _buildDynamicPriceOrImeiBox({required bool hasImei, required String cashPrice, required String? imei}) {
    if (hasImei && imei != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.amber.shade300, width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('IMEI نمبر:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
            Flexible(
              child: InkWell(
                onTap: () => showImeiDetailsDialog(context, imei),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.link, size: 14, color: Colors.blue),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        imei,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return _buildBox('نقد قیمت:', cashPrice.isEmpty ? '0' : cashPrice);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final String modelName = _logic.mobileName ?? '';
    final String packageName = _logic.packageName ?? '';
    final String cashPrice = _logic.cashPrice ?? '';
    final String advanceAmount = _logic.advanceAmount ?? '';
    final String monthlyInstallment = _logic.monthlyInstallment ?? '';
    final String totalPrice = _logic.totalPrice ?? '';
    
    final String? imei = _logic.imei;
    final String? checkNumber = _logic.checkNumber;
    final String? bankName = _logic.bankName;

    bool hasImei = (imei != null && imei.isNotEmpty);
    bool hasCheckOrBank = (checkNumber != null && checkNumber.isNotEmpty) || (bankName != null && bankName.isNotEmpty);

    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'آئٹم اور پیکج کی معلومات',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(
                  height: 36,
                  child: ElevatedButton.icon(
                    onPressed: () => _openCalculator(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[800],
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.calculate, size: 16),
                    label: const Text('قسط کیلکولیٹر کھولیں', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),

            Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildBox('ماڈل:', modelName == 'N/A' || modelName.isEmpty ? 'منتخب کریں' : modelName)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildBox('پیکج:', packageName == 'N/A' || packageName.isEmpty ? 'منتخب کریں' : packageName)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildDynamicPriceOrImeiBox(
                        hasImei: hasImei,
                        cashPrice: cashPrice,
                        imei: imei,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: _buildBox('ایڈوانس:', advanceAmount.isEmpty ? '0' : advanceAmount)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildBox('ماہانہ قسط:', monthlyInstallment.isEmpty ? '0' : monthlyInstallment)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildBox('کل ادھار قیمت:', totalPrice.isEmpty ? '0' : totalPrice, isTotal: true)),
                  ],
                ),
                if (hasCheckOrBank) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (checkNumber != null && checkNumber.isNotEmpty)
                        Expanded(child: _buildBox('چیک نمبر:', checkNumber, isSpecial: true))
                      else
                        const Spacer(),
                      if (checkNumber != null && checkNumber.isNotEmpty && bankName != null && bankName.isNotEmpty) const SizedBox(width: 8),
                      if (bankName != null && bankName.isNotEmpty)
                        Expanded(child: _buildBox('بینک کا نام:', bankName, isSpecial: true))
                      else
                        const Spacer(),
                    ],
                  ),
                ],
              ],
            ),
            
            const SizedBox(height: 14),
            const Divider(color: Colors.redAccent, thickness: 1.2),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade200, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'قانونی تصدیق (لازمی آڈیو اعتراف):',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'موبائل ماڈل، ایڈوانس اور قسط کی رقم بول کر وائس ریکارڈ لازمی کریں تاکہ ریکوئسٹ جمع ہو سکے۔',
                    style: TextStyle(fontSize: 10, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: AudioRecordPlayerWidget(
                      onAudioChanged: (audioPath) {
                        setState(() {
                          _audioPath = audioPath;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBox(String label, String value, {bool isTotal = false, bool isSpecial = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isTotal ? Colors.red.shade50 : (isSpecial ? Colors.amber.shade50 : Colors.grey.shade50),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isTotal ? Colors.red.shade200 : (isSpecial ? Colors.amber.shade300 : Colors.grey.shade300),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isTotal ? Colors.red[800] : (isSpecial ? Colors.brown.shade800 : Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}