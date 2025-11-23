class Persona{
  final String id;
  final String nombre;
  final int edad;
  final String numeroControl;
  final String correo;
  final String estatus;
  final int noIncidencias;

  Persona({required this.id, required this.nombre, required this.edad, required this.numeroControl, required this.correo, required this.estatus, required this.noIncidencias});

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['id'],
      nombre: json['nombre'],
      edad: json['edad'],
      numeroControl: json['numeroControl'],
      correo: json['correo'],
      estatus: json['estatus'],
      noIncidencias: json['noIncidencias'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'edad': edad,
      'numeroControl': numeroControl,
      'correo': correo,
      'estatus': estatus,
      'noIncidencias': noIncidencias,
    };
  }
}