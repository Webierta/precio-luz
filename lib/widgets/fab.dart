import 'package:flutter/material.dart';
import '../utils/constantes.dart';
import 'head.dart';

class Fab extends StatelessWidget {
  const Fab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    openDialog() {
      Navigator.of(context).push(
        MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(title: const Text('Ayuda')),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: const <Widget>[
                        Head(),
                        Icon(Icons.help_outline,
                            size: 60, color: Color(0xFF1565C0)),
                        Divider(),
                        SizedBox(height: 10.0),
                        Text(
                            'La aplicación admite dos métodos para la obtención de los datos: '
                            'con la API oficial (recomendado) y desde un archivo.',
                            style: sizeText20),
                        SizedBox(height: 10.0),
                        Text(
                            'Para utilizar la API se necesita autentificarse con un código de acceso personal '
                            '(token) gestionado por el Sistema de Información del Operador del Sistema (e·sios).',
                            style: sizeText20),
                        SizedBox(height: 10.0),
                        Text(
                            'El segundo método, la extracción de datos desde un archivo, es un proceso '
                            'potencialmente más lento, menos eficiente y más propenso a errores.',
                            style: sizeText20),
                        SizedBox(height: 10.0),
                        Icon(Icons.warning,
                            color: Color(0xFFF44336), size: 60.0),
                        Text(
                            'IMPORTANTE: Si dispone y utiliza un token como código de acceso al '
                            'sistema REData de REE, debe tener en cuenta la advertencia de realizar '
                            'un uso responsable de la API y no ejecutar peticiones masivas, '
                            'redundantes o innecesarias. En REE se analiza la utilización de la API por '
                            'parte de los usuarios con el fin de detectar malas prácticas, siendo '
                            'cada usuario responsable del uso de su token personal. Esta aplicación '
                            'no asume ninguna responsabilidad sobre posibles acciones de REE '
                            'derivadas de un uso inadecuado o irresponsable de la API por parte de '
                            'los usuarios.',
                            style: sizeText20),
                      ],
                    ),
                  ),
                ),
              );
            },
            fullscreenDialog: true),
      );
    }

    return FloatingActionButton.extended(
      onPressed: () => openDialog(),
      icon: const Icon(Icons.help_outline),
      label: const Text('Ayuda'),
      backgroundColor: const Color(0xFFE91E63),
    );
  }
}
