import 'package:charts_painter/chart.dart';
import 'package:flutter/material.dart';

import '../utils/estados.dart';
import '../utils/tarifa.dart';
import '../services/datos.dart';

class Grafico extends StatefulWidget {
  final Datos data;
  final String fecha;

  const Grafico({Key key, this.data, this.fecha}) : super(key: key);

  @override
  _GraficoState createState() => _GraficoState();
}

class _GraficoState extends State<Grafico> {
  List<double> precios;
  int _selectedItem;

  @override
  void initState() {
    precios = List.from(widget.data.preciosHora);
    DateTime hoy = DateTime.now().toLocal();
    int hora = hoy.hour;
    _selectedItem = hora;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gráfico PVPC')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today, size: 20),
                  const SizedBox(width: 6),
                  Text(widget.fecha, style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Expanded(
                child: FractionallySizedBox(
                  widthFactor: 0.92,
                  child: Chart(
                    state: ChartState.bar(
                      ChartData.fromList(
                        precios.map((e) => BarValue<void>(e)).toList(),
                      ),
                      itemOptions: BarItemOptions(
                        //padding: const EdgeInsets.symmetric(horizontal: 1.0),
                        colorForValue: (_, value, [min]) {
                          if (value != null) {
                            var indice = precios.indexOf(value) ?? 0;
                            Periodo periodo = Tarifa.getPeriodo(
                                widget.data.getDataTime(widget.data.fecha, indice));
                            return Tarifa.getColorPeriodo(periodo);
                          }
                          return Colors.grey;
                        },
                      ),
                      behaviour: ChartBehaviour(
                        onItemClicked: (index) {
                          if (index > -1) {
                            setState(() {
                              _selectedItem = index < 0 ? 0 : index;
                              _selectedItem = index > 23 ? 23 : index;
                            });
                          } else {
                            index = 0;
                          }
                        },
                      ),
                      backgroundDecorations: [
                        HorizontalAxisDecoration(
                          axisStep: 0.01,
                          showLines: true,
                        ),
                        VerticalAxisDecoration(
                          showLines: false,
                          //legendFontStyle: Theme.of(context).textTheme.caption,
                          legendFontStyle:
                              Theme.of(context).textTheme.caption.copyWith(fontSize: 10),
                          legendPosition: VerticalLegendPosition.bottom,
                          axisStep: 1.0,
                          showValues: true,
                        ),
                      ],
                      foregroundDecorations: [
                        TargetLineDecoration(
                          target: widget.data.calcularPrecioMedio(widget.data.preciosHora),
                          targetLineColor: Colors.blue,
                        ),
                        SelectedItemDecoration(
                          _selectedItem,
                          selectedColor: Tarifa.getColorPeriodo(Tarifa.getPeriodo(
                              widget.data.getDataTime(widget.data.fecha, _selectedItem))),
                          textColor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton.extended(
          elevation: 10,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            side: BorderSide(color: Colors.white, width: 2.0),
          ),
          label: SizedBox(
            width: 100,
            child: Center(
              child: Column(
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '${_selectedItem}h - ${_selectedItem + 1}h',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text('${precios[_selectedItem]} €/kWh'),
                  ),
                ],
              ),
            ),
          ),
          onPressed: null,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
