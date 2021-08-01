import 'package:flutter/material.dart';

const TextStyle textBlanco = TextStyle(color: Colors.white);
const TextStyle textBlanco70 = TextStyle(color: Colors.white70);

class GeneracionError extends StatelessWidget {
  const GeneracionError({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ListTile(
          title: Text('Renovables', style: textBlanco),
          trailing: Text('N/D', style: textBlanco),
        ),
        ListTile(
          title: Text('No Renovables', style: textBlanco),
          trailing: Text('N/D', style: textBlanco),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text('Datos no disponibles', style: textBlanco70),
          ),
        ),
      ],
    );
  }
}
