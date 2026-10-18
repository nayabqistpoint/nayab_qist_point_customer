import 'package:flutter/material.dart';

class ShopShowcaseAppBarUi extends StatelessWidget implements PreferredSizeWidget {
  final String shopTitle;
  final String shopSubtitle;

  const ShopShowcaseAppBarUi({
    super.key,
    required this.shopTitle,
    required this.shopSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shopTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
          Text(
            shopSubtitle,
            style: const TextStyle(
              color: Color(0xFFFDE68A),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF0D9488).withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF14B8A6), width: 0.8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(radius: 3.5, backgroundColor: Color(0xFF2DD4BF)),
              SizedBox(width: 5),
              Text(
                'لائیو کاؤنٹر',
                style: TextStyle(color: Color(0xFF5EEAD4), fontSize: 10.5, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}