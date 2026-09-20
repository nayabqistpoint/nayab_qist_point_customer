import 'dart:io' show InternetAddress, SocketException;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  /// ویب، اینڈرائڈ اور آئی او ایس سب کے لیے بلٹ پروف انٹرنیٹ چیک
  static Future<bool> hasInternetConnection() async {
    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      
      // اگر کنکشن 'none' ہے تو یقینی طور پر انٹرنیٹ نہیں ہے
      if (connectivityResults.contains(ConnectivityResult.none)) {
        return false;
      }

      // 🌐 ویب کے لیے: براؤزر کا کنکشن ہی کافی ہے (CORS کا مسئلہ حل)
      if (kIsWeb) {
        return true;
      }

      // 📱 موبائل (Android/iOS) کے لیے: ڈی این ایس لک اپ
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      debugPrint('Connectivity Check Notice: $e');
      // کسی غیر متوقع ایرر کی صورت میں کنیکٹیویٹی پلس کے نتائج پر انحصار
      final results = await Connectivity().checkConnectivity();
      return !results.contains(ConnectivityResult.none);
    }
  }
}