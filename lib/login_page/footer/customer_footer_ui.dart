import 'package:flutter/material.dart';

class CustomerFooterUi extends StatelessWidget {
  final VoidCallback onSignUpPressed;
  final VoidCallback onCalculatorPressed;

  const CustomerFooterUi({
    super.key,
    required this.onSignUpPressed,
    required this.onCalculatorPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 390),
      child: Column(
        children: [
          // 1. نیا اکاؤنٹ بنائیں
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'اکاؤنٹ نہیں بنا ہوا؟ ',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              GestureDetector(
                onTap: onSignUpPressed,
                child: const Text(
                  'نیا اکاؤنٹ بنائیں',
                  style: TextStyle(
                    color: Colors.yellowAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 2. آن لائن قسط کیلکولیٹر (3D Glass Clickable Button)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onCalculatorPressed,
              borderRadius: BorderRadius.circular(14),
              splashColor: Colors.white24,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red[800],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.calculate, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'آن لائن قسط کیلکولیٹر',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'بغیر لاگ ان کے پیکجز چیک کریں',
                            style: TextStyle(fontSize: 11, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white70),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}