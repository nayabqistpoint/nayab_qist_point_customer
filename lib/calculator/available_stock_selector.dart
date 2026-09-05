import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AvailableStockSelectorWidget extends StatefulWidget {
  const AvailableStockSelectorWidget({super.key});

  @override
  State<AvailableStockSelectorWidget> createState() => _AvailableStockSelectorWidgetState();
}

class _AvailableStockSelectorWidgetState extends State<AvailableStockSelectorWidget> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75, // سکرین کا 75 فیصد حصہ
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. ہیڈر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'دستیاب اسٹاک سے منتخب کریں',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),

          // 2. تلاش (Search Bar - درست اردو RTL ترتیب)
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'نام یا آئی ایم ای آئی سے تلاش کریں...',
                hintStyle: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val.trim().toLowerCase();
                });
              },
            ),
          ),
          const SizedBox(height: 12),

          // 3. لائیو ہائیو اسٹاک لسٹ
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box('stockBox').listenable(),
              builder: (context, Box box, _) {
                final availableItems = box.values.where((element) {
                  if (element is! Map) return false;
                  final status = element['status']?.toString() ?? 'available';
                  if (status != 'available') return false;

                  if (searchQuery.isEmpty) return true;

                  final name = element['itemName']?.toString().toLowerCase() ?? '';
                  final imei = element['imeiNo']?.toString().toLowerCase() ?? '';
                  return name.contains(searchQuery) || imei.contains(searchQuery);
                }).toList();

                if (availableItems.isEmpty) {
                  return const Center(
                    child: Text('کوئی دستیاب اسٹاک نہیں ملا', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  );
                }

                return ListView.separated(
                  itemCount: availableItems.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = Map<String, dynamic>.from(availableItems[index] as Map);

                    final String name = item['itemName'] ?? 'نامعلوم';
                    final String imei = item['imeiNo'] ?? 'کوئی IMEI نہیں';
                    final String ram = item['ram']?.toString() ?? '';
                    final String rom = item['rom']?.toString() ?? '';
                    final String cond = item['condition']?.toString() == 'new' ? 'نیا' : 'پرانا';
                    final String war = '${item['warranty'] ?? 0} ماہ وارنٹی';
                    final String price = item['salePrice']?.toString() ?? '0';

                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 18,
                          child: Icon(Icons.phone_android, color: Colors.white, size: 18),
                        ),
                        // نام اور بائیں جانب مدہم IMEI
                        title: Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Colors.black87),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            'IMEI: $imei',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
                          ),
                        ),
                        // 🟢 دائیں جانب: مکمل سینٹر الائنڈ RAM/ROM کیپسول اور وارنٹی
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center, // 👈 مکمل طور پر سینٹر الائن کر دیا گیا ہے
                          children: [
                            // 1. RAM / ROM کیپسول
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue.shade200, width: 0.8),
                              ),
                              child: Text(
                                ram.isNotEmpty ? '$ram / $rom' : 'N/A',
                                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 3),
                            // 2. باریک لکیر (Divider)
                            SizedBox(
                              width: 70,
                              child: Divider(height: 1, thickness: 0.6, color: Colors.grey.shade300),
                            ),
                            const SizedBox(height: 3),
                            // 3. نیا/پرانا اور وارنٹی (کیپسول کے بالکل سینٹر میں)
                            Text(
                              '$cond | $war',
                              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.black.withValues(alpha: 0.7)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context, {
                            'mobileName': name,
                            'imeiNo': imei,
                            'salePrice': price,
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}