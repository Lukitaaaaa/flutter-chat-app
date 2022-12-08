// FUNCIONES PARA LA COMUNICACION MEDIANTE SOCKETS ENTRE LA APP, EL SERVER Y LA BASE DE DATOS

// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
//! Link de la documentacion del paquete socket.io https://pub.dev/packages/socket_io_client
import 'package:chat_app/global/enviroment.dart';

import 'package:chat_app/services/auth_service.dart';

enum ServerStatus{ // ENUMERACION DE LOS ESTADOS DEL SERVER
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier { // El "ChangeNotifier" va ayudar a decir al providercuando tiene que refrescar el interfaz de usuario

  ServerStatus _serverStatus = ServerStatus.Connecting; // El guion bajo hace que la propiedad sea privada
  late IO.Socket _socket; 

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  void connect() async { // FUNCION DE CUANDO EL USUARIO SE CONECTA

    final token = await AuthServices.getToken();
    //Dart client
    _socket = IO.io( Enviroment.socketUrl ,{ //!Poner la ip de la computadora donde se este ejecutando el programa o poner localhost
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true, // cada vez que el cliente se conecte o desconecte va a crear una nueva instancia. Se va utilizar para renovar el token de cada usuario
      'extraHeaders': {
        'x-token': token
      }
    });


    _socket.on('connect',(_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    }); 

    _socket.on('disconnect',(_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje',( payload ) {
    //   print('nuevo-mensaje: $payload');
    // });

    //Esto hace que escuche un mensaje desde mi backend
    
  }
  void disconnect() { // FUNCION PARA CUANDO EL USUARIO SE DESCONECTE
    _socket.disconnect();
  }
}