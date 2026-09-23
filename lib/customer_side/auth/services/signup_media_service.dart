import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/media_picker_service.dart';

class SignupMediaService {
  String cnicFront = '';
  String cnicBack = '';
  String selfie = '';
  String gCnicFront = '';
  String gCnicBack = '';

  Future<void> pickDoc(String key, {required VoidCallback onUpdate}) async {
    final path = await MediaPickerService.pickDocument(
      source: ImageSource.camera,
      subFolder: 'customer_media',
    );
    if (path == null) {
      return;
    }

    if (key == 'cnicFront') {
      cnicFront = path;
    } else if (key == 'cnicBack') {
      cnicBack = path;
    } else if (key == 'gCnicFront') {
      gCnicFront = path;
    } else if (key == 'gCnicBack') {
      gCnicBack = path;
    }
    onUpdate();
  }

  Future<void> pickSelfie({required VoidCallback onUpdate}) async {
    final path = await MediaPickerService.pickSelfie(subFolder: 'customer_media');
    if (path != null) {
      selfie = path;
      onUpdate();
    }
  }
}