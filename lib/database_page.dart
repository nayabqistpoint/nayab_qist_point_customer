import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  // 🎯 فعال باکسز کی فہرست (bankBox, expenseBox, outboxBox کی جگہ settingsBox شامل)
  final List<String> _boxNames = [
    'customerBox',
    'guarantorBox',
    'packageBox',
    'stockBox',
    'transactionBox',
    'usersBox',
    'settingsBox', // 👈 انسپکٹر میں لوکل سیٹنگز مانیٹر کرنے کے لیے
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Hive DB Inspector', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: _boxNames.length,
          itemBuilder: (context, index) {
            final boxName = _boxNames[index];
            final isOpen = Hive.isBoxOpen(boxName);
            final box = isOpen ? Hive.box(boxName) : null;
            final count = box?.length ?? 0;

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: count > 0 ? Colors.teal.shade100 : Colors.grey.shade200,
                  child: Icon(
                    count > 0 ? Icons.folder_special : Icons.folder_open,
                    color: count > 0 ? Colors.teal.shade800 : Colors.grey,
                  ),
                ),
                title: Text(
                  boxName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: count > 0 ? Colors.green.shade100 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$count Items',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: count > 0 ? Colors.green.shade900 : Colors.grey.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isOpen ? 'Active' : 'Closed',
                        style: TextStyle(fontSize: 12, color: isOpen ? Colors.green : Colors.red),
                      ),
                    ],
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isOpen && count > 0)
                      IconButton(
                        icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                        tooltip: 'Clear All Data',
                        onPressed: () => _confirmClearBox(boxName, box),
                      ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
                onTap: isOpen && count > 0 ? () => _showBoxDataDetails(boxName, box!) : null,
              ),
            );
          },
        ),
      ),
    );
  }

  void _showBoxDataDetails(String boxName, Box box) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final keys = box.keys.toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '📦 $boxName (${keys.length})',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal.shade900),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: keys.isEmpty
                        ? const Center(child: Text('یہ باکس بالکل خالی ہے'))
                        : ListView.builder(
                            itemCount: keys.length,
                            itemBuilder: (context, index) {
                              final key = keys[index];
                              final data = box.get(key);

                              String prettyJson = '';
                              try {
                                prettyJson = const JsonEncoder.withIndent('  ').convert(data);
                              } catch (e) {
                                prettyJson = data.toString();
                              }

                              return Card(
                                color: Colors.grey.shade50,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                                child: ExpansionTile(
                                  leading: const Icon(Icons.vpn_key, color: Colors.teal),
                                  title: Text(
                                    'Doc ID / Key: $key',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                    onPressed: () async {
                                      await box.delete(key);
                                      setModalState(() {});
                                      setState(() {});
                                    },
                                  ),
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      color: Colors.black87,
                                      child: SelectableText(
                                        prettyJson,
                                        style: const TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 11,
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmClearBox(String boxName, Box? box) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('$boxName صاف کریں؟'),
        content: const Text('کیا آپ واقعی اس باکس کا تمام لوکل ڈیٹا مٹانا چاہتے ہیں؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('کینسل')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await box?.clear();
              if (!mounted) return;
              setState(() {});
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('صاف کریں', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}