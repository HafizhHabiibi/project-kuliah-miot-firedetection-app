import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _notifSuhu = true;
  bool _notifHumid = true;
  bool _notifAsap = true;
  double _suhuThreshold = 35;
  double _humidThreshold = 80;

  @override
  Widget build(BuildContext context) {
    final bool isFirebaseLive = FirebaseService().isFirebaseLive;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('PERANGKAT & SERVER'),
          _infoTile('Device', 'ESP32 DevKit V1'),
          _infoTile('Sensor', 'DHT22 + MQ-2'),
          _infoTile('Backend Database', isFirebaseLive ? 'Firebase Live ✓' : 'Demo Mode (Simulasi)',
              valueColor: isFirebaseLive ? const Color(0xFF4CAF50) : const Color(0xFFF59E0B)),
          _infoTile('Update Terakhir', isFirebaseLive ? 'Sinkron Real-time' : 'Simulated Data'),
          
          const SizedBox(height: 20),
          _sectionLabel('THRESHOLD NOTIFIKASI'),
          _sliderTile(
            label: 'Batas Alarm Suhu',
            value: _suhuThreshold,
            min: 25,
            max: 50,
            unit: '°C',
            onChanged: (v) => setState(() => _suhuThreshold = v),
          ),
          _sliderTile(
            label: 'Batas Alarm Kelembaban',
            value: _humidThreshold,
            min: 50,
            max: 100,
            unit: '%',
            onChanged: (v) => setState(() => _humidThreshold = v),
          ),
          
          const SizedBox(height: 20),
          _sectionLabel('NOTIFIKASI ALARM'),
          _switchTile('Alert Suhu', _notifSuhu,
              (v) => setState(() => _notifSuhu = v)),
          _switchTile('Alert Kelembaban', _notifHumid,
              (v) => setState(() => _notifHumid = v)),
          _switchTile('Alert Asap & Kebakaran', _notifAsap,
              (v) => setState(() => _notifAsap = v)),
          
          if (!isFirebaseLive) ...[
            const SizedBox(height: 20),
            _sectionLabel('PANDUAN KONEKSI FIREBASE'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF252540),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF59E0B).withAlpha((0.3 * 255).toInt())),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFFF59E0B), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Langkah Menghubungkan Firebase:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Buat proyek di console.firebase.google.com\n'
                    '2. Tambahkan aplikasi Android & unduh google-services.json\n'
                    '3. Letakkan google-services.json ke folder /android/app/\n'
                    '4. Nyalakan ESP32 Anda untuk mengirim data JSON real-time!',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFCCCCDD),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 20),
          _sectionLabel('TENTANG'),
          _infoTile('Versi App', '1.0.0'),
          _infoTile('Developer', 'Kelompok IoT'),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF8888AA),
            letterSpacing: 0.8,
          ),
        ),
      );

  Widget _infoTile(String label, String value, {Color? valueColor}) =>
      Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFF252540),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFFCCCCDD))),
            Text(value,
                style: TextStyle(
                    fontSize: 13,
                    color: valueColor ?? const Color(0xFF8888AA))),
          ],
        ),
      );

  Widget _switchTile(String label, bool value, ValueChanged<bool> onChanged) =>
      Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF252540),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFFCCCCDD))),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: const Color(0xFF5D9CF5),
            ),
          ],
        ),
      );

  Widget _sliderTile({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF252540),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFFCCCCDD))),
                Text(
                  '${value.toInt()}$unit',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5D9CF5),
                  ),
                ),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
              activeColor: const Color(0xFF5D9CF5),
              inactiveColor: const Color(0xFF2D2D44),
            ),
          ],
        ),
      );
}