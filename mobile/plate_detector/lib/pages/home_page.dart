import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [

        const SizedBox(height: 30),

        Center(
          child: Text(
            "Detector de Placas",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          )
          ),

        const SizedBox(height: 30),

        _buildListTile(
          context,
          "Usuarios registrados",
          Icons.person,
          "/usuarios",
        ),

        _buildListTile(
          context,
          "Autos registrados",
          Icons.car_crash,
          "/autos",
        ),

        _buildListTile(
          context,
          "Cámara / Detector",
          Icons.camera_alt,
          "/camara",
        ),
      ],
    ),
  );
}


Widget _buildListTile(BuildContext context, String titulo, IconData icono, String ruta) {
    return Card(
      child: ListTile(
        leading: Icon(icono, size: 32),
        title: Text(titulo),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.pushNamed(context, ruta),
      ),
    );
  }
}