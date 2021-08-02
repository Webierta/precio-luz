import 'package:flutter/material.dart';
import '../utils/estados.dart';

const TextStyle textBlanco = TextStyle(color: Colors.white);
const TextStyle textBlanco70 = TextStyle(color: Colors.white70);

class GeneracionError extends StatelessWidget {
  const GeneracionError({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(Generacion.renovable.tipo, style: textBlanco),
          trailing: Text('N/D', style: textBlanco),
        ),
        ListTile(
          title: Text(Generacion.noRenovable.tipo, style: textBlanco),
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
