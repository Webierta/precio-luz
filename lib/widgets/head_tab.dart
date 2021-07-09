import 'package:flutter/material.dart';

class HeadTab extends StatelessWidget {
  final String fecha;
  final String titulo;
  const HeadTab({Key key, this.fecha, this.titulo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Tarifa 2.0 TD', style: Theme.of(context).textTheme.headline6),
          ],
        ),
        Text(fecha, style: Theme.of(context).textTheme.subtitle1),
        Text(titulo, style: Theme.of(context).textTheme.bodyText1),
        Divider(),
      ],
    );
  }
}
