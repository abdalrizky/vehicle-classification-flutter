import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('Beranda'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            title: Text('Klasifikasi Real-Time'),
            leading: Icon(Icons.camera_alt_rounded),
            onTap: () {
              Navigator.pushNamed(context, '/realtime-camera');
            },
          ),
          ListTile(
            title: Text('Klasifikasi Foto Galeri'),
            leading: Icon(Icons.photo),
            onTap: () {
              Navigator.pushNamed(context, '/gallery');
            },
          ),
          ListTile(
            title: Text('Tentang Kami'),
            leading: Icon(Icons.info),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/about');
            },
          ),
        ],
      ),
    );
  }
}
