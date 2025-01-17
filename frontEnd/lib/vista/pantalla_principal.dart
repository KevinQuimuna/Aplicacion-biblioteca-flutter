import 'package:flutter/material.dart';
import 'asientos_pantalla.dart';
import 'package:biblioteca/widgets/tarjeta_seccion.dart';

class PantallaPrincipal extends StatelessWidget {
  final List<Map<String, dynamic>> secciones = [
    {
      'nombre': 'Infantil',
      'color': Colors.blue[100],
      'icono': Icons.child_care,
    },
    {
      'nombre': 'Juvenil',
      'color': Colors.green[100],
      'icono': Icons.school,
    },
    {
      'nombre': 'Adultos',
      'color': Colors.orange[100],
      'icono': Icons.person,
    },
    {
      'nombre': 'Referencia',
      'color': Colors.purple[100],
      'icono': Icons.book,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biblioteca Pública'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: secciones.length,
          itemBuilder: (context, index) {
            final seccion = secciones[index];
            return TarjetaSeccion(
              nombre: seccion['nombre'],
              color: seccion['color'],
              icono: seccion['icono'],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaAsientos(
                    seccion: seccion['nombre'],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: Icon(Icons.logout),
        backgroundColor: Colors.red,
      ),
    );
  }
}