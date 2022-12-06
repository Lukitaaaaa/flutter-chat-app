import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/helpers/mostrar_alerta.dart';

import 'package:chat_app/services/auth_service.dart';

import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/label.dart';
import 'package:chat_app/widgets/boton_ingresar.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Logo(titulo: 'Register',),
                  
                  _Form(),
                  
                  Label(ruta: 'login', titulo: 'Ya tienes cuenta?', subtitulo: 'Ingresa ahora',),
                  
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

  final emailCtrl  = TextEditingController();
  final passCtrl   = TextEditingController();
  final nombreCtrl = TextEditingController();
  

  @override
  Widget build(BuildContext context) {

    final authServices = Provider.of<AuthServices>(context);
    
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nombreCtrl,
            
          ),

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
            text: 'Crear cuenta', 
            onPressed: authServices.autenticando 
            ? () => {} 
            : () async {



              FocusScope.of(context).unfocus(); // Oculta el teclado

              final registerOk = await authServices.register(nombreCtrl.text.trim(), emailCtrl.text.trim(), passCtrl.text.trim() );

              if ( registerOk == true ) {
                
                Navigator.pushReplacementNamed(context, 'usuarios');
              } else {
                
                mostrarAlerta(context, 'registro incorrecto', registerOk);

              }           
            
            }
          )
        ],
      ),
    );
  }
}

