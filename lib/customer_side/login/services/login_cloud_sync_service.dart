import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nayab_qist_point_customer/customer_side/login/services/login_storage_handler.dart';

class LoginCloudSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> syncUserFromCloud(String cleanPhone) async {
    try {
      final docSnap = await _firestore
          .collection('usersBox')
          .doc(cleanPhone)
          .get()
          .timeout(const Duration(seconds: 4));

      if (docSnap.exists && docSnap.data() != null) {
        final cloudData = Map<String, dynamic>.from(docSnap.data()!);
        await LoginStorageHandler.saveCloudUserLocally(
          phone: cleanPhone,
          userData: cloudData,
        );
        return true;
      }
    } catch (_) {}
    return false;
  }
}