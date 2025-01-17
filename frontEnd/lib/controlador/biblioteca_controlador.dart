// lib/controlador/biblioteca_controlador.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:biblioteca/modelo/asiento_modelo.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';

class BibliotecaControlador extends ChangeNotifier {
  final IO.Socket socket;
  Map<String, List<Asiento>> asientosPorSeccion = {};
  Timer? _timerLimpieza;

  BibliotecaControlador()
      : socket = IO.io('http://localhost:3000', {
    'transports': ['websocket'],
    'autoConnect': true,
  }) {
    socket.onConnect((_) {
      print('Conectado al servidor');
      _inicializarAsientos();
    });

    socket.on('actualizacionAsiento', (data) {
      _manejarActualizacionAsiento(data);
    });

    socket.on('estadoAsientos', (data) {
      _actualizarEstadoAsientos(data);
    });

    // Iniciar timer para limpiar reservas expiradas
    _timerLimpieza = Timer.periodic(Duration(seconds: 30), (_) {
      _limpiarReservasExpiradas();
    });
  }

  void _inicializarAsientos() {
    socket.emit('obtenerAsientos');
  }

  void _actualizarEstadoAsientos(dynamic data) {
    try {
      final Map<String, dynamic> estados = Map<String, dynamic>.from(data);
      estados.forEach((seccion, asientosData) {
        final List<dynamic> asientosJson = asientosData as List<dynamic>;
        asientosPorSeccion[seccion] = asientosJson
            .map((json) => Asiento.fromJson(json))
            .toList();
      });
      notifyListeners();
    } catch (e) {
      print('Error al actualizar estado de asientos: $e');
    }
  }

  void _limpiarReservasExpiradas() {
    final ahora = DateTime.now();
    asientosPorSeccion.forEach((seccion, asientos) {
      for (var asiento in asientos) {
        if (asiento.estado == 'reservado' &&
            asiento.tiempoReserva != null &&
            ahora.difference(asiento.tiempoReserva!).inMinutes >= 5) {
          _liberarAsiento(seccion, asiento.fila, asiento.columna);
        }
      }
    });
  }

  void _liberarAsiento(String seccion, int fila, int columna) {
    socket.emit('liberarAsiento', {
      'seccion': seccion,
      'fila': fila,
      'columna': columna,
    });
  }

  Future<List<Asiento>> obtenerAsientos(String seccion) async {
    try {
      final response =
      await http.get(Uri.parse('localhost:3000/api/asientos/$seccion'));

      if (response.statusCode == 200) {
        final List<dynamic> datos = json.decode(response.body);
        final asientos = datos.map((json) => Asiento.fromJson(json)).toList();
        asientosPorSeccion[seccion] = asientos;
        return asientos;
      } else {
        throw Exception('Error al cargar asientos');
      }
    } catch (e) {
      print('Error en obtenerAsientos: $e');
      return asientosPorSeccion[seccion] ?? _crearAsientosIniciales(seccion);
    }
  }

  void _manejarActualizacionAsiento(dynamic data) {
    try {
      final asiento = Asiento.fromJson(data['asiento']);
      final seccion = data['seccion'];

      if (!asientosPorSeccion.containsKey(seccion)) {
        asientosPorSeccion[seccion] = _crearAsientosIniciales(seccion);
      }

      final index = asientosPorSeccion[seccion]!.indexWhere(
            (a) => a.fila == asiento.fila && a.columna == asiento.columna,
      );

      if (index >= 0) {
        asientosPorSeccion[seccion]![index] = asiento;
        notifyListeners();
      }
    } catch (e) {
      print('Error al manejar actualización de asiento: $e');
    }
  }

  List<Asiento> _crearAsientosIniciales(String seccion) {
    List<Asiento> asientos = [];
    for (int fila = 0; fila < 4; fila++) {
      for (int columna = 0; columna < 5; columna++) {
        asientos.add(Asiento(
          fila: fila,
          columna: columna,
          seccion: seccion,
          estado: 'libre',
        ));
      }
    }
    return asientos;
  }

  void reservarAsiento(String seccion, int fila, int columna, String usuarioId) {
    socket.emit('reservarAsiento', {
      'seccion': seccion,
      'fila': fila,
      'columna': columna,
      'usuarioId': usuarioId,
      'tiempoReserva': DateTime.now().toIso8601String(),
    });
  }

  void confirmarReserva(String seccion, int fila, int columna, String usuarioId) {
    socket.emit('confirmarReserva', {
      'seccion': seccion,
      'fila': fila,
      'columna': columna,
      'usuarioId': usuarioId,
    });
  }

  void cancelarReserva(String seccion, int fila, int columna, String usuarioId) {
    socket.emit('cancelarReserva', {
      'seccion': seccion,
      'fila': fila,
      'columna': columna,
      'usuarioId': usuarioId,
    });
  }

  @override
  void dispose() {
    _timerLimpieza?.cancel();
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}