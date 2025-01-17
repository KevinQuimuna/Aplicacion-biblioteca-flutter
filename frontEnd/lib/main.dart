import 'package:flutter/material.dart';
import 'package:biblioteca/vista/pantalla_principal.dart';
import 'package:biblioteca/vista/login_pantalla.dart';
import 'package:biblioteca/vista/register_pantalla.dart';

void main() {
  runApp(BibliotecaApp());
}

class BibliotecaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biblioteca Pública',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => PantallaPrincipal(),
        '/login': (context) => PantallaLogin(),
        '/register': (context) => PantallaRegistro(),
      },
    );
  }
}