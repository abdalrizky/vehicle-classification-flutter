import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../services/image_classifier_service.dart';
import '../models/prediction.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  // Ambil instance dari service singleton
  final ImageClassifierService _classifier = ImageClassifierService();

  bool _isProcessing = false;
  Prediction? _prediction;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    _initializeControllerFuture = _controller.initialize().then((_) {
      _controller.startImageStream(_onImageStream);
    });
  }

  Future<void> _onImageStream(CameraImage cameraImage) async {
    if (_isProcessing) return;

    _isProcessing = true;

    // Panggil service untuk prediksi
    Prediction prediction = await _classifier.predictFromCameraImage(cameraImage);

    // Update UI
    if (mounted) {
      setState(() {
        _prediction = prediction;
      });
    }

    _isProcessing = false;
  }

  @override
  void dispose() {
    _controller.stopImageStream();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Klasifikasi Real-Time'),
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
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_controller),
                _buildPredictionWidget(),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildPredictionWidget() {
    String displayText = _prediction?.toString() ?? "Arahkan kamera ke objek";

    return Positioned(
      bottom: 20.0,
      left: 0.0,
      right: 0.0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            displayText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

