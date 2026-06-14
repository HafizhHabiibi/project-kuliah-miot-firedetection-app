# 🌡️ IoT Monitor — Flutter Dashboard

Dashboard mobile untuk memantau data sensor lingkungan secara real-time dari perangkat ESP32 via Firebase.

---

## 📱 Tampilan Aplikasi

| Home | Grafik | Alert | Setting |
|------|--------|-------|---------|
| Suhu, Kelembaban, Air Quality | Grafik historis sensor | Notifikasi & peringatan | Konfigurasi threshold |

---

## 🛠️ Teknologi yang Digunakan

| Komponen | Teknologi |
|----------|-----------|
| Mobile App | Flutter (Dart) |
| Backend / Database | Firebase Realtime Database / Firestore |
| Mikrokontroler | ESP32 |
| Sensor Suhu & Kelembaban | DHT22 |
| Sensor Kualitas Udara | MQ-135 |

---

## 📁 Struktur Folder
lib/

├── main.dart                  # Entry point aplikasi

├── screens/

│   ├── home_screen.dart       # Halaman utama + navigasi

│   ├── chart_screen.dart      # Halaman grafik historis

│   ├── alert_screen.dart      # Halaman notifikasi

│   └── setting_screen.dart    # Halaman pengaturan

└── widgets/

├── sensor_card.dart        # Card suhu & kelembaban

├── air_quality_gauge.dart  # Gauge kualitas udara

└── mini_stat_card.dart     # Kartu ringkasan (AQ index, dll)

---

## ⚙️ Cara Menjalankan

### Prasyarat

- Flutter SDK versi 3.x ke atas → [flutter.dev](https://flutter.dev/docs/get-started/install)
- Dart SDK (sudah termasuk dalam Flutter)
- Android Studio / VS Code dengan ekstensi Flutter
- Akun Firebase (untuk integrasi data)

### Langkah-langkah

1. **Clone repository**
```bash
   git clone https://github.com/username/iot-monitor.git
   cd iot-monitor
```

2. **Install dependencies**
```bash
   flutter pub get
```

3. **Jalankan aplikasi**
```bash
   flutter run
```

---

## 🔥 Integrasi Firebase (Dilakukan Terpisah)

Aplikasi ini saat ini menggunakan data **statis** (dummy). Untuk menghubungkan ke Firebase:

1. Buat project di [Firebase Console](https://console.firebase.google.com/)
2. Tambahkan app Android/iOS ke project Firebase
3. Download file `google-services.json` (Android) atau `GoogleService-Info.plist` (iOS)
4. Letakkan file tersebut di folder yang sesuai:
   - Android → `android/app/google-services.json`
   - iOS → `ios/Runner/GoogleService-Info.plist`
5. Tambahkan dependency Firebase ke `pubspec.yaml`:
```yaml
   dependencies:
     firebase_core: ^2.x.x
     firebase_database: ^10.x.x   # atau cloud_firestore
```
6. Ganti nilai statis di `home_screen.dart` dengan stream dari Firebase

---

## 📡 Arsitektur Sistem
ESP32 + DHT22 + MQ-135

│

▼ (WiFi / HTTP)

Firebase Realtime DB / Firestore

│

▼ (Stream)

Flutter Mobile App

---


## 📄 Lisensi

Project ini dibuat untuk keperluan tugas mata kuliah Mobile & IoT.
