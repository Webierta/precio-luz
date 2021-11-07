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
import 'list_tile_fecha.dart';

class TabMain extends StatefulWidget {
  final String fecha;
  final Datos data;
  final DatosGeneracion dataGeneracion;

  const TabMain({Key key, this.fecha, this.data, this.dataGeneracion}) : super(key: key);

  @override
  State<TabMain> createState() => _TabMainState();
}

class _TabMainState extends State<TabMain> {
  Periodo periodoMin;
  Periodo periodoMax;
  double desviacionMin;
  double desviacionMax;
  String horaPeriodoMin;
  String horaPeriodoMax;
  String precioPeriodoMin;
  String precioPeriodoMax;

  @override
  void initState() {
    periodoMin = Tarifa.getPeriodo(widget.data.getDataTime(
      widget.data.fecha,
      widget.data.getHour(widget.data.preciosHora, widget.data.precioMin(widget.data.preciosHora)),
    ));
    periodoMax = Tarifa.getPeriodo(widget.data.getDataTime(
      widget.data.fecha,
      widget.data.getHour(widget.data.preciosHora, widget.data.precioMax(widget.data.preciosHora)),
    ));
    desviacionMin = widget.data.precioMin(widget.data.preciosHora) -
        widget.data.calcularPrecioMedio(widget.data.preciosHora);
    desviacionMax = widget.data.precioMax(widget.data.preciosHora) -
        widget.data.calcularPrecioMedio(widget.data.preciosHora);
    horaPeriodoMin = widget.data
        .getHora(widget.data.preciosHora, widget.data.precioMin(widget.data.preciosHora));
    horaPeriodoMax = widget.data
        .getHora(widget.data.preciosHora, widget.data.precioMax(widget.data.preciosHora));
    precioPeriodoMin = widget.data.precioMin(widget.data.preciosHora).toStringAsFixed(5);
    precioPeriodoMax = widget.data.precioMax(widget.data.preciosHora).toStringAsFixed(5);
    super.initState();
  }

  double total() {
    return widget.dataGeneracion.generacion[Generacion.renovable.texto] +
        widget.dataGeneracion.generacion[Generacion.noRenovable.texto];
  }

  Map<String, double> sortedMapRenovables() {
    var mapRenovables = <String, double>{};
    mapRenovables = Map.from(widget.dataGeneracion.mapRenovables);
    return Map.fromEntries(
        mapRenovables.entries.toList()..sort((e1, e2) => (e2.value).compareTo((e1.value))));
  }

  Map<String, double> sortedMapNoRenovables() {
    var mapNoRenovables = <String, double>{};
    mapNoRenovables = Map.from(widget.dataGeneracion.mapNoRenovables);
    return Map.fromEntries(
        mapNoRenovables.entries.toList()..sort((e1, e2) => (e2.value).compareTo((e1.value))));
  }

  String calcularPorcentaje(double valor) {
    return ((valor * 100) / total()).toStringAsFixed(1);
  }

  double valueLinearProgress(String typo) {
    return (double.tryParse(calcularPorcentaje(widget.dataGeneracion.generacion[typo])) ?? 100) /
        100;
  }

  @override
  Widget build(BuildContext context) {
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
          DatosHoy(dataHoy: widget.data, fecha: widget.fecha),
          const SizedBox(height: 20),
          GraficoMain(dataHoy: widget.data, fecha: widget.fecha),
          SizedBox(height: altoScreen / 20),
          Column(
            children: [
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
                          'Precio Medio: ${(widget.data.calcularPrecioMedio(widget.data.preciosHora)).toStringAsFixed(5)} €/kWh',
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
              child: (widget.dataGeneracion.status == StatusGeneracion.error) ||
                      (widget.dataGeneracion.generacion?.isEmpty ?? true) ||
                      (widget.dataGeneracion.mapRenovables?.isEmpty ?? true) ||
                      (widget.dataGeneracion.mapNoRenovables?.isEmpty ?? true) ||
                      (!widget.dataGeneracion.generacion.containsKey(Generacion.renovable.texto)) ||
                      !widget.dataGeneracion.generacion.containsKey(Generacion.noRenovable.texto)
                  ? Container(child: const GeneracionError())
                  : Column(
                      children: [
                        BalanceGeneracion(
                          sortedMap: sortedMapRenovables(),
                          generacion: Generacion.renovable,
                          total: total(),
                        ),
                        LinearProgressIndicator(
                          value: valueLinearProgress(Generacion.renovable.texto),
                          backgroundColor: Colors.grey,
                          color: Colors.green,
                        ),
                        SizedBox(height: 20),
                        BalanceGeneracion(
                          sortedMap: sortedMapNoRenovables(),
                          generacion: Generacion.noRenovable,
                          total: total(),
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
                              DateTime.now().difference(DateTime.parse(widget.data.fecha)).inDays >=
                                      1
                                  ? 'Datos programados'
                                  : 'Datos previstos',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                      ],
                    ),
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
