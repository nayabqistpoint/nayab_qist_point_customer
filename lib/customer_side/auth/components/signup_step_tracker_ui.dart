import 'package:flutter/material.dart';

class SignupStepTrackerUi extends StatelessWidget {
  final int currentStep;
  final ValueChanged<int> onStepTapped;

  const SignupStepTrackerUi({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'title': 'کسٹمر کوائف', 'icon': Icons.person_rounded},
      {'title': 'دستاویزات', 'icon': Icons.camera_front_rounded},
      {'title': 'ضامن و اقرار', 'icon': Icons.gavel_rounded},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Row(
          children: List.generate(steps.length, (idx) {
            final bool isDone = currentStep > idx;
            final bool isActive = currentStep == idx;

            Color bgColor = Colors.white;
            if (isActive) {
              bgColor = const Color(0xFF059669);
            } else if (isDone) {
              bgColor = const Color(0xFFECFDF5);
            }

            final Color textColor = isActive
                ? Colors.white
                : (isDone ? const Color(0xFF065F46) : const Color(0xFF64748B));

            return Expanded(
              child: InkWell(
                onTap: () => onStepTapped(idx),
                child: CustomPaint(
                  painter: _WhiteChevronPainter(
                    isFirst: idx == 0,
                    isLast: idx == steps.length - 1,
                    fillColor: bgColor,
                    borderColor: isActive ? const Color(0xFFFDE68A) : const Color(0xFFCBD5E1),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 2),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isDone)
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFF059669),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, size: 10, color: Colors.white),
                          )
                        else
                          Icon(
                            steps[idx]['icon'] as IconData,
                            size: 13,
                            color: isActive ? const Color(0xFFFDE68A) : const Color(0xFF94A3B8),
                          ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            steps[idx]['title'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: (isActive || isDone) ? FontWeight.w900 : FontWeight.bold,
                              color: textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _WhiteChevronPainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final Color fillColor;
  final Color borderColor;

  _WhiteChevronPainter({
    required this.isFirst,
    required this.isLast,
    required this.fillColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    const arrowWidth = 8.0;

    if (isFirst) {
      path.moveTo(size.width, 0);
      path.lineTo(arrowWidth, 0);
      path.lineTo(0, size.height / 2);
      path.lineTo(arrowWidth, size.height);
      path.lineTo(size.width, size.height);
      path.close();
    } else if (isLast) {
      path.moveTo(size.width, 0);
      path.lineTo(size.width - arrowWidth, size.height / 2);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(0, 0);
      path.close();
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width - arrowWidth, size.height / 2);
      path.lineTo(size.width, size.height);
      path.lineTo(arrowWidth, size.height);
      path.lineTo(0, size.height / 2);
      path.lineTo(arrowWidth, 0);
      path.close();
    }

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _WhiteChevronPainter oldDelegate) =>
      oldDelegate.fillColor != fillColor ||
      oldDelegate.isFirst != isFirst ||
      oldDelegate.isLast != isLast ||
      oldDelegate.borderColor != borderColor;
}