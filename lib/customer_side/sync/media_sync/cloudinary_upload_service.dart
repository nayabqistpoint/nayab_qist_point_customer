import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryUploadService {
  static const String cloudName = 'meuimddu';
  static const String uploadPreset = 'xaeqcg0u';

  static Future<String?> uploadFile(String pathOrBlob, {required bool isAudio}) async {
    if (pathOrBlob.isEmpty) return null;

    try {
      // آڈیو کے لیے video ریسورس استعمال ہوتا ہے کلاؤڈینیری میں
      final resourceType = isAudio ? 'video' : 'image';
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/$resourceType/upload');

      final xFile = XFile(pathOrBlob);
      final bytes = await xFile.readAsBytes();

      if (bytes.isEmpty) {
        debugPrint('❌ بائٹس خالی ہیں: $pathOrBlob');
        return null;
      }

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: isAudio ? 'recording.m4a' : 'upload.jpg',
          ),
        );

      debugPrint('🚀 کلاؤڈینیری پر بھیج رہے ہیں (${isAudio ? "Audio" : "Image"})...');

      // ⏱️ 20 سیکنڈ ٹائم آؤٹ تاکہ ایپ کبھی ہینگ نہ ہو
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw Exception('کلاؤڈینیری ٹائم آؤٹ ہو گیا');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final secureUrl = data['secure_url'] as String?;
        debugPrint('✅ کلاؤڈینیری کامیابی: $secureUrl');
        return secureUrl;
      } else {
        debugPrint('❌ کلاؤڈینیری فیل (${response.statusCode}): ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ کلاؤڈینیری استثناء: $e');
      return null;
    }
  }
}