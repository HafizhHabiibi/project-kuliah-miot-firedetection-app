import 'package:flutter/material.dart';
import 'chart_screen.dart';
import 'alert_screen.dart';
import 'setting_screen.dart';
import '../widgets/sensor_card.dart';
import '../widgets/smoke_level_gauge.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> _titles = [
    'Fire Detector',
    'Grafik Riwayat',
    'Notifikasi',
    'Pengaturan',
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
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
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
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
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

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  late Stream<SensorData> _sensorStream;

  @override
  void initState() {
    super.initState();
    _sensorStream = FirebaseService().getSensorDataStream();
  }

  Widget _buildStatusBanner(SensorData data) {
    Color bannerColor;
    Color borderBgColor;
    Color textColor;
    IconData icon;
    String title;
    String subtitle;
    List<Color> gradientColors;

    switch (data.status) {
      case 'Asap Terdeteksi':
        bannerColor = const Color(0xFFF59E0B);
        borderBgColor = const Color(0xFF3B2A0A);
        textColor = const Color(0xFFF59E0B);
        icon = Icons.warning_amber_rounded;
        title = 'Asap Terdeteksi';
        subtitle = 'Waspada, terdeteksi kenaikan kadar asap!';
        gradientColors = [const Color(0xFF2D2005), const Color(0xFF1F1502)];
        break;
      case 'Potensi Kebakaran':
        bannerColor = const Color(0xFFE24B4A);
        borderBgColor = const Color(0xFF3D1313);
        textColor = const Color(0xFFE24B4A);
        icon = Icons.campaign_rounded;
        title = 'Potensi Kebakaran';
        subtitle = 'BAHAYA! Segera periksa ruangan Anda!';
        gradientColors = [const Color(0xFF300F0F), const Color(0xFF1E0707)];
        break;
      case 'Aman':
      default:
        bannerColor = const Color(0xFF4CAF50);
        borderBgColor = const Color(0xFF1D3A1D);
        textColor = const Color(0xFF4CAF50);
        icon = Icons.check_circle_outline_rounded;
        title = 'Sistem Aman';
        subtitle = 'Kondisi lingkungan ruangan terpantau kondusif.';
        gradientColors = [const Color(0xFF0F260F), const Color(0xFF0A1A0A)];
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bannerColor.withAlpha((0.5 * 255).toInt()), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: bannerColor.withAlpha((0.15 * 255).toInt()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: borderBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: textColor, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFCCCCDD),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirebaseStatusInfo() {
    final bool isLive = FirebaseService().isFirebaseLive;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF252540),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isLive ? const Color(0xFF4CAF50) : const Color(0xFFF59E0B),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isLive ? 'Firebase Terkoneksi (Real-time)' : 'Demo Mode (Simulasi Data)',
              style: TextStyle(
                fontSize: 11,
                color: isLive ? const Color(0xFF8888AA) : const Color(0xFFF59E0B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SensorData>(
      stream: _sensorStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF5D9CF5),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        final data = snapshot.data ?? SensorData.initial();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusBanner(data),
              const SizedBox(height: 16),
              const Text(
                'KONDISI SENSOR',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8888AA),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SensorCard(
                      label: 'Suhu (DHT22)',
                      value: data.temperature.toString(),
                      unit: '°C',
                      subtitle: data.temperature > 35.0 ? 'Suhu Tinggi!' : 'Normal',
                      subtitleColor: data.temperature > 35.0
                          ? const Color(0xFFE24B4A)
                          : const Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SensorCard(
                      label: 'Kelembaban (DHT22)',
                      value: data.humidity.toString(),
                      unit: '%',
                      subtitle: data.humidity > 80.0 ? 'Lembab Tinggi' : 'Normal',
                      subtitleColor: data.humidity > 80.0
                          ? const Color(0xFFE24B4A)
                          : const Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SmokeLevelGauge(smokeLevel: data.smokeLevel),
              const SizedBox(height: 24),
              _buildFirebaseStatusInfo(),
            ],
          ),
        );
      },
    );
  }
}