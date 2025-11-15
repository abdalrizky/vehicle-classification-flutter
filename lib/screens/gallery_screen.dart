import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/image_classifier_service.dart';
import '../models/prediction.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // ambil instance dari service singleton
  final ImageClassifierService _classifier = ImageClassifierService();
  final ImagePicker _picker = ImagePicker();

  File? _image;
  Prediction? _prediction;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final File imageFile = File(pickedFile.path);

    setState(() {
      _image = imageFile;
      _isLoading = true;
      _prediction = null;
    });

    Prediction prediction = await _classifier.predictFromFile(imageFile);

    setState(() {
      _prediction = prediction;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Klasifikasi Foto Galeri'),
        actions: [
          IconButton(
            icon: Icon(Icons.image_search),
            tooltip: 'Pilih Gambar',
            onPressed: _pickImage,
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepOrange.shade100,
                Colors.deepOrange.shade200,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: _image == null
                      ? Text('Silakan pilih gambar dari galeri', textAlign: TextAlign.center)
                      : Image.file(_image!),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: _isLoading
                    ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text("Menganalisis..."),
                  ],
                )
                    : _buildPredictionWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk menampilkan hasil prediksi
  Widget _buildPredictionWidget() {
    if (_prediction == null) {
      return Text(
        'Belum ada gambar dipilih',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      );
    }

    // 1. Cek apakah label adalah 'Objek Tidak Dikenali'
    if (_prediction!.label == 'Objek Tidak Dikenali') {
      return Text(
        _prediction!.label, // Tampilkan "Objek Tidak Dikenali"
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme
              .of(context)
              .colorScheme
              .error, // Gunakan warna error
        ),
        textAlign: TextAlign.center,
      );
    }

    // Ubah probabilitas menjadi persentase
    final String accuracy = (_prediction!.probability * 100).toStringAsFixed(1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _prediction!.label, // Tampilkan Label
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          'Akurasi: $accuracy%', // Tampilkan Akurasi
          style: TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

