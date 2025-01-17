// lib/widgets/barra_acciones.dart
import 'package:flutter/material.dart';

class BarraAcciones extends StatelessWidget {
  final VoidCallback onReservar;
  final VoidCallback onConfirmar;
  final VoidCallback onCancelar;

  const BarraAcciones({
    Key? key,
    required this.onReservar,
    required this.onConfirmar,
    required this.onCancelar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: onReservar,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Reservar'),
          ),
          ElevatedButton(
            onPressed: onConfirmar,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Confirmar'),
          ),
          ElevatedButton(
            onPressed: onCancelar,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}