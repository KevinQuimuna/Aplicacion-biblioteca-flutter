import 'package:flutter/material.dart';

class TarjetaSeccion extends StatelessWidget {
  final String nombre;
  final Color? color;
  final IconData? icono;
  final VoidCallback? onTap;

  const TarjetaSeccion({
    required this.nombre,
    this.color,
    this.icono,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icono != null)
                Icon(
                  icono,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
              SizedBox(height: 16),
              Text(
                nombre,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}