import 'package:flutter/material.dart';
import '../utils/estados.dart';

const TextStyle textBlanco = TextStyle(color: Colors.white);
const TextStyle textBlanco70 = TextStyle(color: Colors.white70);

class BalanceGeneracion extends StatelessWidget {
  final Map<String, double> sortedMap;
  final Generacion generacion;
  final double total;

  const BalanceGeneracion(
      {Key key, @required this.sortedMap, @required this.generacion, @required this.total})
      : super(key: key);

  String calcularPorcentaje(double valor) {
    return ((valor * 100) / total).toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: DropdownButton<double>(
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
                  child: Text(generacion.tipo, style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ), //style: textBlanco),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FittedBox(
                child: Text(
                  '${calcularPorcentaje(sortedMap[generacion.texto])}%',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w100),
                ),
              ),
            ),
          ],
        ),
        style: TextStyle(color: Colors.white),
        iconEnabledColor: Colors.blueAccent,
        icon: Container(
          transform: Matrix4.translationValues(8.0, 0.0, 0.0),
          child: Icon(Icons.zoom_in, size: 24),
        ),
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
      ),
    );
  }
}
