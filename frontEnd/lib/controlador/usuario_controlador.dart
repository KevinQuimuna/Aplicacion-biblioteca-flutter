import 'package:http/http.dart' as http;
import 'dart:convert';

class UsuarioControlador {
  Future<bool> registrarUsuario(String nombre, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'nombre': nombre, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> iniciarSesion(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}