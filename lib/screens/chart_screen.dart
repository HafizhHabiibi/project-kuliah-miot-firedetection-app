import 'package:flutter/material.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RIWAYAT DATA',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF8888AA),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          _ChartCard(
            title: 'Suhu (°C)',
            color: const Color(0xFFE24B4A),
            points: const [30.1, 30.5, 31.0, 31.2, 30.8, 31.5, 31.2],
          ),
          const SizedBox(height: 10),
          _ChartCard(
            title: 'Kelembaban (%)',
            color: const Color(0xFF5D9CF5),
            points: const [72.0, 74.5, 75.0, 76.6, 77.0, 76.0, 76.6],
          ),
          const SizedBox(height: 10),
          _ChartCard(
            title: 'Kualitas Udara (ppm)',
            color: const Color(0xFF4CAF50),
            points: const [380, 390, 405, 400, 395, 410, 400],
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Color color;
  final List<double> points;

  const _ChartCard({
    required this.title,
    required this.color,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final minVal = points.reduce((a, b) => a < b ? a : b);
    final maxVal = points.reduce((a, b) => a > b ? a : b);
    final latest = points.last;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252540),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                latest % 1 == 0
                    ? latest.toInt().toString()
                    : latest.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: CustomPaint(
              painter: _LinePainter(points: points, color: color),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Min: $minVal',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8888AA),
                ),
              ),
              Text(
                'Max: $maxVal',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8888AA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<double> points;
  final Color color;

  _LinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final minVal = points.reduce((a, b) => a < b ? a : b);
    final maxVal = points.reduce((a, b) => a > b ? a : b);
    final range = (maxVal - minVal).clamp(1.0, double.infinity);

    double x(int i) => i * size.width / (points.length - 1);
    double y(double v) => size.height - ((v - minVal) / range) * size.height * 0.8 - size.height * 0.1;

    final path = Path();
    final fillPath = Path();

    fillPath.moveTo(x(0), size.height);
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(x(i), y(points[i]));
        fillPath.lineTo(x(i), y(points[i]));
      } else {
        path.lineTo(x(i), y(points[i]));
        fillPath.lineTo(x(i), y(points[i]));
      }
    }
    fillPath.lineTo(x(points.length - 1), size.height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()..color = color.withOpacity(0.12),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (int i = 0; i < points.length; i++) {
      if (i == points.length - 1) {
        canvas.drawCircle(
          Offset(x(i), y(points[i])),
          4,
          Paint()..color = color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}