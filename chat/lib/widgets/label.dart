// LABELS PARA GUIAR A LOS USUARIOS ENTRE LA PANTALLA DEL LOGIN Y EL REGISTRO
// TIENEN QUE TENER UNA RUTA DE NAVEGACION DE PANTALLA, UN TITULO Y UN SUBTITULO

import 'package:flutter/material.dart';

class Label extends StatelessWidget {

  final String ruta;
  final String titulo;
  final String subtitulo;
  
  const Label({
    super.key, 
    required this.ruta,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          titulo, 
          style: const TextStyle(
            color: Colors.black54, 
            fontSize: 15, 
            fontWeight: FontWeight.w300
          )
        ),
        
        const SizedBox(height: 10),

        GestureDetector(
          child: Text(
            subtitulo, 
            style: TextStyle(
              color: Colors.blue[600], 
              fontSize: 15, 
              fontWeight: FontWeight.bold 
            )
          ),
          onTap: ()=> Navigator.pushReplacementNamed(context, ruta),
        )
      ],
    );
  }
}