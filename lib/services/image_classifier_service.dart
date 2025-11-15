import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../models/prediction.dart';

const int _inputSize = 150; // 150x150 (sesuai .ipynb)

const double _probabilityThreshold = 0.7;

class ImageClassifierService {
  // singleton pattern
  static final ImageClassifierService _instance = ImageClassifierService._internal();
  factory ImageClassifierService() => _instance;
  ImageClassifierService._internal();

  Interpreter? _interpreter;
  List<String>? _labels;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      _interpreter = await Interpreter.fromAsset('assets/ml/model.tflite');
      // print('Model TFLite berhasil dimuat.');

      // 2. Muat Label
      final labelData = await rootBundle.loadString('assets/ml/labels.txt');
      final labelList = labelData.split('\n');

      // Mem-parsing label agar hanya mengambil nama (mis: "Bike" bukan "0 Bike")
      _labels = labelList.map((label) {
        if (label.trim().isEmpty) return '';
        var parts = label.split(' ');
        if (parts.length > 1) {
          return parts.sublist(1).join(' ');
        }
        return label;
      }).where((label) => label.isNotEmpty).toList();

      // print('Label berhasil dimuat: $_labels');

      _isInitialized = true;
    } catch (e) {
      print('Gagal menginisialisasi service: $e');
    }
  }

  // prediksi dari gambar statis (Galeri)
  Future<Prediction> predictFromFile(File imageFile) async {
    if (!_isInitialized) throw StateError("Service belum diinisialisasi");

    // 1. Decode gambar
    img.Image? originalImage = img.decodeImage(await imageFile.readAsBytes());
    if (originalImage == null) return Prediction("Gagal proses", 0.0);

    // 2. Proses dan jalankan inferensi
    return _runInference(originalImage);
  }

  // prediksi dari stream kamera (Real-time)
  Future<Prediction> predictFromCameraImage(CameraImage cameraImage) async {
    if (!_isInitialized) throw StateError("Service belum diinisialisasi");

    // 1. Konversi YUV ke RGB
    img.Image rgbImage = _convertCameraImage(cameraImage);

    // 2. Proses dan jalankan inferensi
    return _runInference(rgbImage);
  }

  // Fungsi inti untuk menjalankan inferensi pada gambar [img.Image].
  Prediction _runInference(img.Image rgbImage) {
    // Fungsi inti untuk menjalankan inferensi pada gambar [img.Image].

      // 1. Resize gambar ke ukuran input model
      final img.Image resizedImage = img.copyResize(
        rgbImage,
        width: _inputSize,
        height: _inputSize,
      );

      // 2. Konversi gambar ke Uint8List (nilai 0-255)
      final Uint8List imageBytes = resizedImage.getBytes(order: img.ChannelOrder.rgb);

      // 3. Normalisasi data input ke Float32List (rentang 0.0 - 1.0)
      // Model TFLite biasanya mengharapkan input float, bukan integer 0-255.
      final inputAsFloatList = Float32List(1 * _inputSize * _inputSize * 3);
      int bufferIndex = 0;
      for (int i = 0; i < imageBytes.length; i++) {
        inputAsFloatList[bufferIndex++] = imageBytes[i] / 255.0;
      }

      // 4. Ubah bentuk menjadi [1, 150, 150, 3] (sesuai dengan input float yang sudah dinormalisasi)
      final reshapedInput = inputAsFloatList.reshape([1, _inputSize, _inputSize, 3]);

      // 5. Siapkan buffer output (sesuai error sebelumnya, shape [1, 1])
      final output = List.filled(1 * 1, 0.0).reshape([1, 1]);

      // 6. Jalankan inferensi
      try {
        _interpreter!.run(reshapedInput, output);
      } catch (e) {
        print('Error menjalankan model: $e');
        return Prediction("Error: Gagal inferensi", 0.0);
      }

      // 7. Proses output
      // Karena shape [1, 1], hasilnya adalah probabilitas untuk kelas 1 (Car)
      final double result = output[0][0];

      String predictedLabel;
      double confidence;

      // Asumsi dari labels.txt: 0 = Bike, 1 = Car
      if (result > 0.5) {
        predictedLabel = _labels![1]; // "Car"
        confidence = result;
      } else {
        predictedLabel = _labels![0]; // "Bike"
        confidence = 1.0 - result; // Probabilitas untuk "Bike" adalah kebalikan dari "Car"
      }

      // 8. Kembalikan label dan probabilitas
      if (confidence < _probabilityThreshold) {
        return Prediction("Objek Tidak Dikenali", confidence);
      } else {
        return Prediction(predictedLabel, confidence);
      }

  }

  // fungsi helper untuk konversi YUV420 ke RGB (untuk real-time classification)
  img.Image _convertCameraImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final img.Image rgbImage = img.Image(width: width, height: height);
    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    final yBuffer = yPlane.bytes;
    final uBuffer = uPlane.bytes;
    final vBuffer = vPlane.bytes;

    final yRowStride = yPlane.bytesPerRow;
    final uRowStride = uPlane.bytesPerRow;
    final vRowStride = vPlane.bytesPerRow;

    final uPixelStride = uPlane.bytesPerPixel!;
    final vPixelStride = vPlane.bytesPerPixel!;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvx = (x / 2).floor();
        final int uvy = (y / 2).floor();

        final int yIndex = (y * yRowStride) + x;
        final int uIndex = (uvy * uRowStride) + (uvx * uPixelStride);
        final int vIndex = (uvy * vRowStride) + (uvx * vPixelStride);

        // Konversi YUV ke RGB (formula standar)
        final int yValue = yBuffer[yIndex];
        final int uValue = uBuffer[uIndex] - 128;
        final int vValue = vBuffer[vIndex] - 128;

        int r = (yValue + 1.13983 * vValue).round();
        int g = (yValue - 0.39465 * uValue - 0.58060 * vValue).round();
        int b = (yValue + 2.03211 * uValue).round();

        // Klip nilai ke rentang 0-255
        rgbImage.setPixelRgba(x, y, r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255), 255);
      }
    }
    return rgbImage;
  }

  // menutup interpreter supaya tidak terjadi memory leak
  void dispose() {
    _interpreter?.close();
    _isInitialized = false;
  }
}