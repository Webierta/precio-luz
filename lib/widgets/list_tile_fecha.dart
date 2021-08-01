import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/tarifa.dart';
import '../utils/estados.dart';

class ListTileFecha extends StatelessWidget {
  final Periodo periodo;
  final String hora;
  final String precio;
  final double desviacion;
  const ListTileFecha({Key key, this.periodo, this.hora, this.precio, this.desviacion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFF1565C0),
            radius: 15,
            child: Tarifa.getIconPeriodo(periodo, size: 25),
          ),
          const SizedBox(height: 4),
          Text(
            '${describeEnum(periodo).toUpperCase()}',
            style: TextStyle(fontSize: 10, color: Colors.white),
          ),
        ],
      ),
      title: Align(
        alignment: Alignment.topLeft,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '$hora',
            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w200),
          ),
        ),
      ),
      subtitle: Text('$precio €/kWh', style: const TextStyle(color: Colors.white)),
      trailing: Column(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFF1565C0),
            radius: 15,
            child: Icon(
              desviacion > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              size: 30,
              color: desviacion > 0 ? Colors.red : Colors.green,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${desviacion.toStringAsFixed(4)} €',
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
