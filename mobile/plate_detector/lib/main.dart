import 'package:flutter/material.dart';
import 'package:plate_detector/pages/user_page.dart';
import 'pages/home_page.dart';
import 'pages/camera_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Detector de Placas',
      initialRoute: "/",
      routes: {
        "/": (context) => const HomePage(),
        "/usuarios": (context) => const UserPage(),
        "/camara": (context) => const CameraPage(),
      },
    );
  }
}
