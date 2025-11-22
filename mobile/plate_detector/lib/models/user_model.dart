class User{
  final String id;
  final String nombre;
  final int edad;
  final String numeroControl;
  final String correo;

  User({required this.id, required this.nombre, required this.edad, required this.numeroControl, required this.correo});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nombre: json['nombre'],
      edad: json['edad'],
      numeroControl: json['numeroControl'],
      correo: json['correo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'edad': edad,
      'numeroControl': numeroControl,
      'correo': correo,
    };
  }
}