import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import '../utils/estados.dart';
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

    Orientation orientation = MediaQuery.of(context).orientation;
    var cardHoy = CardHoy(
        precioHoy: precioHoy,
        dataHoy: dataHoy,
        hora: hora,
        horaMin: horaMin,
        periodoAhora: periodoAhora,
        desviacionHoy: desviacionHoy);

    var cardFecha = CardFecha(
        fecha: fecha,
        periodoMin: periodoMin,
        data: data,
        desviacionMin: desviacionMin,
        periodoMax: periodoMax,
        desviacionMax: desviacionMax);

    return Column(
      children: <Widget>[
        Text('Tarifa 2.0 TD', style: Theme.of(context).textTheme.headline6),
        orientation == Orientation.portrait
            ? Column(children: [cardHoy, cardFecha])
            : IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Expanded(child: cardHoy), Expanded(child: cardFecha)],
                ),
              ),
        const Divider(color: Colors.blueGrey),
        const Text('Fuente: REE y elaboración propia'),
        const Divider(color: Colors.blueGrey),
      ],
    );
  }
}

double getWidthContainer(Orientation orientation, double screenWide) {
  return orientation == Orientation.portrait ? screenWide - 30.0 : screenWide / 2;
}

class CardHoy extends StatelessWidget {
  final double precioHoy;
  final Datos dataHoy;
  final int hora;
  final String horaMin;
  final Periodo periodoAhora;
  final double desviacionHoy;

  const CardHoy({
    Key key,
    @required this.precioHoy,
    @required this.dataHoy,
    @required this.hora,
    @required this.horaMin,
    @required this.periodoAhora,
    @required this.desviacionHoy,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenWide = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Card(
      color: Tarifa.getColorFondo(precioHoy),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Tarifa.getColorBorder(precioHoy), width: 2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text('PRECIO AHORA', style: Theme.of(context).textTheme.bodyText2),
            Container(
              child: orientation == Orientation.portrait
                  ? null
                  : Tarifa.getIconCara(dataHoy.preciosHora, dataHoy.preciosHora[hora], size: 70),
            ),
            Container(
              //width: orientation == Orientation.portrait ? screenWide - 30.0 : screenWide / 2,
              width: getWidthContainer(orientation, screenWide),
              child: ListTile(
                leading: orientation == Orientation.portrait
                    ? Tarifa.getIconCara(dataHoy.preciosHora, dataHoy.preciosHora[hora])
                    : null,
                title: FittedBox(
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${precioHoy.toStringAsFixed(5)} €/kWh',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hoy a las $horaMin'),
                    Chip(
                      avatar: CircleAvatar(
                        backgroundColor: Colors.grey.shade800,
                        child: Tarifa.getIconPeriodo(periodoAhora, size: 24),
                      ),
                      label: Text(
                        '${describeEnum(periodoAhora).toUpperCase()}',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Tarifa.getColorPeriodo(periodoAhora),
                      elevation: 0.8,
                      shape: StadiumBorder(
                        side: BorderSide(
                          width: 1,
                          color: Tarifa.getColorBorder(precioHoy),
                        ),
                      ),
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
            ),
          ],
        ),
      ),
    );
  }
}

class CardFecha extends StatelessWidget {
  final String fecha;
  final Periodo periodoMin;
  final Datos data;
  final double desviacionMin;
  final Periodo periodoMax;
  final double desviacionMax;

  const CardFecha({
    Key key,
    @required this.fecha,
    @required this.periodoMin,
    @required this.data,
    @required this.desviacionMin,
    @required this.periodoMax,
    @required this.desviacionMax,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWide = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Card(
      color: Colors.blue[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Colors.blue, width: 2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 4),
            RichText(
              text: WidgetSpan(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$fecha',
                        style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
                      ),
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
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Container(
              //width: orientation == Orientation.portrait ? screenWide - 30.0 : (screenWide / 2),
              width: getWidthContainer(orientation, screenWide),
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade800,
                      radius: 14,
                      child: Tarifa.getIconPeriodo(periodoMin, size: 24),
                    ),
                    Text(
                      '${describeEnum(periodoMin).toUpperCase()}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                subtitle: Text(
                  '${(data.precioMin(data.preciosHora)).toStringAsFixed(5)} €/kWh',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Hora más cara del día:',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            Container(
              //width: orientation == Orientation.portrait ? screenWide - 20.0 : (screenWide / 2.2),
              width: getWidthContainer(orientation, screenWide),
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade800,
                      radius: 14,
                      child: Tarifa.getIconPeriodo(periodoMax, size: 24),
                    ),
                    Text(
                      '${describeEnum(periodoMax).toUpperCase()}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                subtitle: Text(
                  '${(data.precioMax(data.preciosHora)).toStringAsFixed(5)} €/kWh',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
            ),
            Text(
                'Precio Medio: ${(data.calcularPrecioMedio(data.preciosHora)).toStringAsFixed(5)} €/kWh'),
          ],
        ),
      ),
    );
  }
}
