import 'package:flutter/material.dart';

import '../models/plate_model.dart';
import '../models/user_model.dart';
import '../models/auto_model.dart';
import '../services/api_client.dart';

class UserDetailPage extends StatefulWidget {
  final String placaReconocida;
  final PlateData data;
  final bool mostrarCoincidencia;

  const UserDetailPage({
    super.key,
    required this.placaReconocida,
    required this.data,
    this.mostrarCoincidencia = true,
  });

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late final Persona usuario;
  late final Auto autoPrincipal;

  late Future<List<Auto>> _autosFuture;

  @override
  void initState() {
    super.initState();
    usuario = widget.data.userData;
    autoPrincipal = widget.data.autoData;

    _autosFuture = ApiClient.instance.obtenerAutosPorPersona(usuario.id);
  }

  @override
  Widget build(BuildContext context) {
    final placaReconocida = widget.placaReconocida;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de la placa')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // === Info de placa detectada / registrada ===)
          if (widget.mostrarCoincidencia)
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
                      'Placa registrada en BD (principal)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      autoPrincipal.placa,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // === Propietario ===
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Propietario',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  _row('Nombre', usuario.nombre),
                  _row('Edad', '${usuario.edad} años'),
                  _row('Número de control', usuario.numeroControl.toString()),
                  _row('Correo', usuario.correo),
                  _row('Estatus', usuario.estatus),
                  _row('No. Incidencias', usuario.noIncidencias.toString()),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Autos del usuario',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),

          FutureBuilder<List<Auto>>(
            future: _autosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error al cargar autos: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final autos = snapshot.data ?? [];

              if (autos.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Este usuario no tiene autos registrados.'),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: autos.length,
                itemBuilder: (context, index) {
                  final a = autos[index];
                  final esDetectada =
                      widget.mostrarCoincidencia &&
                      normalizarPlaca(a.placa) ==
                          normalizarPlaca(placaReconocida);
                  return Card(
                    color: esDetectada ? Colors.green.withOpacity(0.1) : null,
                    child: ListTile(
                      title: Text(a.placa),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Marca: ${a.marca}'),
                          Text('Modelo: ${a.modelo}'),
                          Text('Color: ${a.color}'),
                          if (esDetectada)
                            const Text(
                              'Coincide con placa detectada',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 24),

          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }

  String normalizarPlaca(String placa) {
    return placa.toUpperCase().replaceAll(' ', '');
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
