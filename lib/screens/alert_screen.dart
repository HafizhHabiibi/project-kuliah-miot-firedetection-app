import 'package:flutter/material.dart';

class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = [
      _AlertData(
        title: 'Kelembaban Tinggi',
        message: 'Kelembaban mencapai 76.6%, di atas ambang 75%.',
        time: '2 menit lalu',
        level: AlertLevel.warning,
      ),
      _AlertData(
        title: 'Suhu Normal',
        message: 'Suhu kembali ke rentang normal (25–32°C).',
        time: '15 menit lalu',
        level: AlertLevel.info,
      ),
      _AlertData(
        title: 'Kualitas Udara Baik',
        message: 'PPM stabil di bawah 500 selama 1 jam terakhir.',
        time: '1 jam lalu',
        level: AlertLevel.success,
      ),
      _AlertData(
        title: 'Koneksi Terputus',
        message: 'ESP32 tidak mengirim data selama 30 detik.',
        time: '2 jam lalu',
        level: AlertLevel.danger,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NOTIFIKASI',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF8888AA),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          ...alerts.map((a) => _AlertTile(data: a)),
        ],
      ),
    );
  }
}

enum AlertLevel { success, warning, danger, info }

class _AlertData {
  final String title;
  final String message;
  final String time;
  final AlertLevel level;
  _AlertData({
    required this.title,
    required this.message,
    required this.time,
    required this.level,
  });
}

class _AlertTile extends StatelessWidget {
  final _AlertData data;
  const _AlertTile({required this.data});

  Color get _color {
    switch (data.level) {
      case AlertLevel.success: return const Color(0xFF4CAF50);
      case AlertLevel.warning: return const Color(0xFFF59E0B);
      case AlertLevel.danger:  return const Color(0xFFE24B4A);
      case AlertLevel.info:    return const Color(0xFF5D9CF5);
    }
  }

  Color get _bgColor {
    switch (data.level) {
      case AlertLevel.success: return const Color(0xFF1D3A1D);
      case AlertLevel.warning: return const Color(0xFF2D2200);
      case AlertLevel.danger:  return const Color(0xFF2D1010);
      case AlertLevel.info:    return const Color(0xFF0E1E38);
    }
  }

  IconData get _icon {
    switch (data.level) {
      case AlertLevel.success: return Icons.check_circle_outline;
      case AlertLevel.warning: return Icons.warning_amber_outlined;
      case AlertLevel.danger:  return Icons.error_outline;
      case AlertLevel.info:    return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF252540),
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: _color, width: 3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_icon, color: _color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.message,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8888AA),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF666688),
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