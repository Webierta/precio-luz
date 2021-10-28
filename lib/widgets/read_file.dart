import 'package:flutter/material.dart';

class ReadFile extends StatelessWidget {
  final String archivo;
  const ReadFile({Key key, this.archivo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString(this.archivo),
      builder: (context, snapshot) {
        return Text(
          snapshot.data ?? 'Error: archivo no encontrado',
          softWrap: true,
          style: TextStyle(fontSize: 20, color: Colors.black87),
        );
      },
    );
  }
}
