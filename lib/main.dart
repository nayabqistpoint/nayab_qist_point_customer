import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// 🎯 فائر بیس ویب/اینڈرائیڈ آپشنز اور روٹس امپورٹ
import 'firebase_options.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';

// 🎯 کسٹمر ہائیو باکس منیجر کا امپورٹ
import 'package:nayab_qist_point_customer/customer_side/hive_services/hive_box_manager.dart';

// 🎯 سنک ہب کا واحد امپورٹ
import 'package:nayab_qist_point_customer/customer_side/sync/master_sync_hub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. فائر بیس انیشلائزیشن مع پلیٹ فارم آپشنز
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Hive ڈیٹا بیس کا گلوبل آغاز (باکس منیجر کے ذریعے)
  await HiveBoxManager.initGlobalBoxes();

  // 🚀 گلوبل مرر سنک (اسٹاک اور ایپ کنفگ لائیو لسنرز شروع کرنا)
  MasterSyncHub.syncGlobalDataOnBoot();

  // 3. سیشن چیک: کیا صارف پہلے سے لاگ ان ہے؟
  final settingsBox = await HiveBoxManager.openSafeBox(HiveBoxManager.settingsBoxName);
  final bool isLoggedIn = settingsBox.get('isLoggedIn', defaultValue: false);
  final String? activePhone = settingsBox.get('activePhone');

  String startRoute = AppRoutes.login;

  if (isLoggedIn && activePhone != null && activePhone.isNotEmpty) {
    // 🎯 پرماننٹ ڈسک سے تمام سیشن باکسز کو لازمی کھولیں (چاہے نیٹ ہو یا نہ ہو)
    await HiveBoxManager.openSessionBoxes();
    
    // 🔄 کسٹمر کا مکمل سنک: آف لائن موڈ چیک کر کے لائیو سنک شروع کرے گا
    MasterSyncHub.syncCustomerSession(customerPhone: activePhone);

    startRoute = AppRoutes.ledger; // آپ کا لیجر روٹ
  }

  runApp(NayabQistPointCustomerApp(
    initialRoute: startRoute,
    activePhone: activePhone,
  ));
}

class NayabQistPointCustomerApp extends StatelessWidget {
  final String initialRoute;
  final String? activePhone;

  const NayabQistPointCustomerApp({
    super.key,
    required this.initialRoute,
    this.activePhone,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نایاب قسط پوائنٹ کسٹمر',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Jameel Noori Nastaleeq',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF059669),
          brightness: Brightness.light,
        ),
      ),
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.ledger && settings.arguments == null) {
          return AppRoutes.onGenerateRoute(
            RouteSettings(
              name: AppRoutes.ledger,
              arguments: {'customerPhone': activePhone},
            ),
          );
        }
        return AppRoutes.onGenerateRoute(settings);
      },
    );
  }
}