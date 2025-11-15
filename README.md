# Roda Lens - Klasifikasi Kendaraan Roda Dua dan Roda Empat dengan Flutter

Proyek ini adalah aplikasi mobile yang dibangun menggunakan Flutter untuk melakukan klasifikasi jenis kendaraan roda dua dan roda empat secara _real-time_ menggunakan kamera atau dari gambar yang ada di galeri. Aplikasi ini memanfaatkan model Machine Learning TensorFlow Lite untuk mengenali objek kendaraan.

## ✨ Fitur

- **Klasifikasi Real-time**: Menggunakan kamera perangkat untuk mendeteksi dan mengklasifikasikan kendaraan secara langsung.
- **Pilih dari Galeri**: Memungkinkan pengguna untuk memilih gambar dari galeri perangkat untuk diklasifikasikan.
- **Model TFLite**: Diintegrasikan dengan model TensorFlow Lite (`.tflite`) untuk inferensi machine learning di perangkat.

## 🛠️ Teknologi & Dependensi

Proyek ini dibangun menggunakan teknologi berikut:

- **Flutter**: Framework UI dari Google untuk membangun aplikasi mobile native yang indah.
- **TensorFlow Lite**: Untuk menjalankan model machine learning pada perangkat mobile.
- **`tflite_flutter`**: Plugin untuk mengintegrasikan model TensorFlow Lite di aplikasi Flutter.
- **`camera`**: Plugin untuk mengakses kamera perangkat.
- **`image_picker`**: Plugin untuk memilih gambar dari galeri.

## 📂 Struktur Proyek

Berikut adalah struktur direktori dan file penting dalam proyek ini:

```
├── android/            # Kode spesifik untuk platform Android.
├── assets/
│   ├── ml/
│   │   ├── model.tflite  # File model Machine Learning yang telah di-training.
│   │   └── labels.txt    # File teks berisi daftar nama/label kelas (mobil dan motor).
│   └── images/           # Direktori untuk menyimpan aset gambar yang digunakan di UI.
├── ipynb/              # Direktori berisi Jupyter Notebook, digunakan untuk proses persiapan data dan training model machine learning.
├── lib/                # Direktori utama yang berisi semua kode sumber Dart aplikasi.
│   ├── models/         # Berisi kelas-kelas model data (misal model untuk hasil prediksi).
│   ├── screens/        # Berisi file-file untuk setiap halaman/layar pada aplikasi.
│   ├── services/       # Berisi logika bisnis, seperti layanan untuk klasifikasi gambar.
│   ├── widgets/        # Berisi widget-widget kustom yang dapat digunakan kembali.
│   └── main.dart       # Titik masuk (entry point) aplikasi Flutter.
├── test/               # Berisi file-file untuk pengujian (unit testing, widget testing).
├── .gitignore          # Konfigurasi file dan direktori yang diabaikan oleh Git.
├── pubspec.yaml        # File konfigurasi utama proyek Flutter. Di sini Anda mendaftarkan dependensi (seperti tflite_flutter) dan aset (seperti model.tflite).
└── README.md           # File dokumentasi ini.
```

## 🚀 Cara Menjalankan Proyek

Untuk menjalankan proyek ini di lingkungan lokal Anda, ikuti langkah-langkah berikut:

1.  **Clone Repositori**
    ```bash
    git clone https://github.com/abdalrizky/vehicle-classification-flutter.git
    cd vehicle-classification-flutter
    ```

2.  **Install Dependensi**
    Pastikan Anda sudah menginstal Flutter SDK. Jalankan perintah berikut untuk mengunduh semua dependensi yang diperlukan.
    ```bash
    flutter pub get
    ```

3.  **Jalankan Aplikasi**
    Hubungkan perangkat atau jalankan emulator, lalu jalankan perintah berikut:
    ```bash
    flutter run
    ```
    
## 📊 Dataset
https://www.kaggle.com/datasets/utkarshsaxenadn/car-vs-bike-classification-dataset

## 📱 File .apk
https://drive.google.com/file/d/18TSS4v8Jb1qfIUWgON1uvQgb_EkIPyr_/view?usp=sharing

---
Dibuat oleh Kelompok 2 B'23:
1. 2309106012 - Muhammad Abdal Rizky
2. 2309106066 - Nur Fadhilah
3. 2309106072 - Marlon Latuukng Juwe S.
4. 2509106133 - Ridho Putra Darma
