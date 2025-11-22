import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/plate_model.dart';

class ApiClient {
  ApiClient._internal();
  static final ApiClient instance = ApiClient._internal();

  // Cambia esta URL según donde tengas corriendo FastAPI
  final String _baseUrl = 'https://placas-api-k5gv.onrender.com';

  Future<PlateData?> datosPorPlaca(String placa) async {
    final uri = Uri.parse('$_baseUrl/autos/placa/$placa');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return PlateData.fromJson(json);
    }

    if (response.statusCode == 404) {
      // Placa no registrada
      return null;
    }

    throw Exception('Error al consultar API: ${response.statusCode}');
  }
}
