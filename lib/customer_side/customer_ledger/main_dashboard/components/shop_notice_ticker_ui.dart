import 'dart:async';
import 'package:flutter/material.dart';
import '../services/shop_notice_ticker_service.dart';

class ShopNoticeTickerUi extends StatefulWidget {
  const ShopNoticeTickerUi({super.key});

  @override
  State<ShopNoticeTickerUi> createState() => _ShopNoticeTickerUiState();
}

class _ShopNoticeTickerUiState extends State<ShopNoticeTickerUi> {
  late final ScrollController _scrollController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startContinuousScroll());
  }

  void _startContinuousScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 35), (_) {
      if (!_scrollController.hasClients) return;
      final maxExtent = _scrollController.position.maxScrollExtent;
      final currentPos = _scrollController.offset;
      if (currentPos >= maxExtent) {
        _scrollController.jumpTo(0.0);
      } else {
        _scrollController.jumpTo(currentPos + 1.2);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // گہرا لگژری بیک گراؤنڈ جس کے درمیان روشنی (Light Glow) پڑ رہی ہے
        gradient: const RadialGradient(
          center: Alignment(0.2, -0.2),
          radius: 1.8,
          colors: [
            Color(0xFF24334C),
            Color(0xFF0F172A),
            Color(0xFF080D1A),
          ],
          stops: [0.0, 0.65, 1.0],
        ),
        border: Border.all(
          color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => ShopNoticeTickerService.openShowcasePortal(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // مائیکروفون / پلس آئیکن
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF38BDF8), width: 1),
                  ),
                  child: const Icon(
                    Icons.campaign_rounded,
                    size: 16,
                    color: Color(0xFF38BDF8),
                  ),
                ),
                const SizedBox(width: 8),

                // متحرک ٹکر اسکرول
                Expanded(
                  child: SizedBox(
                    height: 20,
                    child: ListView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Center(
                          child: Text(
                            ShopNoticeTickerService.liveTickerText,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF8FAFC),
                              letterSpacing: 0.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black87,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // سنہری ایکشن بٹن
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE68A),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'شیڈول و سرگرمیاں',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 8,
                        color: Color(0xFF0F172A),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}