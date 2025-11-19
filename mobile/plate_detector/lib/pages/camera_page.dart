import 'package:flutter/material.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cámara")),
      body: const Center(
        child: Text("Aquí va el detector de placas"),
      ),
    );
  }
}
