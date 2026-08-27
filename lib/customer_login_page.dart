import 'package:flutter/material.dart';

// 🎯 کسٹمر ایپ کے اپنے درست امپورٹ پاتھس:
import 'package:nayab_qist_point_customer/customer_login_page/header/customer_header_ui.dart';
import 'package:nayab_qist_point_customer/customer_login_page/form/customer_form_ui.dart';
import 'package:nayab_qist_point_customer/customer_login_page/form/customer_form_logic.dart';
import 'package:nayab_qist_point_customer/customer_login_page/contact/customer_contact_ui.dart';
import 'package:nayab_qist_point_customer/customer_login_page/contact/customer_contact_logic.dart';
import 'package:nayab_qist_point_customer/customer_login_page/footer/customer_footer_ui.dart';
import 'package:nayab_qist_point_customer/customer_login_page/footer/customer_footer_logic.dart';

// 🎯 ڈیٹا بیس مانیٹر پیج کا امپورٹ
import 'package:nayab_qist_point_customer/shared/database_page.dart';

class CustomerLoginPage extends StatefulWidget {
  const CustomerLoginPage({super.key});

  @override
  State<CustomerLoginPage> createState() => _CustomerLoginPageState();
}

class _CustomerLoginPageState extends State<CustomerLoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final CustomerFormLogic _formLogic = CustomerFormLogic();
  final CustomerContactLogic _contactLogic = CustomerContactLogic();
  final CustomerFooterLogic _footerLogic = CustomerFooterLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 🖼️ 1. ایچ ڈی بیک گراؤنڈ
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpeg',
              fit: BoxFit.cover,
              alignment: const Alignment(0.0, -0.65),
            ),
          ),

          // 📱 2. مین فارم اور لنکس
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CustomerHeaderUi(),
                    const SizedBox(height: 10),
                    CustomerFormUi(
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                      isPasswordVisible: _isPasswordVisible,
                      rememberMe: _rememberMe,
                      onTogglePasswordVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      onRememberMeChanged: (bool? val) => setState(() => _rememberMe = val ?? false),
                      onFingerprintTap: () => _formLogic.handleFingerprintAuthentication(),
                      onLoginPressed: () => _formLogic.handleLoginSubmission(
                        context,
                        _phoneController,
                        _passwordController,
                      ),
                    ),
                    CustomerContactUi(
                      onCallPressed: () => _contactLogic.makePhoneCall(),
                      onWhatsAppPressed: () => _contactLogic.openWhatsApp(),
                    ),
                    CustomerFooterUi(
                      onSignUpPressed: () => _footerLogic.handleSignUpNavigation(context),
                      onCalculatorPressed: () => _footerLogic.handleCalculatorNavigation(context),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🛠️ 3. عارضی Three Dots Button (ڈیٹا بیس پیج کھولنے کے لیے)
          Positioned(
            top: 40,
            right: 15,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white, size: 28),
              color: Colors.white,
              onSelected: (value) {
                if (value == 'db_monitor') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DatabasePage()),
                  );
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'db_monitor',
                    child: Row(
                      children: [
                        Icon(Icons.storage, color: Colors.teal),
                        SizedBox(width: 10),
                        Text(
                          'Database Monitor',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
    );
  }
}