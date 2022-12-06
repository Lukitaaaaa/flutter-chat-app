// ignore_for_file: avoid_print

import 'package:chat_app/helpers/mostrar_alerta.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/label.dart';
import 'package:chat_app/widgets/boton_ingresar.dart';

import 'package:chat_app/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(titulo: 'Messenger',),
                
                _Form(),
                
                Label(ruta: 'register', titulo: 'No tienes cuenta?', subtitulo: 'Crea una ahora'),
                
                Text('Termino y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl  = TextEditingController();
  final passCtrl   = TextEditingController();

  

  @override
  Widget build(BuildContext context) {

    final authServices = Provider.of<AuthServices>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress, 
            textController: emailCtrl
          
          ),
          
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),


          BotonIngresar(
            text: 'Ingrese', 
            onPressed: authServices.autenticando 
            ? () => {} 
            : () async {

              FocusScope.of(context).unfocus(); // Oculta el teclado

              final loginOk = await authServices.login(emailCtrl.text.trim(), passCtrl.text.trim() );

              if ( loginOk ) {
                
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                
                mostrarAlerta(context, 'Login incorrecto', 'Fijese bien los campos');

              }           
            
            }
          )
        ],
      ),
    );
  }
}

