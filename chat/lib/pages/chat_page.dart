// PANTALLA DEL CHAT

// APPBAR QUE TIENE EL AVATAR Y EL NOMBRE DEL USUARIO ELEGIDO 
// LISTA DE LOS MENSAJES ENVIADOS Y RECIBIDOS 
// CAMPO DONDE SE INTRODUCE TEXTO
// BOTON PARA ENVIAR EL TEXTO INTRODUCIDO EN EL CAMPO

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/models/mensajes_response.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:chat_app/services/socket_services.dart';

import 'package:chat_app/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textController = TextEditingController(); // CONTROLADOR PARA GUARDAR LA INFORMACION DEL TEXTFIELD
  final _focusNode      = FocusNode(); // FOCO DEL CAMPO 

  late ChatService chatService;
  late SocketService socketService;
  late AuthServices authService;


  final List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false; // FUNCION QUE DETERMINA SI EL USUARIO ESTA ESCRIBIENDO

  @override
  void initState() {
    super.initState();

    chatService   = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthServices>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial( chatService.usuarioParaMandarMsg!.uid );
  }

  void _cargarHistorial ( String usuarioId ) async {

    List<Mensaje> chat = await chatService.getChat(usuarioId);

    final historial = chat.map((e) => ChatMessage(
      texto: e.msg, 
      uid: e.de, 
      animationController: AnimationController(vsync: this, duration: const Duration( milliseconds: 0 ))..forward()
      
    ));

    setState(() {
      _messages.insertAll(0, historial);
    });
  }

  void _escucharMensaje( dynamic payload ) { // METODO PARA ESCUCHAR EL MENSAJE DE OTRO USUARIO
    
    ChatMessage message = ChatMessage(
      texto: payload['mensaje'], 
      uid: payload['de'], 
      animationController: AnimationController(vsync: this, duration: const Duration( microseconds: 300 ) ),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();

  }
  
  @override
  Widget build(BuildContext context) {

    final usuarioParaMandarMsg = chatService.usuarioParaMandarMsg;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar( // AVATAR DEL USUARIO
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: Text( usuarioParaMandarMsg!.nombre.substring(0,2) , style: const TextStyle(fontSize: 12)),
            ),
            const SizedBox( height: 3 ),
            Text( usuarioParaMandarMsg.nombre , style: const TextStyle(color: Colors.black, fontSize: 12),) // NOMBRE DEL USUARIO
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder( // LISTA DE LOS MENSAJES
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            )
          ),
          const Divider( height: 1 ),

          Container(
            color: Colors.white,
            child: _inputChat(),
          )
        ],
      )
      
    );
  }

  Widget _inputChat(){ //METODO DEL ESPACIO PARA MANDAR EL MENSAJE


    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [

            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto) { 
                  setState(() {
                    if (texto.trim().isNotEmpty){ // SI EL CAMPO NO ESTA VACIO
                      _estaEscribiendo = true; // EL USUARIO ESTA ESCRIBIENDO
                    } else { // DE LO CONTRARIO
                      _estaEscribiendo = false; // EL USUARIO NO ESTA ESTA ESCRIBIENDO
                    }
                  });
                } ,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              )
              
            ),

            Container(
              margin: const EdgeInsets.symmetric( horizontal: 4.0 ),
              child: !Platform.isIOS 
              ? CupertinoButton( // BOTON PARA ENVIAR UN MENSAJE EN IOS
                onPressed: _estaEscribiendo
                ? () =>_handleSubmit( _textController.text.trim() ) // SI EL USUARIO ESCRIBIO ALGO EL BOTON SE HABILITA
                : null, // BOTON PARA ENVIAR UN MENSAJE EN IOS
                child: const Text('Enviar'), // DE LO CONTRARIO SE BLOQUEA
              
              )
              : Container(
                margin: const EdgeInsets.symmetric( horizontal: 4.0 ),
                child: IconTheme(
                  data: IconThemeData(color: Colors.blue[400]),
                  child: IconButton( // BOTON PARA ENVIAR UN MENSAJE
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon(Icons.send),
                    onPressed: _estaEscribiendo
                    ? () =>_handleSubmit( _textController.text.trim() )
                    : null,
                  ),
                ),
              ),
            )
          ],
        ),
      ) 
    );
  }

  _handleSubmit(String texto){ // METODO DE FUNCIONES UNA VEZ YA ENVIADO EL MENSAJE
    
    if (texto.isEmpty)return;

    _textController.clear(); //LIMPIA EL CAMPO DE TEXTO
    _focusNode.requestFocus(); // SACA EL TECLADO

    final newMessage = ChatMessage(
      texto: texto, 
      uid: authService.usuario!.uid,
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {_estaEscribiendo = false;});

    socketService.socket.emit('mensaje-personal', { //! LO QUE VAYAMOS A ENVIAR AL SERVIDOR TIENEN QUE SER LOS MISMOS ITEMS QUE ESTAN DEFINIDOS EN LOS MODELOS, DE LO CONTRARIO NO SERAN GRABADOS EN LA BASE DE DATOS
      'de': authService.usuario!.uid,
      'para': chatService.usuarioParaMandarMsg!.uid,
      'msg': texto
    });

    
  }
  @override
  void dispose() { //SIRVE PARA LIMPIAR LA PANTALLA, ELIMINAR ANIMACIONES Y DEJAR DE ESCUCHAR MENSAJES,TODO ESTO CON FIN DE OPTIMMIZAR RECURSOS

    for(ChatMessage message in _messages){
      message.animationController.dispose(); // 
    }
    
    socketService.socket.off('mensaje-personal'); // DEJA DE ESCUCHAR EL EVENTO

    super.dispose();
  }
}