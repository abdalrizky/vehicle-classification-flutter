import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_classification/screens/about_screen.dart';
import 'package:vehicle_classification/screens/gallery_screen.dart';
import 'package:vehicle_classification/screens/home_screen.dart';
import 'package:vehicle_classification/screens/realtime_camera_screen.dart';
import 'package:vehicle_classification/services/image_classifier_service.dart';

late CameraDescription firstCamera;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // singleton tflite
  await ImageClassifierService().initialize();

  final cameras = await availableCameras();

  // pastikan pakai kamera belakang
  firstCamera = cameras.first;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TFLite',
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => HomeScreen(camera: firstCamera),
        '/realtime-camera': (context) => CameraScreen(camera: firstCamera),
        '/gallery': (context) => GalleryScreen(),
        '/about': (context) => AboutScreen(),
      },
    );
  }
}
