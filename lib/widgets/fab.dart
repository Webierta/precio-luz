import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/constantes.dart';
import 'head.dart';

class Fab extends StatelessWidget {
  const Fab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* void _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Could not launch PayPal payment website.'),
        ));
      }
    } */
    Future<void> _launchURL(String url) async {
      if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Could not launch $url'),
        ));
      }
    }

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
                      children: <Widget>[
                        const Head(),
                        const Icon(Icons.help_outline, size: 60, color: Color(0xFF1565C0)),
                        const Divider(),
                        const SizedBox(height: 10.0),
                        const Text(
                          'La aplicación dispone de dos métodos para ejecutar '
                          'la consulta de datos: con al APi oficial (recomendado) '
                          'y desde un archivo.',
                          style: sizeText20,
                        ),
                        const SizedBox(height: 10.0),
                        RichText(
                            text: TextSpan(
                          children: [
                            TextSpan(
                              style: size22Black,
                              text:
                                  'Para utilizar la API se necesita autentificarse con un código de acceso personal '
                                  '(token) gestionado por el ',
                            ),
                            TextSpan(
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 22,
                                decoration: TextDecoration.underline,
                              ),
                              text: 'Sistema de Información del Operador del Sistema (e·sios).',
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    () => _launchURL('https://www.esios.ree.es/es/pagina/api'),
                            ),
                          ],
                        )),
                        const SizedBox(height: 10.0),
                        const Text(
                            'Si no dispones de token deja el cuadro de texto vacío y la aplicación '
                            'descargará los datos desde un archivo (este proceso puede ser potencialmente '
                            'más lento, menos eficiente y más propenso a errores).',
                            style: sizeText20),
                        const SizedBox(height: 10.0),
                        const Icon(Icons.warning, color: Color(0xFFF44336), size: 60.0),
                        const Text(
                            'IMPORTANTE: Si utilizas un token como código de acceso al '
                            'sistema REData de REE, debes tener en cuenta la advertencia de realizar '
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
