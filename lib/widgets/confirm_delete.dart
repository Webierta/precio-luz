import 'package:flutter/material.dart';

Future<bool> confirmDelete(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Eliminar datos'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Esta acción elimina el archivo de todas las consultas realizadas. '
                  'También puedes borrar los datos de cada fecha por separado desplazándola hacia la derecha.'),
              SizedBox(height: 10),
              Text('¿Eliminar todas los archivos?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('ACEPTAR'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          TextButton(
            child: Text('CANCELAR'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      );
    },
  );
}
