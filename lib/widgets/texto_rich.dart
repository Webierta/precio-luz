import 'package:flutter/material.dart';

class TextoRich extends StatelessWidget {
  final String texto;
  final Color color;

  const TextoRich(this.texto, this.color);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: WidgetSpan(
        child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: color,
            ),
            child: Text(texto, style: Theme.of(context).textTheme.headline6)),
      ),
    );
  }
}
