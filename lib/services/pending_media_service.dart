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

        // صرف زیرِ التواء یا ناکام اپ لوڈز کو ہی پروسیس کریں
        if (currentStatus == 'PENDING_UPLOAD' || currentStatus == 'UPLOAD_FAILED') {
          
          bool hasAnyFailure = false;
          bool hasAnySuccess = false;

          // 1️⃣ سائن اپ اور پرچیز سروسز کے لیے (mediaData)
          if (mediaMap.containsKey('mediaData') &&
              mediaMap['mediaData'] != null &&
              !mediaMap['mediaData'].toString().startsWith('http') &&
              !mediaMap['mediaData'].toString().startsWith('NO_')) {
            
            String? url = await _uploadToCloudinary(
              rawData: mediaMap['mediaData'].toString(),
              resourceType: 'image',
              folder: 'nayab_qist_media/signup',
            );
            if (url != null) {
              mediaMap['mediaData'] = url;
              hasAnySuccess = true;
            } else {
              hasAnyFailure = true;
            }
          }

          // 2️⃣ پے ناؤ کے لیے (pictureData)
          if (mediaMap.containsKey('pictureData') &&
              mediaMap['pictureData'] != null &&
              !mediaMap['pictureData'].toString().startsWith('http') &&
              !mediaMap['pictureData'].toString().startsWith('NO_')) {

            String? url = await _uploadToCloudinary(
              rawData: mediaMap['pictureData'].toString(),
              resourceType: 'image',
              folder: 'nayab_qist_media/paynow_images',
            );
            if (url != null) {
              mediaMap['pictureData'] = url;
              hasAnySuccess = true;
            } else {
              hasAnyFailure = true;
            }
          }

          // 3️⃣ آڈیو نوٹس کے لیے (audioData)
          if (mediaMap.containsKey('audioData') &&
              mediaMap['audioData'] != null &&
              !mediaMap['audioData'].toString().startsWith('http') &&
              !mediaMap['audioData'].toString().startsWith('NO_')) {

            String? url = await _uploadToCloudinary(
              rawData: mediaMap['audioData'].toString(),
              resourceType: 'video', // کلاؤڈ نری آڈیو کے لیے video ٹائپ کا استعمال کرتا ہے
              folder: 'nayab_qist_media/audio_notes',
            );
            if (url != null) {
              mediaMap['audioData'] = url;
              hasAnySuccess = true;
            } else {
              hasAnyFailure = true;
            }
          }

          // 🎯 صرف اس وقت READY_FOR_SYNC کریں جب تمام درکار میڈیا کامیابی سے اپ لوڈ ہو چکے ہوں!
          if (!hasAnyFailure && hasAnySuccess) {
            mediaMap['mediaStatus'] = 'READY_FOR_SYNC';
            mediaMap['isSynced'] = false; // 🟢 اب پش سروس اسے فائر اسٹور پر محفوظ طریقے سے لے جائے گی

            await mBox.put(key, mediaMap);
            debugPrint("🎉 [Media Uploaded & Ready for Push] Key: $key");
          } else if (hasAnyFailure) {
            mediaMap['mediaStatus'] = 'UPLOAD_FAILED';
            mediaMap['isSynced'] = true; // 🔴 جب تک اپ لوڈ مکمل نہ ہو پش سروس کو روک کر رکھیں
            await mBox.put(key, mediaMap);
            debugPrint("⚠️ [Media Upload Failed/Incomplete] Key: $key - Next sync try again.");
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
        // اگر بیس 64 سٹرنگ ہے
        if (rawData.startsWith('data:') || rawData.length > 500) {
          request.fields['file'] = rawData;
        } else {
          // اگر لوکل فائل پاتھ ہے
          io.File file = io.File(rawData);
          if (!await file.exists()) {
            debugPrint("❌ File does not exist at path: $rawData");
            return null;
          }
          request.files.add(await http.MultipartFile.fromPath('file', rawData));
        }
      }

      // 🎯 30 سیکنڈز کا ٹائم آؤٹ تاکہ انٹرنیٹ معطل ہونے پر پروسیس ہینگ نہ ہو
      var streamedResponse = await request.send().timeout(const Duration(seconds: 30));
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