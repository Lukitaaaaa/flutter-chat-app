// FUNCIONES PARA LA AUTENTICACION DEL USUARIO Y LA CONFIGURACION DE SUS TOKENS

// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_app/global/enviroment.dart';

import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/usuario.dart';

class AuthServices with ChangeNotifier{

  Usuario? usuario;
  bool _autenticando = false;


  bool get autenticando => _autenticando;
  set autenticando (bool valor){
    _autenticando = valor;
    notifyListeners();
  }

  final _storage = const FlutterSecureStorage(); // ALMACENAMIENTO DE TOKENS
  // Getters del token de forma estatica

  static Future<String?> getToken() async { // OBTIENE EL TOKEN
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async { // BORRA EL TOKEN
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');

  }

  

  Future<bool> login( String email, String password ) async { //FUNCION DEL LOGIN

    autenticando = true;

    final data = {
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${Enviroment.apiUrl}/login'); // DEFINIMOS NUESTRA VARIABLE DE ENTORNO COMO URI

    final resp = await http.post(uri, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    autenticando = false;

    
    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token); //GUARDA EL TOKEN UNA VEZ LOGEADO

      return true;

    } else {
      
      return false;
    }
    
  }

  Future register(String nombre, String email, String password ) async { //FUNCION DEL REGISTRO

    autenticando = false;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${Enviroment.apiUrl}/login/new');  

    final resp = await http.post(uri, 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    autenticando = true;

    
    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token); // GUARDA EL TOKEN UNA VEZ REGISTRADO

      return true;

    } else {
      final respBody = jsonDecode(resp.body);

      
      return respBody["msg"];
    }
  }

  Future<bool> isLoggedIn() async { // FUNCION PARA RENOVAR EL TOKEN CUANDO EL USUARIO ABRE LA APP

    final token = await _storage.read(key: 'token') ?? '';

    final uri = Uri.parse('${Enviroment.apiUrl}/login/renew'); 
    final resp = await http.get(uri, 
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token); // GUARDA EL NUEVO TOKEN REVONADO

      return true;

    } else {
      logout();
      return false;
    }
    
  }

  Future _guardarToken( String token ) async { //GUARDA EL TOKEN

    return await _storage.write(key: 'token', value: token );

  }

  Future logout() async { // BORRA EL TOKEN CUANDO EL USUARIO HACE UN LOGOUT
    
    await _storage.delete(key: 'token');
  }
}