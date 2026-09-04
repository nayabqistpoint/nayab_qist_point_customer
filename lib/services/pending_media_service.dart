import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class PendingMediaService {
  static const String _cloudName = 'meuimddu';
  static const String _uploadPreset = 'xaeqcg0u';

  /// 🎯 mediaBox کو پروسیس کر کے Cloudinary URL حاصل کرنا
  static Future<void> processPendingMedia() async {
    try {
      if (!Hive.isBoxOpen('mediaBox')) {
        await Hive.openBox('mediaBox');
      }
      var mBox = Hive.box('mediaBox');

      if (mBox.isEmpty) return;

      debugPrint("🚀 [PendingMediaService]: mediaBox کا جائزہ لیا جا رہا ہے...");

      for (var key in mBox.keys) {
        var rawData = mBox.get(key);
        if (rawData == null) continue;

        Map<String, dynamic> mediaMap = Map<String, dynamic>.from(rawData as Map);
        String? currentStatus = mediaMap['mediaStatus'];
        String? rawMediaData = mediaMap['mediaData'];
        String category = (mediaMap['category'] ?? 'general').toString();

        // 🎯 صرف انہی ریکارڈز کو اپ لوڈ کریں جو PENDING_UPLOAD ہیں
        if (currentStatus == 'PENDING_UPLOAD' &&
            rawMediaData != null &&
            rawMediaData.isNotEmpty &&
            !rawMediaData.startsWith('http')) {

          debugPrint("⏳ Uploading Base64 ($category) for Key: $key ...");

          String resourceType = (category.contains('audio') || category.contains('video'))
              ? 'video'
              : 'image';

          String? downloadUrl = await _uploadToCloudinary(
            rawData: rawMediaData,
            resourceType: resourceType,
            folder: 'nayab_qist_media/$category',
          );

          if (downloadUrl != null && downloadUrl.isNotEmpty) {
            // 1️⃣ لوکل mediaBox میں Base64 کو کلاؤڈ نری کے شارٹ URL سے اوور رائٹ کریں
            mediaMap['mediaData'] = downloadUrl;
            mediaMap['mediaStatus'] = 'READY_FOR_SYNC';
            mediaMap['isSynced'] = false; // 🟢 مرکزی پش سروس کے لیے سگنل (Ready to Push)

            await mBox.put(key, mediaMap);

            debugPrint("🎉 [Cloudinary Link Saved]: $downloadUrl for Key: $key");
          }
        }
      }
    } catch (e) {
      debugPrint("❌ [PendingMediaService Error]: $e");
    }
  }

  /// 🎯 Cloudinary API پے لوڈ
  static Future<String?> _uploadToCloudinary({
    required String rawData,
    required String resourceType,
    required String folder,
  }) async {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/$resourceType/upload');
      var request = http.MultipartRequest('POST', url);

      request.fields['upload_preset'] = _uploadPreset;
      request.fields['folder'] = folder;

      if (kIsWeb) {
        request.fields['file'] = rawData;
      } else {
        if (rawData.startsWith('data:') || rawData.length > 500) {
          request.fields['file'] = rawData;
        } else {
          io.File file = io.File(rawData);
          if (!await file.exists()) return null;
          request.files.add(await http.MultipartFile.fromPath('file', rawData));
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return responseData['secure_url'];
      } else {
        debugPrint("Cloudinary Upload Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Cloudinary Upload Exception: $e");
      return null;
    }
  }
}