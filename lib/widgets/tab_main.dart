import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/estados.dart';
import '../services/datos.dart';
import '../utils/tarifa.dart';

class TabMain extends StatelessWidget {
  final String fecha;
  final Datos data;
  final Datos dataHoy;
  final double safePadding;

  const TabMain({Key key, this.fecha, this.data, this.dataHoy, this.safePadding}) : super(key: key);

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
    var horaPeriodoMin = data.getHora(data.preciosHora, data.precioMin(data.preciosHora));
    var horaPeriodoMax = data.getHora(data.preciosHora, data.precioMax(data.preciosHora));
    var precioPeriodoMin = data.precioMin(data.preciosHora).toStringAsFixed(5);
    var precioPeriodoMax = data.precioMax(data.preciosHora).toStringAsFixed(5);

    Orientation orientation = MediaQuery.of(context).orientation;
    double altoScreen = MediaQuery.of(context).size.height;
    double anchoScreen = MediaQuery.of(context).size.width;

    return Container(
      height: orientation == Orientation.portrait ? altoScreen : altoScreen * 1.6,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFE3F2FD),
            Color(0xFF64B5F6),
            Color(0xFF1E88E5),
            Color(0xFF0D47A1)
          ],
          radius: 0.9,
          center: Alignment.topRight,
          stops: [0.1, 0.3, 0.5, 0.7, 0.9],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hoy a las $horaMin',
                      style: const TextStyle(color: Colors.white),
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
          ),
          SizedBox(height: altoScreen / 10),
          Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text('$fecha', style: TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 4),
              ClipPath(
                clipper: ShapeBorderClipper(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    //borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Color.fromRGBO(255, 255, 255, 0.1),
                    border: Border(
                      bottom: BorderSide(color: Color(0xFF1565C0), width: 1.5),
                      left: BorderSide(color: Color(0xFF1565C0), width: 1.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Hora más barata del día:',
                          style:
                              Theme.of(context).textTheme.caption.copyWith(color: Colors.white70),
                        ),
                      ),
                      ListTileFecha(
                        periodo: periodoMin,
                        hora: horaPeriodoMin,
                        precio: precioPeriodoMin,
                        desviacion: desviacionMin,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Hora más cara del día:',
                          style:
                              Theme.of(context).textTheme.caption.copyWith(color: Colors.white70),
                        ),
                      ),
                      ListTileFecha(
                        periodo: periodoMax,
                        hora: horaPeriodoMax,
                        precio: precioPeriodoMax,
                        desviacion: desviacionMax,
                      ),
                      Text(
                        'Precio Medio: ${(data.calcularPrecioMedio(data.preciosHora)).toStringAsFixed(5)} €/kWh',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: const [
                Divider(color: Colors.blueGrey),
                Text('Fuente: REE y elaboración propia', style: TextStyle(color: Colors.white70)),
                Divider(color: Colors.blueGrey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
      title: Text(
        '$hora',
        style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w200),
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
