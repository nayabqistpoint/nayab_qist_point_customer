import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

// 🎯 کنفیگریشن اور سروس امپورٹس
import 'firebase_options.dart';
import 'services/master_pull_service.dart';
import 'services/master_push_sync_service.dart'; // 👈 پش سروس کا امپورٹ
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

  // 🎯 صرف مطلوبہ باکسز کو اوپن کرنا
  await Hive.openBox('customerBox');
  await Hive.openBox('guarantorBox');
  await Hive.openBox('packageBox');
  await Hive.openBox('stockBox');
  await Hive.openBox('transactionBox');
  await Hive.openBox('usersBox');
  await Hive.openBox('settingsBox');

  // 3️⃣ بیک گراؤنڈ لائیو سنک سروسز (Pull + Push) کو ریڈی رکھنا
  MasterLiveSyncService().startMasterLiveSync();
  await MasterPushSyncService().initAutoPushListener(); // 👈 پش لسنر ایکٹیو ہو گیا

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