import 'package:flutter/material.dart';
import 'head_tab.dart';
import '../utils/estados.dart';
import '../utils/tarifa.dart';
import '../services/datos.dart';

class TabPage extends StatelessWidget {
  final int page;
  final String fecha;
  final String titulo;
  final Datos data;
  const TabPage({Key key, this.page, this.fecha, this.titulo, this.data}) : super(key: key);

  Color getColorPeriodo(int index) {
    var periodo = Tarifa.getPeriodo(data.getDataTime(data.fecha, index));
    if (periodo == Periodo.valle) {
      return Colors.green[300];
    } else if (periodo == Periodo.punta) {
      return Colors.red[300];
    } else {
      return Colors.amberAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HeadTab(fecha: fecha, titulo: titulo),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.preciosHora.length,
            itemBuilder: (context, index) {
              List<double> precios;
              int _index;
              if (page == 2) {
                precios = data.preciosHora;
                _index = index;
              } else {
                //var listaPrecios = List.from(data.preciosHora);
                List<double> listaPrecios = data.preciosHora;
                var mapPrecios = listaPrecios.asMap();
                var sortedKeys = mapPrecios.keys.toList(growable: false)
                  ..sort((k1, k2) => mapPrecios[k1].compareTo(mapPrecios[k2]));
                Map<int, double> mapPreciosSorted = Map.fromIterable(
                  sortedKeys,
                  key: (k) => k,
                  value: (k) => mapPrecios[k],
                );
                precios = mapPreciosSorted.values.toList();
                var listaKeys = mapPreciosSorted.keys.toList();
                _index = listaKeys[index];
              }
              Color _color = Tarifa.getColorFondo(precios[index]);
              Periodo periodo = Tarifa.getPeriodo(data.getDataTime(data.fecha, _index));
              Color _colorPeriodo = Tarifa.getColorPeriodo(periodo);
              double precioMedio = data.calcularPrecioMedio(data.preciosHora);
              double desviacion = precios[index] - precioMedio;
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.8, color: Colors.grey),
                    left: BorderSide(width: 10.0, color: _colorPeriodo),
                  ),
                  color: _color,
                ),
                child: ListTile(
                  leading: page == 2
                      ? Tarifa.getIconCara(precios, precios[index])
                      : Text('${index + 1}'),
                  title: page == 2
                      ? Text('${(precios[index]).toStringAsFixed(5)} €/kWh')
                      : Text(
                          '${_index}h - ${_index + 1}h',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                  subtitle: page == 2
                      ? Text('${index}h - ${index + 1}h')
                      : Text('${precios[index].toStringAsFixed(5)} €/kWh'),
                  trailing: Column(
                    children: [
                      Flexible(
                        child: Icon(
                          desviacion > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          size: 45,
                          color: desviacion > 0 ? Colors.red : Colors.green,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '${desviacion.toStringAsFixed(4)} €',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}
