import 'package:flutter/material.dart';

import '../models/plate_model.dart';

class UserDetailPage extends StatelessWidget {
  final String placaReconocida;
  final PlateData data;

  const UserDetailPage({
    super.key,
    required this.placaReconocida,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final user = data.userData;
    final auto = data.autoData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la placa'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info placa
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Placa detectada (OCR)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    placaReconocida,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Placa registrada en BD',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    auto.placa,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Propietario',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _row('Nombre', user.nombre),
                  _row('Edad', '${user.edad} años'),
                  _row('Número de control', user.numeroControl.toString()),
                  _row('Correo', user.correo),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Info auto
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Auto',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _row('Placa:', auto.placa),
                  _row('Marca:', auto.marca),
                  _row('Modelo:', auto.modelo),
                  _row('Color:', auto.color),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Escanear otra placa'),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
