import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

// 🎯 کنفیگریشن اور سروس امپورٹس
import 'firebase_options.dart';
import 'customer/signup/outbox_sync_service.dart';
import 'package:nayab_qist_point_customer/customer_login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ فائر بیس انیشلائزیشن
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ [Firebase] فائر بیس کامیابی سے انیشلائز ہو گیا۔');
  } catch (e) {
    debugPrint('❌ [Firebase Error] فائر بیس انیشلائزیشن میں مسئلہ: $e');
  }

  // 2️⃣ ہائیو لوکل ڈیٹا بیس انیشلائزیشن
  await Hive.initFlutter();

  // 🎯 تمام ضروری ہائیو باکسز کو اوپن کرنا
  await Hive.openBox('bankBox');
  await Hive.openBox('customerBox');
  await Hive.openBox('guarantorBox');
  await Hive.openBox('expenseBox');
  await Hive.openBox('packageBox');
  await Hive.openBox('stockBox');
  await Hive.openBox('transactionBox');
  await Hive.openBox('usersBox');
  await Hive.openBox('outboxBox');

  // 3️⃣ ایپ سٹارٹ ہوتے ہی پینڈنگ آؤٹ باکس سنکنگ چیک کرنا
  OutboxSyncService().syncNow();

  runApp(const CustomerApp());
}

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نایاب قسط پوائنٹ',
      theme: ThemeData(
        primaryColor: Colors.red[800],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red[800]!,
          primary: Colors.red[800],
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const CustomerLoginPage(),
    );
  }
}