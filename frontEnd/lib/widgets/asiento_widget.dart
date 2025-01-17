// lib/widgets/asiento_widget.dart
import 'package:flutter/material.dart';
import 'package:biblioteca/modelo/asiento_modelo.dart';

class AsientoWidget extends StatelessWidget {
  final Asiento asiento;
  final bool seleccionado;
  final String tiempoRestante;
  final VoidCallback onTap;

  const AsientoWidget({
    Key? key,
    required this.asiento,
    required this.seleccionado,
    required this.tiempoRestante,
    required this.onTap,
  }) : super(key: key);

  Color _obtenerColor() {
    if (seleccionado) return Colors.blue;
    switch (asiento.estado) {
      case 'libre':
        return Colors.green;
      case 'ocupado':
        return Colors.red;
      case 'reservado':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: asiento.estado == 'libre' ? onTap : null,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: seleccionado ? Colors.blue[700]! : Colors.grey[300]!,
                width: seleccionado ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Stack(
              children: [
                // Icono de asiento
                Center(
                  child: Icon(
                    Icons.chair,
                    size: 32,
                    color: _obtenerColor(),
                  ),
                ),
                // Número de asiento
                Positioned(
                  top: 4,
                  right: 4,
                  child: Text(
                    '${asiento.fila * 5 + asiento.columna + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Tiempo restante para reservas
                if (asiento.estado == 'reservado' && tiempoRestante.isNotEmpty)
                  Positioned(
                    bottom: 4,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        tiempoRestante,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}