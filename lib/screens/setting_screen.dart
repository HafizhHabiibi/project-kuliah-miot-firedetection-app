import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _notifSuhu = true;
  bool _notifHumid = true;
  bool _notifAir = false;
  double _suhuThreshold = 35;
  double _humidThreshold = 80;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('PERANGKAT'),
          _infoTile('Device', 'ESP32 DevKit V1'),
          _infoTile('Sensor', 'DHT22 + MQ-135'),
          _infoTile('Status Koneksi', 'Terhubung ✓',
              valueColor: const Color(0xFF4CAF50)),
          _infoTile('Update Terakhir', '14 Jun 2025, 09:41'),
          const SizedBox(height: 20),
          _sectionLabel('THRESHOLD NOTIFIKASI'),
          _sliderTile(
            label: 'Batas Suhu',
            value: _suhuThreshold,
            min: 25,
            max: 50,
            unit: '°C',
            onChanged: (v) => setState(() => _suhuThreshold = v),
          ),
          _sliderTile(
            label: 'Batas Kelembaban',
            value: _humidThreshold,
            min: 50,
            max: 100,
            unit: '%',
            onChanged: (v) => setState(() => _humidThreshold = v),
          ),
          const SizedBox(height: 20),
          _sectionLabel('NOTIFIKASI'),
          _switchTile('Alert Suhu', _notifSuhu,
              (v) => setState(() => _notifSuhu = v)),
          _switchTile('Alert Kelembaban', _notifHumid,
              (v) => setState(() => _notifHumid = v)),
          _switchTile('Alert Kualitas Udara', _notifAir,
              (v) => setState(() => _notifAir = v)),
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
              activeColor: const Color(0xFF5D9CF5),
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