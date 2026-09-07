import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'services/master_pull_service.dart';
import 'services/master_push_sync_service.dart';
import 'customer_login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ فائر بیس انیشلائزیشن
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ [Firebase] فائر بیس انیشلائز ہو گیا۔');
  } catch (e) {
    debugPrint('❌ [Firebase Error] $e');
  }

  // 2️⃣ ہائیو انیشلائزیشن
  await Hive.initFlutter();

  // 🎯 صرف ۴ گلوبل اور غیر مشروط (Unconditional) باکسز یہاں اوپن ہوں گے
  await Future.wait([
    Hive.openBox('appConfigBox'),
    Hive.openBox('stockBox'),
    Hive.openBox('usersBox'),      // آف لائن لاگ ان کے لیے
    Hive.openBox('settingsBox'),   // پرسنل سیٹنگز کے لیے
  ]);

  // 3️⃣ بیک گراؤنڈ سنک لسنرز
  try {
    await MasterLiveSyncService().initPullService();
    await MasterPushSyncService().initAutoPushListener();
  } catch (e) {
    debugPrint('⚠️ [Sync Init Warning] $e');
  }

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