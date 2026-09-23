import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class LocalMediaHelper {
  /// بنی بنائی فائل کو کیشے سے پرمننٹ میموری میں منتقل کرنا
  static Future<String> savePermanently(String tempPath, {required String subFolder}) async {
    // 🌐 اگر براؤزر (Web) پر چل رہا ہو تو فائل سسٹم بائی پاس کریں
    if (kIsWeb) {
      debugPrint('🌐 Web Environment: Skipping local file system storage');
      return tempPath;
    }

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final targetFolder = Directory('${appDir.path}/$subFolder');

      if (!await targetFolder.exists()) {
        await targetFolder.create(recursive: true);
      }

      final ext = tempPath.contains('.') ? '.${tempPath.split('.').last}' : '.jpg';
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$ext';
      final targetPath = '${targetFolder.path}/$fileName';

      final savedFile = await File(tempPath).copy(targetPath);
      return savedFile.path;
    } catch (e) {
      debugPrint('❌ LocalMediaHelper Error: $e');
      return tempPath;
    }
  }
}