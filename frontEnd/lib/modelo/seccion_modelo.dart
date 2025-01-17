class Seccion {
  final String nombre;
  final String horarioApertura;
  final String horarioCierre;

  Seccion({
    required this.nombre,
    required this.horarioApertura,
    required this.horarioCierre,
  });

  factory Seccion.fromJson(Map<String, dynamic> json) {
    return Seccion(
      nombre: json['nombre'],
      horarioApertura: json['horarioApertura'],
      horarioCierre: json['horarioCierre'],
    );
  }
}