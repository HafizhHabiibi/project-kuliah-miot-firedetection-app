import 'package:flutter/material.dart';
import 'dart:math' as math;

class SmokeLevelGauge extends StatelessWidget {
  final String smokeLevel;

  const SmokeLevelGauge({
    super.key,
    required this.smokeLevel,
  });

  Color _getStatusColor() {
    switch (smokeLevel) {
      case 'Rendah':
        return const Color(0xFF4CAF50); // Green
      case 'Normal':
        return const Color(0xFF34D399); // Teal-Green
      case 'Sedang':
        return const Color(0xFFF59E0B); // Orange
      case 'Tinggi':
        return const Color(0xFFE24B4A); // Red
      default:
        return const Color(0xFF8888AA);
    }
  }

  Color _getBgStatusColor() {
    switch (smokeLevel) {
      case 'Rendah':
        return const Color(0xFF1D3A1D);
      case 'Normal':
        return const Color(0xFF1E3A2F);
      case 'Sedang':
        return const Color(0xFF2D2200);
      case 'Tinggi':
        return const Color(0xFF2D1010);
      default:
        return const Color(0xFF252540);
    }
  }

  double _getPointerAngle() {
    // Rendah: ~202.5 degrees (pointing bottom-left)
    // Normal: ~247.5 degrees (pointing top-left)
    // Sedang: ~292.5 degrees (pointing top-right)
    // Tinggi: ~337.5 degrees (pointing bottom-right)
    switch (smokeLevel) {
      case 'Rendah':
        return math.pi + (math.pi / 8);
      case 'Normal':
        return math.pi + (3 * math.pi / 8);
      case 'Sedang':
        return math.pi + (5 * math.pi / 8);
      case 'Tinggi':
        return math.pi + (7 * math.pi / 8);
      default:
        return math.pi + (math.pi / 8);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final bgStatusColor = _getBgStatusColor();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252540),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TINGKAT ASAP (MQ-2)',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF8888AA),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 180,
              height: 100,
              child: CustomPaint(
                painter: _SmokeGaugePainter(
                  needleAngle: _getPointerAngle(),
                  activeColor: statusColor,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          smokeLevel.toUpperCase(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Text(
                          'Tingkat Asap',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF8888AA),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: bgStatusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: statusColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    smokeLevel == 'Tinggi' || smokeLevel == 'Sedang'
                        ? 'Waspada Asap!'
                        : 'Udara Aman',
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmokeGaugePainter extends CustomPainter {
  final double needleAngle;
  final Color activeColor;

  _SmokeGaugePainter({
    required this.needleAngle,
    required this.activeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height - 10;
    final radius = size.width / 2 - 10;
    final strokeWidth = 10.0;

    final Rect rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);

    // Draw 4 segments of the arc
    // Segment 1: Rendah (Green)
    canvas.drawArc(
      rect,
      math.pi,
      math.pi / 4,
      false,
      Paint()
        ..color = const Color(0xFF4CAF50).withAlpha((0.25 * 255).toInt())
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
    // Segment 2: Normal (Teal)
    canvas.drawArc(
      rect,
      math.pi + (math.pi / 4),
      math.pi / 4,
      false,
      Paint()
        ..color = const Color(0xFF34D399).withAlpha((0.25 * 255).toInt())
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
    // Segment 3: Sedang (Orange)
    canvas.drawArc(
      rect,
      math.pi + (math.pi / 2),
      math.pi / 4,
      false,
      Paint()
        ..color = const Color(0xFFF59E0B).withAlpha((0.25 * 255).toInt())
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
    // Segment 4: Tinggi (Red)
    canvas.drawArc(
      rect,
      math.pi + (3 * math.pi / 4),
      math.pi / 4,
      false,
      Paint()
        ..color = const Color(0xFFE24B4A).withAlpha((0.25 * 255).toInt())
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Active color arc highlight up to needle angle
    final sweepAngle = (needleAngle - math.pi).clamp(0.0, math.pi);
    canvas.drawArc(
      rect,
      math.pi,
      sweepAngle,
      false,
      Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Draw needle pin center
    final pinPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), 6, pinPaint);

    final outerPinPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(cx, cy), 6, outerPinPaint);

    // Draw pointer needle line pointing to the angle
    final needleLength = radius - 15;
    final targetX = cx + needleLength * math.cos(needleAngle);
    final targetY = cy + needleLength * math.sin(needleAngle);

    final needlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(cx, cy), Offset(targetX, targetY), needlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
