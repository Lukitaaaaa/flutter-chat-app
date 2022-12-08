
// PANTALLA DE CARGA

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_services.dart';

import 'package:chat_app/pages/usuarios_page.dart';
import 'package:chat_app/pages/login_page.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: ckeckLoginState(context),
        builder: ( context, snapshot) {
          return const Center(
            child: Text('Espere...Por favor'),
          );
        },
        
      ),
    );
  }

  Future ckeckLoginState ( BuildContext context ) async { // METODO PARA CHEKEAR SI EL USUARIO TIENE UN TOKEN ACTIVO

    final socketServices = Provider.of<SocketService>(context, listen: false);
    final authService = Provider.of<AuthServices>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if (autenticado) { // SI EL USUARIO ESTA AUTENTICADO

      socketServices.connect(); // SE CONECTA AL SERVER
      
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const UsuarioPage(), // SE DIRIJE HACIA LA PANTALLA DE USUARIOS
          transitionDuration: const Duration( milliseconds: 0 )
        )
      );
    } else { // SI NO ESTA AUTENTICADO

      Navigator.push(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginPage(), // SE DIRIJE HACIA LA PANTALLA DEL LOGIN
          // ignore: prefer_const_constructors
          transitionDuration: const Duration( milliseconds: 0 )
        
        )
      );
    }
  }
}