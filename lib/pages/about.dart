import 'package:flutter/material.dart';
import '../widgets/read_file.dart';
import '../widgets/head.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Head(),
                const Icon(Icons.code, size: 60, color: Color(0xFF1565C0)),
                Text(
                  'Versión 2.4.1', // VERSION
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  'Copyleft 2020-2021\nJesús Cuerda (Webierta)',
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
                const FittedBox(
                  child: Text('All Wrongs Reserved. Licencia GPLv3'),
                ),
                const Divider(),
                const SizedBox(height: 10.0),
                const ReadFile(archivo: 'assets/files/about.txt'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
