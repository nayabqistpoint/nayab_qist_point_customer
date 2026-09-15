import 'package:flutter/material.dart';
import 'package:nayab_qist_point_customer/database_page.dart';
import 'customer_login_controller.dart';
import 'components/login_header_ui.dart';
import 'components/login_form_ui.dart';
import 'components/login_contact_support_ui.dart';
import 'components/login_footer_ui.dart';

class CustomerLoginPage extends StatefulWidget {
  const CustomerLoginPage({super.key});

  @override
  State<CustomerLoginPage> createState() => _CustomerLoginPageState();
}

class _CustomerLoginPageState extends State<CustomerLoginPage> {
  late final CustomerLoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CustomerLoginController();
    _controller.initSavedCredentials();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpeg',
              fit: BoxFit.cover,
              alignment: const Alignment(0.0, -0.65),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const LoginHeaderUi(),
                        const SizedBox(height: 10),
                        LoginFormUi(controller: _controller),
                        LoginContactSupportUi(
                          onCallPressed: _controller.makeCall,
                          onWhatsAppPressed: _controller.openWhatsApp,
                        ),
                        LoginFooterUi(
                          onSignUpPressed: () => _controller.navigateToSignUp(context),
                          onCalculatorPressed: () => _controller.navigateToCalculator(context),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
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
                    MaterialPageRoute(builder: (_) => const DatabasePage()),
                  );
                }
              },
              itemBuilder: (context) => [
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}