// lib/vista/asientos_pantalla.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:biblioteca/modelo/asiento_modelo.dart';
import 'package:biblioteca/controlador/biblioteca_controlador.dart';
import 'package:biblioteca/widgets/cabecera_seccion.dart';
import 'package:biblioteca/widgets/leyenda_asientos.dart';
import 'package:biblioteca/widgets/asiento_widget.dart';
import 'package:biblioteca/widgets/barra_acciones.dart';

class PantallaAsientos extends StatefulWidget {
  final String seccion;

  const PantallaAsientos({Key? key, required this.seccion}) : super(key: key);

  @override
  _PantallaAsientosState createState() => _PantallaAsientosState();
}

class _PantallaAsientosState extends State<PantallaAsientos> {
  final BibliotecaControlador controlador = BibliotecaControlador();
  String? asientoSeleccionadoId;
  Timer? _timerActualizacion;
  List<Asiento> asientos = [];

  @override
  void initState() {
    super.initState();
    _cargarAsientos();
    controlador.addListener(_actualizarAsientos);

    // Timer para actualizar el contador de tiempo restante
    _timerActualizacion = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timerActualizacion?.cancel();
    controlador.removeListener(_actualizarAsientos);
    super.dispose();
  }

  Future<void> _cargarAsientos() async {
    try {
      final asientosNuevos = await controlador.obtenerAsientos(widget.seccion);
      if (mounted) {
        setState(() {
          asientos = asientosNuevos;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar asientos: $e')),
        );
      }
    }
  }

  void _actualizarAsientos() {
    if (mounted) {
      setState(() {
        asientos = controlador.asientosPorSeccion[widget.seccion] ?? [];
      });
    }
  }

  String _obtenerTiempoRestante(DateTime? tiempoReserva) {
    if (tiempoReserva == null) return '';
    final diferencia = tiempoReserva.add(Duration(minutes: 5)).difference(DateTime.now());
    if (diferencia.isNegative) return 'Expirado';
    return '${diferencia.inMinutes}:${(diferencia.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sección ${widget.seccion}'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          CabeceraSeccion(seccion: widget.seccion),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  LeyendaAsientos(),
                  SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        final fila = index ~/ 5;
                        final columna = index % 5;
                        final asiento = asientos.firstWhere(
                              (a) => a.fila == fila && a.columna == columna,
                          orElse: () => Asiento(
                            fila: fila,
                            columna: columna,
                            seccion: widget.seccion,
                          ),
                        );

                        return AsientoWidget(
                          asiento: asiento,
                          seleccionado: asientoSeleccionadoId == '${asiento.fila}-${asiento.columna}',
                          tiempoRestante: _obtenerTiempoRestante(asiento.tiempoReserva),
                          onTap: () => _seleccionarAsiento(asiento),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (asientoSeleccionadoId != null)
            BarraAcciones(
              onReservar: _reservarAsiento,
              onConfirmar: _confirmarReserva,
              onCancelar: _cancelarReserva,
            ),
        ],
      ),
    );
  }

  void _seleccionarAsiento(Asiento asiento) {
    if (asiento.estado == 'libre') {
      setState(() => asientoSeleccionadoId = '${asiento.fila}-${asiento.columna}');
    }
  }

  void _reservarAsiento() {
    if (asientoSeleccionadoId != null) {
      final partes = asientoSeleccionadoId!.split('-');
      controlador.reservarAsiento(
        widget.seccion,
        int.parse(partes[0]),
        int.parse(partes[1]),
        'usuario1',
      );
    }
  }

  void _confirmarReserva() {
    if (asientoSeleccionadoId != null) {
      final partes = asientoSeleccionadoId!.split('-');
      controlador.confirmarReserva(
        widget.seccion,
        int.parse(partes[0]),
        int.parse(partes[1]),
        'usuario1',
      );
      setState(() => asientoSeleccionadoId = null);
    }
  }

  void _cancelarReserva() {
    if (asientoSeleccionadoId != null) {
      final partes = asientoSeleccionadoId!.split('-');
      controlador.cancelarReserva(
          widget.seccion,
          int.parse(partes[0]),
    int.parse(partes[1]),
    'usuario1',
    );
    setState(() => asientoSeleccionadoId = null);
  }
}
}