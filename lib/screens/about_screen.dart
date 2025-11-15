import 'package:flutter/material.dart';
import 'package:vehicle_classification/widgets/drawer_widget.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tentang Kami"),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset('assets/images/logo.png', width: 150.0, height: 150.0,),
              SizedBox(height: 20),
              Text(
                'Roda Lens',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Text(
                'Roda Lens merupakan aplikasi karya mahasiswa Informatika Universitas Mulawarman.\n\nPengembangan aplikasi dimulai sejak Oktober 2025 hingga saat ini.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.5),
              ),
              SizedBox(height: 32),
              Text(
                'Tim Pengembang',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTeamMember(
                      'Muhammad\nAbdal Rizky',
                      'Ketua',
                      'assets/images/abdal.jpeg',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTeamMember(
                      'Nur Fadhilah',
                      'Anggota',
                      'assets/images/nufa.jpeg',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTeamMember(
                      'Marlon Latuukng\nJuwe S.',
                      'Anggota',
                      'assets/images/marlon.jpeg',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTeamMember(
                      'Ridho Putra Darma',
                      'Anggota',
                      'assets/images/ridho.jpeg',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, String imagePath) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey[200],
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(height: 12),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(height: 4),
        Text(
          role,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    );
  }
}
