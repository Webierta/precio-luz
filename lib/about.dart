import 'package:flutter/material.dart';
import 'head.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  static const String id = 'about';

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
                  'Versión 1.0.0',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  'Copyleft 2020\nJesús Cuerda (Webierta)',
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
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: Image.asset('assets/images/paypal.jpg'),
                  ),
                  onTap: () async {
                    const url =
                        'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=986PSAHLH6N4L';
                    if (await canLaunch(url)) {
                      await launch(url, forceSafariVC: false);
                    } else {
                      throw 'No se ha podido abrir la web';
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<String> _textoABout(BuildContext context) {
    return FutureBuilder(
      future:
          DefaultAssetBundle.of(context).loadString('assets/files/about.txt'),
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
