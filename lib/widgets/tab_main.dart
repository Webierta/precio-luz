import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/datos.dart';
import 'texto_rich.dart';
import '../utils/tarifa.dart';

class TabMain extends StatelessWidget {
  final String fecha;
  final Datos data;
  final Datos dataHoy;

  const TabMain({Key key, this.fecha, this.data, this.dataHoy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime hoy = DateTime.now().toLocal();
    int hora = hoy.hour;
    String horaMin = DateFormat('HH:mm').format(hoy);
    double precioHoy = dataHoy.getPrecio(dataHoy.preciosHora, hora);
    var periodoAhora = Tarifa.getPeriodo(DateTime.now().toLocal());
    var periodoMin = Tarifa.getPeriodo(data.getDataTime(
        data.fecha, data.getHour(data.preciosHora, data.precioMin(data.preciosHora))));
    var periodoMax = Tarifa.getPeriodo(data.getDataTime(
        data.fecha, data.getHour(data.preciosHora, data.precioMax(data.preciosHora))));
    var desviacionHoy =
        dataHoy.preciosHora[hora] - dataHoy.calcularPrecioMedio(dataHoy.preciosHora);
    var desviacionMin =
        data.precioMin(data.preciosHora) - data.calcularPrecioMedio(data.preciosHora);
    var desviacionMax =
        data.precioMax(data.preciosHora) - data.calcularPrecioMedio(data.preciosHora);

    return Column(
      children: <Widget>[
        Text('Tarifa 2.0 TD', style: Theme.of(context).textTheme.headline6),
        Card(
          color: Tarifa.getColorFondo(precioHoy),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text('PRECIO AHORA', style: Theme.of(context).textTheme.bodyText2),
                ListTile(
                  leading: Tarifa.getIconCara(dataHoy.preciosHora, dataHoy.preciosHora[hora]),
                  title: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${precioHoy.toStringAsFixed(5)} €/kWh',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hoy a las $horaMin'),
                      Row(
                        children: [
                          Tarifa.getIconPeriodo(periodoAhora),
                          const SizedBox(width: 10.0),
                          Text('${describeEnum(periodoAhora).toUpperCase()}'),
                        ],
                      ),
                    ],
                  ),
                  trailing: Column(
                    children: [
                      Flexible(
                        child: Icon(
                          desviacionHoy > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          size: 45,
                          color: desviacionHoy > 0 ? Colors.red : Colors.green,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '${desviacionHoy.toStringAsFixed(4)} €',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          color: Colors.blue[100],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                RichText(
                  text: WidgetSpan(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 8),
                          Text('$fecha', style: Theme.of(context).textTheme.headline6),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Hora más barata del día:',
                    style: Theme.of(context).textTheme.overline,
                  ),
                ),
                ListTile(
                  leading: Column(
                    children: [
                      Tarifa.getIconPeriodo(periodoMin),
                      Text(
                        '${describeEnum(periodoMin).toUpperCase()}',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  subtitle: Text('${(data.precioMin(data.preciosHora)).toStringAsFixed(5)} €/kWh'),
                  title: TextoRich(
                    '${data.getHora(data.preciosHora, data.precioMin(data.preciosHora))}',
                    Colors.green[300],
                  ),
                  trailing: Column(
                    children: [
                      Flexible(
                        child: Icon(
                          desviacionMin > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          size: 45,
                          color: desviacionMin > 0 ? Colors.red : Colors.green,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '${desviacionMin.toStringAsFixed(4)} €',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Hora más cara del día:',
                    style: Theme.of(context).textTheme.overline,
                  ),
                ),
                ListTile(
                  leading: Column(
                    children: [
                      Tarifa.getIconPeriodo(periodoMax),
                      Text(
                        '${describeEnum(periodoMax).toUpperCase()}',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  subtitle: Text('${(data.precioMax(data.preciosHora)).toStringAsFixed(5)} €/kWh'),
                  title: TextoRich(
                    '${data.getHora(data.preciosHora, data.precioMax(data.preciosHora))}',
                    Colors.red[300],
                  ),
                  trailing: Column(
                    children: [
                      Flexible(
                        child: Icon(
                          desviacionMax > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          size: 45,
                          color: desviacionMax > 0 ? Colors.red : Colors.green,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '${desviacionMax.toStringAsFixed(4)} €',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                    'Precio Medio: ${(data.calcularPrecioMedio(data.preciosHora)).toStringAsFixed(5)} €/kWh'),
              ],
            ),
          ),
        ),
        const Divider(color: Colors.blueGrey),
        const Text('Fuente: REE y elaboración propia'),
        const Divider(color: Colors.blueGrey),
      ],
    );
  }
}
