// FUNCION PARA OBTENER LOS MENSAJES DEL CHAT

import 'package:chat_app/models/mensajes_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/global/enviroment.dart';

import 'package:chat_app/models/usuario.dart';

import 'package:chat_app/services/auth_service.dart';

class ChatService with ChangeNotifier{

  Usuario? usuarioParaMandarMsg;

  Future<List<Mensaje>> getChat ( String usuarioId ) async { // PETICION DE OBTENER RESPUESTA

    final uri = Uri.parse('${Enviroment.apiUrl}/mensajes/$usuarioId');

    final token = await AuthServices.getToken() ?? '';

    final resp = await http.get(uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token
      }
    );

    final mensajesRes = mensajesResponseFromJson(resp.body); // RESPUESTA DE LA PETICION

    return mensajesRes.mensajes;
  }

}