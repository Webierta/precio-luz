import 'package:flutter/material.dart';

const TextStyle textBlanco = TextStyle(color: Colors.white);
const TextStyle textBlanco70 = TextStyle(color: Colors.white70);

class BalanceGeneracion extends StatelessWidget {
  final Map<String, double> sortedMap;
  final String title;
  final double total;

  const BalanceGeneracion(
      {Key key, @required this.sortedMap, @required this.title, @required this.total})
      : super(key: key);

  String calcularPorcentaje(double valor) {
    return ((valor * 100) / total).toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    var titulo = title == 'Generación renovable' ? 'Renovable' : 'No renovable';
    return DropdownButton<double>(
      //value: _renovableValue,
      underline: Container(height: 0),
      isExpanded: true,
      hint: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(titulo, style: TextStyle(color: Colors.white, fontSize: 18))),
            ),
          ), //style: textBlanco),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              '${calcularPorcentaje(sortedMap[title])}%',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w100),
            ),
          ),
        ],
      ),
      style: TextStyle(color: Colors.white),
      iconEnabledColor: Colors.blueAccent,
      icon: Icon(Icons.zoom_in, size: 24),
      dropdownColor: Colors.blue,
      isDense: true,
      items: sortedMap
          .map((description, value) {
            return MapEntry(
                description,
                DropdownMenuItem<double>(
                  value: value,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FittedBox(child: Text('$description')),
                          Text('${calcularPorcentaje(value)}%'),
                        ],
                      ),
                      LinearProgressIndicator(
                        value: (double.tryParse(calcularPorcentaje(value)) ?? 100) / 100,
                        backgroundColor: Colors.black12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ));
          })
          .values
          .toList(),
      onChanged: (_) {},
    );
  }
}
