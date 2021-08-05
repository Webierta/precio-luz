import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/estados.dart';
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
    Periodo periodoAhora = Tarifa.getPeriodo(DateTime.now().toLocal());
    //String periodoAhoraNombre = (Tarifa.getPeriodo(DateTime.now().toLocal())).nombre;
    String periodoAhoraNombre = Tarifa.getPeriodoNombre(periodoAhora);
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

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Hoy a las $horaMin',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FittedBox(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Min', // precios.first
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(color: Colors.white),
                              ),
                              Text(
                                'Max', // precios.last
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(color: Colors.white),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(color: Colors.white),
                              ),
                              Text(
                                '${precioMax.toStringAsFixed(3)}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Theme(
                data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                child: Chip(
                  avatar: CircleAvatar(
                    backgroundColor: Color(0xFF1565C0),
                    //radius: 15,
                    child: Tarifa.getIconPeriodo(periodoAhora, size: 20),
                  ),
                  label: Text('P. $periodoAhoraNombre'),
                  labelStyle: TextStyle(color: Colors.white),
                  shape: StadiumBorder(side: BorderSide(width: 1, color: Color(0xFF1565C0))),
                ),
              ),
              //const SizedBox(width: 30),
              Theme(
                data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                child: Chip(
                  avatar: CircleAvatar(
                    backgroundColor: Color(0xFF1565C0),
                    //radius: 15,
                    child: Icon(
                      desviacionHoy > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 25,
                      color: desviacionHoy > 0 ? Colors.red : Colors.green,
                    ),
                  ),
                  label: FittedBox(child: Text('${desviacionHoy.toStringAsFixed(4)} €')),
                  labelStyle: TextStyle(color: Colors.white),
                  shape: StadiumBorder(side: BorderSide(width: 1, color: Color(0xFF1565C0))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
