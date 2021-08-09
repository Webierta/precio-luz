import 'package:flutter/material.dart';
import 'package:charts_painter/chart.dart';

import '../utils/constantes.dart';
import '../services/datos.dart';

class GraficoMain extends StatelessWidget {
  final Datos dataHoy;
  const GraficoMain({Key key, this.dataHoy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<double> precios = List.from(dataHoy.preciosHora);
    var axisMin = (dataHoy.precioMin(precios)) - 0.01;
    double altoScreen = MediaQuery.of(context).size.height;
    DateTime hoy = DateTime.now().toLocal();
    int hora = hoy.hour;
    int horaValor = -1;

    return ClipPath(
      clipper: kBorderClipper,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: double.infinity,
        height: altoScreen / 3,
        decoration: kBoxDeco,
        child: Chart(
          state: ChartState.line(
            ChartData.fromList(
              precios.map((e) => BubbleValue<void>(e)).toList(),
              axisMin: axisMin,
            ),
            itemOptions: BubbleItemOptions(
              colorForValue: (_, value, [min]) {
                horaValor++;
                if (horaValor > 23) {
                  horaValor = 0;
                }
                if (value != null) {
                  /* var indice = precios.indexOf(value);                  
                  if (indice == hora) {
                    return Colors.white;
                  } */
                  if (hora == horaValor) {
                    return Colors.white;
                  }
                }
                return Colors.transparent;
              },
            ),
            backgroundDecorations: [
              HorizontalAxisDecoration(
                axisStep: 0.01,
                showLines: true,
                lineWidth: 0.1,
              ),
              VerticalAxisDecoration(
                showLines: true,
                lineWidth: 0.1,
                legendFontStyle: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontSize: 10, color: Colors.white54),
                legendPosition: VerticalLegendPosition.bottom,
                axisStep: 1.0,
                showValues: true,
              ),
              TargetLineDecoration(
                target: dataHoy.calcularPrecioMedio(dataHoy.preciosHora),
                targetLineColor: Colors.blue,
                lineWidth: 1,
              ),
            ],
            foregroundDecorations: [
              SparkLineDecoration(
                lineColor: Colors.white,
                lineWidth: 2,
                smoothPoints: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
