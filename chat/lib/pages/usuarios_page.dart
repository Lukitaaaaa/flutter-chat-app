// PANTALLA DE LOS USUARIOS

// APPBAR QUE TIENE EL NOMBRE DEL USUARIO LOGUEADO, BOTON DE LOGOUT Y SIMBOLO DE ESTADO DE LA CONEXION
// LISTA DE LOS USUARIOS QUE TIENE SU NOMBRE Y EL ESTADO DE CONEXION
// FORMA DE REFRESCAR LA PANTALLA Y LA INFORMACION QUE CONTIENE LA MISMA 

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/models/usuario.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:chat_app/services/socket_services.dart';
import 'package:chat_app/services/usuarios_services.dart';

class UsuarioPage extends StatefulWidget {
  const UsuarioPage({super.key});


  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {

  final usuarioServices = UsuarioService();

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final socketServices = Provider.of<SocketService>(context);

    final authServices = Provider.of<AuthServices>(context);
    
    final usuario = authServices.usuario;

    return Scaffold(
      appBar: AppBar( 
        title: Text(usuario!.nombre, style: const TextStyle(color: Colors.black87)), //NOMBRE DEL USUARIO
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton( // BOTON DE LOGOUT
          icon: const Icon(Icons.exit_to_app, color: Colors.black87,), 
          onPressed: () { // AL PRESIONAR SE DESCONECTA DEL SERVER, SE BORRA SU TOKEN Y VA A LA PANTALLA DEL LOGIN

            socketServices.disconnect();
            AuthServices.deleteToken();
            Navigator.pushReplacementNamed(context, 'login');

          },
        ),
        actions: [
          Container( // SIMBOLO DE ESTADO DE CONEXION
            margin: const EdgeInsets.only(right: 10),
            
            child: ( socketServices.serverStatus == ServerStatus.Online )
            ? Icon(Icons.check_circle, color: Colors.blue[400]) //SI ESTOY CONECTADO AL SERVER MUESTRA ESTE ICONO
            : const Icon(Icons.offline_bolt, color: Colors.red)// DE LO CONTRARIO MUESTRA ESTE
            

          )
        ],
      ),
      body: SmartRefresher( // PARA REFRESCAR LA PANTALLA
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue,
        ),
        child: _listWiewUsuarios(),
      )
    );
  }

  ListView _listWiewUsuarios() { // METODO DE LA LISTA DE LOS USUARIOS
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTile( usuarios[i] ), 
      separatorBuilder: (_, i) => const Divider(), 
      itemCount: usuarios.length
    );
  }

  ListTile _usuarioListTile(Usuario usuario) { 
    return ListTile(
      title: Text(usuario.nombre), //NOMBRE DEL USUARIO
      subtitle: Text(usuario.email), // EMAIL DEL USUARIO
      leading: CircleAvatar( // AVATAR DEL USUARIO
        backgroundColor: Colors.blue[100], 
        child: Text(usuario.nombre.substring(0,2)), // AVATAR DEL USUARIO
      ),
      trailing: Container( //ESTADO DE CONEXION DEL USUARIO
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green[300] : Colors.red, //SI ESTA CONECTADO AL SERVER SE MUESTRA UN PUNTO VERDE||DE LO CONTRARIO SE MUESTRA UN PUNTO ROJO
          borderRadius: BorderRadius.circular(100)
        ),
      ),
      onTap: (){ // AL PRESIONAR SE DIRIJE A LA PAGINA DEL CHAT DE ESE USUARIO
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioParaMandarMsg = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );

      
  }
  _cargarUsuarios() async { //METODO PARA CARGAR EL USUARIO AL REFRESCARSE LA PANTALLA

    

    usuarios = await usuarioServices.getUsuarios();
    setState(() {
      
    });

    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();

  }
}

