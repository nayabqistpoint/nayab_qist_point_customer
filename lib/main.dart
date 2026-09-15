import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

// 🎯 فائر بیس ویب/اینڈرائیڈ آپشنز اور روٹس امپورٹ
import 'firebase_options.dart';
import 'package:nayab_qist_point_customer/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. فائر بیس انیشلائزیشن مع پلیٹ فارم آپشنز
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Hive ڈیٹا بیس انیشلائزیشن مع بنیادی باکسز
  await Hive.initFlutter();
  await Hive.openBox('settingsBox');
  await Hive.openBox('usersBox');

  runApp(const NayabQistPointCustomerApp());
}

class NayabQistPointCustomerApp extends StatelessWidget {
  const NayabQistPointCustomerApp({super.key});

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
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}