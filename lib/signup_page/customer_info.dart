import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomerInfoWidget extends StatefulWidget {
  const CustomerInfoWidget({super.key});

  @override
  State<CustomerInfoWidget> createState() => CustomerInfoWidgetState();
}

class CustomerInfoWidgetState extends State<CustomerInfoWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController casteController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? customerSelfiePath;

  @override
  void dispose() {
    nameController.dispose();
    fatherNameController.dispose();
    casteController.dispose();
    phoneController.dispose();
    cnicController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Map<String, dynamic> getCustomerData() {
    return {
      'customerName': nameController.text.trim(),
      'customerFatherName': fatherNameController.text.trim(),
      'customerCaste': casteController.text.trim(),
      'customerPhone': phoneController.text.trim(),
      'customerCnic': cnicController.text.trim(),
      'customerAddress': addressController.text.trim(),
      'customerSelfie': customerSelfiePath ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Text(
                'کسٹمر کی ذاتی معلومات',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const Divider(height: 16),
            const SizedBox(height: 4),

            _buildTextField(controller: nameController, label: 'کسٹمر کا پورا نام', icon: Icons.person),
            const SizedBox(height: 12),
            _buildTextField(controller: fatherNameController, label: 'والد / شوہر کا نام', icon: Icons.person_outline),
            const SizedBox(height: 12),
            _buildTextField(controller: casteController, label: 'قوم', icon: Icons.group),
            const SizedBox(height: 12),
            _buildTextField(controller: phoneController, label: 'موبائل نمبر', icon: Icons.phone, keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            _buildTextField(controller: cnicController, label: 'شناختی کارڈ نمبر (CNIC)', icon: Icons.credit_card, keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            _buildTextField(controller: addressController, label: 'گھر کا پتہ', icon: Icons.home),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        customerSelfiePath != null ? Icons.check_circle : Icons.camera_alt,
                        color: customerSelfiePath != null ? Colors.green : Colors.red[800],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        customerSelfiePath != null ? 'کسٹمر کی سیلفی محفوظ ہے' : 'کسٹمر کی لائیو سیلفی لیں',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: customerSelfiePath != null ? Colors.green.shade700 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final XFile? photo = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                        preferredCameraDevice: CameraDevice.front,
                        imageQuality: 80,
                      );
                      if (photo != null) {
                        String formattedData = '';
                        if (kIsWeb) {
                          // 🌐 blob: کی جگہ Base64
                          final bytes = await photo.readAsBytes();
                          formattedData = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                        } else {
                          // 📱 اینڈرائیڈ ڈیوائس فائل پاتھ
                          formattedData = photo.path;
                        }

                        setState(() {
                          customerSelfiePath = formattedData;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customerSelfiePath != null ? Colors.green : Colors.red[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: Icon(customerSelfiePath != null ? Icons.done : Icons.camera, size: 16),
                    label: Text(customerSelfiePath != null ? 'دوبارہ لیں' : 'تصویر لیں', style: const TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'یہ خانہ خالی نہیں چھوڑ سکتے';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.red[800], size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}