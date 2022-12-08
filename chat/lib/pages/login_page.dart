// PANTALLA DEL LOGIN
// CONTIENE UN LOGO, UN FORMULARIO Y LOS LABELS

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/helpers/mostrar_alerta.dart';

import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/label.dart';
import 'package:chat_app/widgets/boton_ingresar.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const  Color(0xffF2F2F2),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Logo(titulo: 'Messenger'),  
                
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

  final emailCtrl  = TextEditingController(); // CONTROLADOR PARA GUARDAR EL TEXTO ESCRITO EN EL CAMPO DEL EMAIL
  final passCtrl   = TextEditingController(); // CONTROLADOR PARA GUARDAR EL TEXTO ESCRITO EN EL CAMPO DE LA CONTRASEÑA

  

  @override
  Widget build(BuildContext context) {

    final authServices = Provider.of<AuthServices>(context); 
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [

          CustomInput( // CAMPO DEL EMAIL
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress, 
            textController: emailCtrl
          
          ),
          
          CustomInput( // CAMPO DE LA CONTRASEÑA
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),


          BotonIngresar( // BOTON PARA INGRESAR A LA PANTALLA DE USUARIOS
            text: 'Ingrese', 
            onPressed: authServices.autenticando 
            ? () => {} 
            : () async {

              FocusScope.of(context).unfocus(); // CON ESTO OCULTAMOS EL TECLADO

              final loginOk = await authServices.login(emailCtrl.text.trim(), passCtrl.text.trim() );

              if ( loginOk ) { // SI EL LOGIN ESTA CORRECTO
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'usuarios'); // SE DIRIJE A LA PANTALLA DE USUARIOS
              } else {
                
                mostrarAlerta(context, 'Login incorrecto', 'Fijese bien los campos'); // DE LO CONTRARIO SE MUESTRA ESTA ALERTA

              }           
            
            }
          )
        ],
      ),
    );
  }
}

