import 'package:flutter/material.dart';
import 'head.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Head(),
                Icon(
                  Icons.info_outline, //wb_incandescent,
                  size: 60,
                  color: Colors.cyan[700],
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
      future: DefaultAssetBundle.of(context).loadString('assets/files/info.txt'),
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
