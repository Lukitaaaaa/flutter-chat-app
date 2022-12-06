// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';

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
          return Center(
            child: Text('Espere...'),
          );
        },
        
      ),
    );
  }

  Future ckeckLoginState ( BuildContext context ) async {

    final authService = Provider.of<AuthServices>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if (autenticado) {

      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => UsuarioPage(),
          transitionDuration: Duration( milliseconds: 0 )
        )
      );
    } else {

      Navigator.push(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoginPage(),
          // ignore: prefer_const_constructors
          transitionDuration: Duration( milliseconds: 0 )
        
        )
      );
    }
  }
}