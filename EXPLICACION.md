**EXPLICACION DE LAS FUNCIONES DE LA APP**

#### En esta de app de chat cuenta con un backend server que cuenta con las siguientes funciones: 

# autenticacion de usuarios mediante jasonWebTokens.

# Una base de datos que almacenara a los usuarios con sus emails, passwords y nombres.

# Comunicacion entre los usuarios mediante sockets

# almacenamiento de los mensajes que son enviados entre los usuarios.

**EXPICLACION DE CADA LIBRERIA, QUE ARCHIVOS TIENEN Y PARA QUE SIRVEN.**

#### En la libreria "Global" se encuentera el archivo enviroment que sirve para almacenar las variables de entorno o enviroment. ¿Que son las variables de entorno? Las variables de entorno son un conjunto de valores que contienen información útil del programa y de los sistemas que están utilizando los usuarios para su ejecución. Afectan a cualquier software y resultan especialmente útiles de cara al backend. En este caso las variables de entorno que ocupamos son para la comunicacion entre la app y nuestro backend server.

#### En la libreria "Helpers" se encuentra es archivo mostrar_alerta que sirve para dar un aviso cuando el usuario se equivoca en un campo al momento de logearse o registrarse. por ejemplo: cuando el usuario introduce una contrañesa incorrecta o un email no existente al intentar logearse o introduce un email ya existente al intentar registrarse.

#### En la libreria "Models" se encuentran los modelos generados por la pagina web QUICKTYPE

#### En la libreria "Pages" se encuentran las pantallas visuales de la applicacion: una pantalla de carga, el login, el registro, de los usuarios y la del chat.

#### En la libreria "Routes" se encuentra el archivo routes que definen el nombre de las rutas para cada pantalla de la aplicacion. Su funcion no es mas que por optimizacion y no sobrecargar el main.dart

#### En la libreria "Services" se encuentran los archivos que nos serviran para la comunicacion con el servidor y funcionalidades de nuestra app. 

# auth_services: este archivo se encarga de la autenticacion y registro del usuario para almacenarlo en la base de datos y asignarle un token valido

# chat_services: este archivo se encarga de recibir la lista de mensajes que fueron almacenados en la base de datos

# socket_services: este archivo se encarga de la comunicacion mediante sockets entre la app, el server y la base de datos

# usuarios_services: este archivo se encarga de recibir todos los usuarios que se registraron 

#### En la libreria "Widgets" se encuentran los archivos que contienen diferentes elementos visuales que se repiten en la pantalla del login y el registro como el boton azul para ingresar a la pantalla de usuarios(boton_ingresar.dart), el logo(logo.dart), los labels(label.dart) y los campos del formulario de informacion del usuario(custom_input.dart). Tambien se encuentra el archivo(chat_message.dart) que le da un diseño a los mensajes enviados y a los mensajes recibidos. 

**PAQUETES UTILIZADOS Y SUS VERSIONES**

# cupertino_icons: ^1.0.2
# pull_to_refresh: ^2.0.0
# provider: ^6.0.4
# http: ^0.13.5
# flutter_secure_storage: ^6.1.0
# socket_io_client: ^2.0.0

**VERSION DE FLUTTER**

# 3.3.8

