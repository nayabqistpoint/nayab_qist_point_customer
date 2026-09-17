import 'package:cloud_firestore/cloud_firestore.dart';
import '../../hive_services/hive_box_manager.dart';

class LoginCloudSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// کلاؤڈ فائر اسٹور سے یوزر کا تازہ ریکارڈ لا کر لوکل کیشے میں ڈالنا
  Future<bool> syncUserFromCloud(String cleanPhone) async {
    try {
      final docSnap = await _firestore
          .collection('usersBox')
          .doc(cleanPhone)
          .get()
          .timeout(const Duration(seconds: 4));

      if (docSnap.exists && docSnap.data() != null) {
        final cloudData = Map<String, dynamic>.from(docSnap.data()!);
        final usersBox = await HiveBoxManager.openSafeBox(HiveBoxManager.usersBoxName);
        await usersBox.put(cleanPhone, cloudData);
        return true;
      }
    } catch (_) {
      // نیٹ ورک نہ ہونے پر بغیر کریش ہوئے فال بیک
    }
    return false;
  }
}