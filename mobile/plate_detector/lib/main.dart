import 'package:flutter/material.dart';
import 'package:plate_detector/pages/add_user_page.dart';

import 'pages/home_page.dart';
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
      routes: {
        '/usuarios/agregar': (context) => const AddUserPage(),
      },
      home: const HomePage(),

    );
  }
}

