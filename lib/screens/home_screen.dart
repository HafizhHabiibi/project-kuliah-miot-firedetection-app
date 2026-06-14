import 'package:flutter/material.dart';
import 'chart_screen.dart';
import 'alert_screen.dart';
import 'setting_screen.dart';
import '../widgets/sensor_card.dart';
import '../widgets/air_quality_gauge.dart';
import '../widgets/mini_stat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> _titles = [
    'IoT Monitor',
    'Grafik',
    'Alert',
    'Setting',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () => setState(() => _currentIndex = 2),
            ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeBody(),
          ChartScreen(),
          AlertScreen(),
          SettingScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1A2E),
        selectedItemColor: const Color(0xFF5D9CF5),
        unselectedItemColor: const Color(0xFF666688),
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Grafik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            activeIcon: Icon(Icons.notifications),
            label: 'Alert',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'KONDISI LINGKUNGAN',
            style: TextStyle(fontSize: 11, color: Color(0xFF8888AA), letterSpacing: 0.8),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SensorCard(
                  label: 'Suhu',
                  value: '31.2',
                  unit: '°C',
                  subtitle: '↑ 0.4° dari tadi',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SensorCard(
                  label: 'Kelembaban',
                  value: '76.6',
                  unit: '%',
                  subtitle: '⚠ Cukup lembab',
                  subtitleColor: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const AirQualityGauge(value: 400),
          const SizedBox(height: 16),
          const Text(
            'RINGKASAN',
            style: TextStyle(fontSize: 11, color: Color(0xFF8888AA), letterSpacing: 0.8),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(
                child: MiniStatCard(
                  label: 'Indeks AQ',
                  value: '20',
                  statusText: '● Baik',
                  statusColor: Color(0xFF4CAF50),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: MiniStatCard(
                  label: 'Heat Index',
                  value: '36°C',
                  statusText: '● Waspada',
                  statusColor: Color(0xFFF59E0B),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: MiniStatCard(
                  label: 'Dewpoint',
                  value: '26°C',
                  statusText: '● Normal',
                  statusColor: Color(0xFF5D9CF5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}