import 'package:flutter/material.dart';
import 'head.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Head(),
                Icon(
                  Icons.code, //wb_incandescent,
                  size: 60,
                  color: Colors.cyan[700],
                ),
                Text(
                  'Versión 2.0.0',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  'Copyleft 2020-2021\nJesús Cuerda (Webierta)',
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      child: Text('All Wrongs Reserved. Licencia GPLv3'),
                    ),
                  ),
                ),
                Divider(),
                SizedBox(height: 10.0),
                _textoABout(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<String> _textoABout(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString('assets/files/about.txt'),
      builder: (context, snapshot) {
        return Text(
          snapshot.data ?? 'Error: archivo no encontrado',
          softWrap: true,
          style: TextStyle(fontSize: 22, color: Colors.black87),
        );
      },
    );
  }
}
