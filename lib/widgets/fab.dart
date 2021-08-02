import 'package:flutter/material.dart';

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
                        Icon(Icons.help_outline, size: 60, color: Color(0xFF1565C0)),
                        Divider(),
                        SizedBox(height: 10.0),
                        Text('La aplicación admite dos métodos para la obtención de los datos: '
                            'con la API oficial (recomendado) y desde un archivo.'),
                        SizedBox(height: 10.0),
                        Text(
                            'Para utilizar la API se necesita autentificarse con un código de acceso personal '
                            '(token) que se obtiene gratuitamente solicitándolo por email a consultasios@ree.es'),
                        SizedBox(height: 10.0),
                        Text('Solo es necesario introducir el token personal la primera vez '
                            'puesto que queda almacenado en los ajustes de la aplicación.'),
                        SizedBox(height: 10.0),
                        Text(
                            'El segundo método, la extracción de datos desde un archivo, es un proceso más lento, '
                            'menos eficiente y más propenso a errores.'),
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
