import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_classification/screens/gallery_screen.dart';
import 'package:vehicle_classification/screens/realtime_camera_screen.dart';
import 'package:vehicle_classification/widgets/drawer_widget.dart';

class HomeScreen extends StatelessWidget {
  final CameraDescription camera;

  const HomeScreen({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beranda'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(Icons.menu),
            );
          },
        ),
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
      drawer: DrawerWidget(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset('assets/images/logo.png', width: 150.0, height: 150.0,),
              SizedBox(height: 24),
              Text(
                'Roda Lens',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Text(
                'Aplikasi ini digunakan untuk mengenali kendaraan roda dua dan empat.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
              SizedBox(height: 24),
              ListTile(
                leading: Icon(Icons.camera_alt, size: 40),
                title: Text('Klasifikasi Real-Time'),
                subtitle: Text('Gunakan kamera untuk prediksi langsung'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraScreen(camera: camera),
                    ),
                  );
                },
              ),
              SizedBox(height: 8),
              ListTile(
                leading: Icon(Icons.image, size: 40),
                title: Text('Klasifikasi Foto Galeri'),
                subtitle: Text('Pilih gambar dari galeri Anda'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GalleryScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
