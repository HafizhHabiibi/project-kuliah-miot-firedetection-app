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
            'RIWAYAT DATA SENSOR (24 JAM TERAKHIR)',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF8888AA),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          _ChartCard(
            title: 'Suhu (°C) - DHT22',
            color: const Color(0xFFE24B4A),
            points: const [29.5, 31.0, 32.5, 34.0, 36.4, 33.2, 31.2],
            unit: '°C',
          ),
          const SizedBox(height: 10),
          _ChartCard(
            title: 'Kelembaban (%) - DHT22',
            color: const Color(0xFF5D9CF5),
            points: const [75.0, 71.2, 68.0, 65.5, 62.1, 64.0, 68.5],
            unit: '%',
          ),
          const SizedBox(height: 10),
          _ChartCard(
            title: 'Indeks Asap (%) - MQ-2',
            color: const Color(0xFFF59E0B),
            points: const [12.0, 15.5, 35.0, 52.3, 70.2, 45.0, 22.5],
            unit: '%',
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
  final String unit;

  const _ChartCard({
    required this.title,
    required this.color,
    required this.points,
    required this.unit,
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
                    ? '${latest.toInt()}$unit'
                    : '${latest.toStringAsFixed(1)}$unit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
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
                'Min: $minVal$unit',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8888AA),
                ),
              ),
              Text(
                'Max: $maxVal$unit',
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
      Paint()..color = color.withAlpha((0.12 * 255).toInt()),
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