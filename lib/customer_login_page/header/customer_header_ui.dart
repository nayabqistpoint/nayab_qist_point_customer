import 'package:flutter/material.dart';

class CustomerHeaderUi extends StatelessWidget {
  const CustomerHeaderUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.red[800],
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 8)],
          ),
          child: const CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/my_photo.jpeg'),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'نایاب قسط پوائنٹ',
          style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 8)],
          ),
        ),
      ],
    );
  }
}