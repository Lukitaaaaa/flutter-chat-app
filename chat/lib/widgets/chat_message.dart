// WIDGET DEL MENSAJE
// UN MENSAJE TIENE QUE CONTENER UN TEXTO, UN UID Y UNA ANIMACION

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';

class ChatMessage extends StatelessWidget {
  

  final String texto;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    Key? key,
    required this.texto,
    required this.uid,
    required this.animationController,
  }): super(key: key);
  

  @override
  Widget build(BuildContext context) {

    final authServices = Provider.of<AuthServices>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: uid == authServices.usuario!.uid // SI EL UID ES IGUAL AL USUARIO LOGEADO
          ? _myMessage() // ENVIARE UN MENSAJE CON ESTE DISEÑO
          : _notMyMessage(), // DE LO CONTRARIO ENVIARE UN MENSAJE CON ESTE DISEÑO
        ),
      ),
    );
  }
  Widget _myMessage(){ // DISEÑO DEL MENSAGE QUE ENVIA EL USUARIO A OTRO
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin:  const EdgeInsets.only(
          bottom: 5,
          left: 50,
          right: 5,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Text( texto, style: const TextStyle(color: Colors.white), ),
      ),
    );
  }

  Widget _notMyMessage(){ // DISEÑO DEL MENSAGE QUE RECIBE EL USUARIO
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
          bottom: 5,
          left: 5,
          right: 50,
        ),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 5),
              blurRadius: 5
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
          
        ),
        child: Text( texto, style: const TextStyle(color: Colors.black), ),
      ),
    );
  }
}