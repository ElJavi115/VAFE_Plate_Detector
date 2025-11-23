// lib/main.dart
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/camera_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detector de Placas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),

      home: const HomePage(),

    );
  }
}

class _UsuariosPlaceholderPage extends StatelessWidget {
  const _UsuariosPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios registrados')),
      body: const Center(
        child: Text('Aquí irá la pantalla de usuarios registrados'),
      ),
    );
  }
}

/// PLACEHOLDER: Pantalla temporal para "Autos registrados"
class _AutosPlaceholderPage extends StatelessWidget {
  const _AutosPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Autos registrados')),
      body: const Center(
        child: Text('Aquí irá la pantalla de autos registrados'),
      ),
    );
  }
}
