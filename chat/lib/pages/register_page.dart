// PANTALLA DE REGISTRO
// CONTIENE UN LOGO, UN FORMULARIO Y LOS LABELS

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/helpers/mostrar_alerta.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_services.dart';

import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/label.dart';
import 'package:chat_app/widgets/boton_ingresar.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Logo(titulo: 'Register'),
                  
                  _Form(),
                  
                  Label(ruta: 'login', titulo: 'Ya tienes cuenta?', subtitulo: 'Ingresa ahora'),
                  
                  Text('Termino y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200)),
                ],
              ),
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
  final passCtrl   = TextEditingController(); // CONTROLADOR PARA GUARDAR EL TEXTO ESCRITO EN EL CAMPO DEL CONTRASEÑA
  final nombreCtrl = TextEditingController(); // CONTROLADOR PARA GUARDAR EL TEXTO ESCRITO EN EL CAMPO DEL NOMBRE
  

  @override
  Widget build(BuildContext context) {

    final authServices = Provider.of<AuthServices>(context);
    final socketServices = Provider.of<SocketService>(context);
    
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [

          CustomInput( // CAMPO DEL NOMBRE
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nombreCtrl,
            
          ),

          CustomInput( // CAMPO DEL CORREO
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
            text: 'Crear cuenta', 
            onPressed: authServices.autenticando 
            ? () => {} 
            : () async {



              FocusScope.of(context).unfocus(); // CON ESTO OCULTAMOS EL TECLADO

              final registerOk = await authServices.register(nombreCtrl.text.trim(), emailCtrl.text.trim(), passCtrl.text.trim() );

              if ( registerOk == true ) { // SI EL REGISTRO ESTA CORRECTO

                socketServices.connect(); // SE CONECTA AL SERVER
                Navigator.pushReplacementNamed(context, 'usuarios'); // SE DIRIJE A LA PANTALLA DE USUARIOS
              } else {
                
                mostrarAlerta(context, 'registro incorrecto', registerOk); // DE LO CONTRARIO SE MUESTRA ESTA ALERTA

              }           
            
            }
          )
        ],
      ),
    );
  }
}

