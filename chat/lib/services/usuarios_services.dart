// FUNCION PARA OBTENER LA LISTA DE USUARIOS REGISTRADOS EN LA BASE DE DATOS

import 'package:http/http.dart' as http;

import 'package:chat_app/global/enviroment.dart';

import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/models/usuarios_response.dart';

import 'package:chat_app/services/auth_service.dart';

class UsuarioService {

  Future<List<Usuario>> getUsuarios() async {

    try {

      final uri = Uri.parse('${Enviroment.apiUrl}/usuarios');
      
      final token = await AuthServices.getToken() ?? '';

      final resp = await http.get(uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token
        }
      );

      final usuariosResponse = usuariosResponseFromJson( resp.body );

      return usuariosResponse.usuarios;
    } catch(e) {
      
      return[];
    }
  }
}