import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/datos.dart';
import '../utils/tarifa.dart';

class DatosHoy extends StatelessWidget {
  final Datos dataHoy;
  const DatosHoy({Key key, this.dataHoy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime hoy = DateTime.now().toLocal();
    int hora = hoy.hour;
    String horaMin = DateFormat('HH:mm').format(hoy);
    double precioHoy = dataHoy.getPrecio(dataHoy.preciosHora, hora);
    var periodoAhora = Tarifa.getPeriodo(DateTime.now().toLocal());
    var desviacionHoy =
        dataHoy.preciosHora[hora] - dataHoy.calcularPrecioMedio(dataHoy.preciosHora);
    double anchoScreen = MediaQuery.of(context).size.width;

    List<double> listaPrecios = dataHoy.preciosHora;
    double precioMin = dataHoy.precioMin(listaPrecios);
    double precioMax = dataHoy.precioMax(listaPrecios);
    Color color = Tarifa.getColorCara(listaPrecios, precioHoy);

    Map<int, double> mapPreciosOrdenados = dataHoy.ordenarPrecios(listaPrecios);
    List<double> preciosOrdenados = mapPreciosOrdenados.values.toList();
    var indexPrecio = preciosOrdenados.indexOf(precioHoy) + 1;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Hoy a las $horaMin',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${precioHoy.toStringAsFixed(5)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    const Text('€/kWh', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Min', // precios.first
                        style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
                      ),
                      Text(
                        'Max', // precios.last
                        style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  LinearProgressIndicator(value: indexPrecio / 24, color: color),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${precioMin.toStringAsFixed(3)}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '€/kWh',
                        style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
                      ),
                      Text(
                        '${precioMax.toStringAsFixed(3)}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF1565C0),
                    radius: 15,
                    child: Tarifa.getIconPeriodo(periodoAhora, size: 25),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${describeEnum(periodoAhora).toUpperCase()}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF1565C0),
                    radius: 15,
                    child: Icon(
                      desviacionHoy > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 30,
                      color: desviacionHoy > 0 ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${desviacionHoy.toStringAsFixed(4)} €',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            RotatedBox(
              quarterTurns: 2,
              child: Icon(
                Icons.lightbulb,
                color: Tarifa.getColorFondo(precioHoy),
                size: anchoScreen / 3,
              ),
            ),
            Positioned(
              top: anchoScreen / 7.5,
              child: Tarifa.getIconCara(
                dataHoy.preciosHora,
                dataHoy.preciosHora[hora],
                size: anchoScreen / 6,
              ),
            ),
          ],
        ),
      ],
    );
  }
}