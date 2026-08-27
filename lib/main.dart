import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

// 🎯 کسٹمر ایپ کا اپنا درست امپورٹ پاتھ:
import 'package:nayab_qist_point_customer/customer_login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDuo41m3PSRaj0xk4RSuidvjpChTjoM7Qw",
          authDomain: "nayab-qist-point.firebaseapp.com",
          projectId: "nayab-qist-point",
          storageBucket: "nayab-qist-point.firebasestorage.app",
          messagingSenderId: "559470553711",
          appId: "1:559470553711:web:1434ea9e05cc073c633b9a",
          measurementId: "G-33TSZN62T6",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint('Firebase initialization skipped or failed: $e');
  }

  await Hive.initFlutter();

  // 🎯 تمام ضروری ہائیو باکسز کی انیشلائزیشن
  await Hive.openBox('bankBox');
  await Hive.openBox('customerBox');
  await Hive.openBox('expenseBox');
  await Hive.openBox('packageBox');
  await Hive.openBox('stockBox');
  await Hive.openBox('transactionBox');
  await Hive.openBox('usersBox');
  await Hive.openBox('signupRequestsBox');
  await Hive.openBox('purchaseRequestsBox');
  await Hive.openBox('paymentRequestsBox');
  await Hive.openBox('outboxBox'); // 👈 outboxBox (بالکل درست فارمیٹنگ)

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
      // کسٹمر ایپ کا شروعاتی پیج
      home: const CustomerLoginPage(),
    );
  }
}