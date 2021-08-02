//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/constantes.dart';
import '../services/datos_generacion.dart';
import '../utils/estados.dart';
import '../services/datos.dart';
import '../utils/tarifa.dart';
import 'balance_generacion.dart';
import 'datos_hoy.dart';
import 'generacion_error.dart';
import 'grafico_main.dart';
import 'hoja_calendario.dart';
import 'list_tile_fecha.dart';

class TabMain extends StatelessWidget {
  final String fecha;
  final Datos data;
  final Datos dataHoy;
  final double safePadding;
  final DatosGeneracion dataGeneracion;
  final Future<Map<String, double>> generacion;

  const TabMain(
      {Key key,
      this.fecha,
      this.data,
      this.dataHoy,
      this.safePadding,
      this.dataGeneracion,
      this.generacion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var periodoMin = Tarifa.getPeriodo(data.getDataTime(
      data.fecha,
      data.getHour(data.preciosHora, data.precioMin(data.preciosHora)),
    ));
    var periodoMax = Tarifa.getPeriodo(data.getDataTime(
      data.fecha,
      data.getHour(data.preciosHora, data.precioMax(data.preciosHora)),
    ));
    var desviacionMin =
        data.precioMin(data.preciosHora) - data.calcularPrecioMedio(data.preciosHora);
    var desviacionMax =
        data.precioMax(data.preciosHora) - data.calcularPrecioMedio(data.preciosHora);
    var horaPeriodoMin = data.getHora(data.preciosHora, data.precioMin(data.preciosHora));
    var horaPeriodoMax = data.getHora(data.preciosHora, data.precioMax(data.preciosHora));
    var precioPeriodoMin = data.precioMin(data.preciosHora).toStringAsFixed(5);
    var precioPeriodoMax = data.precioMax(data.preciosHora).toStringAsFixed(5);
    double altoScreen = MediaQuery.of(context).size.height;

    return Container(
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
          DatosHoy(dataHoy: dataHoy),
          const SizedBox(height: 10),
          GraficoMain(dataHoy: dataHoy),
          SizedBox(height: altoScreen / 20),
          Column(
            children: [
              HojaCalendario(fecha: fecha), // data.fecha
              SizedBox(height: altoScreen / 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(
                  children: const [
                    Icon(Icons.access_time, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text(
                      'Precios mínimo y máximo',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              ClipPath(
                clipper: kBorderClipper,
                child: Container(
                  //padding: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  width: double.infinity,
                  decoration: kBoxDeco,
                  child: Column(
                    children: [
                      ListTileFecha(
                        periodo: periodoMin,
                        hora: horaPeriodoMin,
                        precio: precioPeriodoMin,
                        desviacion: desviacionMin,
                      ),
                      Divider(color: Colors.white70, indent: 20, endIndent: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTileFecha(
                          periodo: periodoMax,
                          hora: horaPeriodoMax,
                          precio: precioPeriodoMax,
                          desviacion: desviacionMax,
                        ),
                      ),
                      Divider(color: Colors.white70, indent: 20, endIndent: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Precio Medio: ${(data.calcularPrecioMedio(data.preciosHora)).toStringAsFixed(5)} €/kWh',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: altoScreen / 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: const [
                Icon(Icons.bolt, color: Colors.white, size: 18),
                SizedBox(width: 4),
                Text(
                  'Balance Generación',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          ClipPath(
            clipper: kBorderClipper,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
              width: double.infinity,
              decoration: kBoxDeco,
              child: dataGeneracion.status == StatusGeneracion.error
                  ? Container(child: const GeneracionError())
                  : FutureBuilder(
                      future: generacion,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done ||
                            snapshot.connectionState == ConnectionState.waiting ||
                            snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data.isEmpty ||
                            dataGeneracion.mapRenovables.isEmpty ||
                            dataGeneracion.mapNoRenovables.isEmpty ||
                            !snapshot.data.containsKey(Generacion.renovable.texto) ||
                            !snapshot.data.containsKey(Generacion.noRenovable.texto)) {
                          return const GeneracionError();
                        } else {
                          var total = snapshot.data[Generacion.renovable.texto] +
                              snapshot.data[Generacion.noRenovable.texto];
                          var mapRenovables = <String, double>{};
                          var mapNoRenovables = <String, double>{};
                          mapRenovables = Map.from(dataGeneracion.mapRenovables);
                          mapNoRenovables = Map.from(dataGeneracion.mapNoRenovables);
                          var sortedMapRenovables = Map.fromEntries(mapRenovables.entries.toList()
                            ..sort((e1, e2) => (e2.value).compareTo((e1.value))));
                          var sortedMapNoRenovables = Map.fromEntries(
                              mapNoRenovables.entries.toList()
                                ..sort((e1, e2) => (e2.value).compareTo((e1.value))));
                          //double _renovableValue = snapshot.data['Generación renovable'];

                          String calcularPorcentaje(double valor) {
                            var total = snapshot.data[Generacion.renovable.texto] +
                                snapshot.data[Generacion.noRenovable.texto];
                            return ((valor * 100) / total).toStringAsFixed(1);
                          }

                          double valueLinearProgress(String typo) {
                            return (double.tryParse(calcularPorcentaje(snapshot.data[typo])) ??
                                    100) /
                                100;
                          }

                          return Column(
                            children: [
                              BalanceGeneracion(
                                sortedMap: sortedMapRenovables,
                                generacion: Generacion.renovable,
                                total: total,
                              ),
                              LinearProgressIndicator(
                                value: valueLinearProgress(Generacion.renovable.texto),
                                backgroundColor: Colors.grey,
                                color: Colors.green,
                              ),
                              SizedBox(height: 20),
                              BalanceGeneracion(
                                sortedMap: sortedMapNoRenovables,
                                generacion: Generacion.noRenovable,
                                total: total,
                              ),
                              LinearProgressIndicator(
                                value: valueLinearProgress(Generacion.noRenovable.texto),
                                backgroundColor: Colors.grey,
                                color: Colors.red,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    DateTime.now().difference(DateTime.parse(data.fecha)).inDays >=
                                            1
                                        ? 'Datos programados'
                                        : 'Datos previstos',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
            ),
          ),
          SizedBox(height: altoScreen / 20),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: const [
                Divider(color: Colors.blueGrey),
                Text('Fuente: REE (e·sios y REData)', style: TextStyle(color: Colors.white70)),
                Divider(color: Colors.blueGrey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
