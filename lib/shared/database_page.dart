import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  // 🎯 تمام باکسز (outboxBox کے بالکل درست نام کے ساتھ)
  final List<String> _boxNames = [
    'bankBox',
    'customerBox',
    'expenseBox',
    'packageBox',
    'stockBox',
    'transactionBox',
    'usersBox',
    'signupRequestsBox',
    'purchaseRequestsBox',
    'paymentRequestsBox',
    'outboxBox', // 👈 outbox (چھوٹا b) + Box (بڑا B) = outboxBox
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Database Monitor'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
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
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isOpen ? Colors.teal.shade100 : Colors.grey.shade300,
                  child: Icon(
                    isOpen ? Icons.storage : Icons.storage_outlined,
                    color: isOpen ? Colors.teal : Colors.grey,
                  ),
                ),
                title: Text(
                  boxName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  isOpen ? 'Status: Active ($count Items)' : 'Status: Closed',
                  style: TextStyle(
                    color: isOpen ? Colors.green.shade700 : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.cleaning_services, color: Colors.orange),
                  tooltip: 'Clear Box Data',
                  onPressed: isOpen
                      ? () async {
                          await box?.clear();
                          setState(() {});
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$boxName cleared!')),
                            );
                          }
                        }
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}