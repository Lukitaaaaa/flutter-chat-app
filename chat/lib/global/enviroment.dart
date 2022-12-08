//variables de entorno para la conexion entre la app y el backend server
// Si la plataforma donde esta funcionando la aplicacion es de android tomara la ip de nuestra computadora
// En caso contrario si esta funcionando en otra plataforma como en ios, ponemos localhost


import 'dart:io';

class Enviroment {
  static String apiUrl    = Platform.isAndroid   ? 'http://192.168.0.104:3000/api' : 'http://localhost:3000/api';
  static String socketUrl = Platform.isAndroid   ? 'http://192.168.0.104:3000'      : 'http://localhost:3000';
}