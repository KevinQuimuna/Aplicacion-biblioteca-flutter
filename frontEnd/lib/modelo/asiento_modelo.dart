class Asiento {
  final int fila;
  final int columna;
  final String seccion;
  final String estado;
  final String? usuarioId;
  final DateTime? tiempoReserva;

  Asiento({
    required this.fila,
    required this.columna,
    required this.seccion,
    this.estado = 'libre',
    this.usuarioId,
    this.tiempoReserva,
  });

  factory Asiento.fromJson(Map<String, dynamic> json) {
    return Asiento(
      fila: json['fila'] ?? 0,
      columna: json['columna'] ?? 0,
      seccion: json['seccion'] ?? '',
      estado: json['estado'] ?? 'libre',
      usuarioId: json['usuarioId'],
      tiempoReserva: json['tiempoReserva'] != null
          ? DateTime.parse(json['tiempoReserva'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fila': fila,
      'columna': columna,
      'seccion': seccion,
      'estado': estado,
      'usuarioId': usuarioId,
      'tiempoReserva': tiempoReserva?.toIso8601String(),
    };
  }

  Asiento copyWith({
    int? fila,
    int? columna,
    String? seccion,
    String? estado,
    String? usuarioId,
    DateTime? tiempoReserva,
  }) {
    return Asiento(
      fila: fila ?? this.fila,
      columna: columna ?? this.columna,
      seccion: seccion ?? this.seccion,
      estado: estado ?? this.estado,
      usuarioId: usuarioId ?? this.usuarioId,
      tiempoReserva: tiempoReserva ?? this.tiempoReserva,
    );
  }
}