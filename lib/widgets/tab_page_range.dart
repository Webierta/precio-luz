import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import '../services/datos.dart';
import '../utils/tarifa.dart';
import 'head_tab.dart';

class TabPageRange extends StatefulWidget {
  final String fecha;
  final Datos data;
  const TabPageRange({Key key, this.fecha, this.data}) : super(key: key);

  @override
  _TabPageRangeState createState() => _TabPageRangeState();
}

class _TabPageRangeState extends State<TabPageRange> {
  Duration _duration = Duration(hours: 0, minutes: 00);
  var horas = 0;
  var minutos = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeadTab(fecha: widget.fecha, titulo: 'Franjas horarias más baratas'),
        Text('Selecciona la duración (se redondea en tramos de 30 minutos; máximo 7:00):'),
        SizedBox(height: 10),
        InkWell(
          onTap: () async {
            Duration resultingDuration = await showDurationPicker(
              context: context,
              initialTime: _duration, //Duration(minutes: 30),
              //snapToMins: 30.0,
            );
            setState(() {
              _duration = resultingDuration ?? _duration;
              horas = _duration.inHours; // > 5 ? 6 : _duration.inHours;
              minutos = int.tryParse(_duration.toString().split(':')[1]) ?? 0;
              if (minutos > 45) {
                horas++;
                minutos = 0;
              } else if (minutos > 15) {
                minutos = 30;
              } else {
                minutos = 0;
              }
              _duration = Duration(hours: horas, minutes: minutos);
              if (_duration.inMinutes > 420) {
                _duration = Duration(hours: 7, minutes: 0);
                horas = 7;
                minutos = 0;
              }
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  border: Border.all(color: Colors.purple),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Text(
                  ' ${_duration.toString().split(':').first} ',
                  style: TextStyle(fontSize: 28, color: Colors.purple),
                ),
              ),
              Text(' : ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  border: Border.all(color: Colors.purple),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Text(
                  '${_duration.toString().split(':')[1]}',
                  style: TextStyle(fontSize: 28, color: Colors.purple),
                ),
              ),
            ],
          ),
        ),
        Divider(),
        _duration.inMinutes < 61
            ? Text(
                'La duración no supera una hora: puedes comprobar la hora más barata en la pestaña Horas.')
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _duration.inMinutes % 60 > 0
                    ? 48 - ((_duration.inMinutes ~/ minutos) - 1)
                    : 24 - (_duration.inHours - 1), // * 2
                itemBuilder: (context, index) {
                  // LISTA DE PRECIOS
                  List<double> preciosHora = widget.data.preciosHora;
                  List<double> precios = [];
                  if (minutos == 0) {
                    precios = List.from(preciosHora);
                  } else {
                    for (var precio in preciosHora) {
                      precios.add((minutos * precio) / 60); // precio / 2 en 30 m
                      precios.add((minutos * precio) / 60);
                    }
                  }
                  // PRECIOS ORDENADOS
                  List<double> preciosOrdenados;
                  List<int> listaKeys;
                  List<double> preciosFranjas = [];
                  int franjas = _duration.inMinutes % 60 > 0
                      ? 48 - ((_duration.inMinutes ~/ minutos) - 1)
                      : 24 - (_duration.inHours - 1); // x 2
                  for (var i = 0; i < franjas; i++) {
                    List<double> rangoPrecios;
                    if (minutos == 0) {
                      rangoPrecios = precios.getRange(i, i + horas).toList(); // ?? sublist
                    } else {
                      rangoPrecios =
                          precios.getRange(i, i + (_duration.inMinutes ~/ minutos)).toList();
                    }
                    // CALCULO DE PRECIOS MEDIOS
                    double suma = 0;
                    for (var precio in rangoPrecios) {
                      suma = suma + precio;
                    }
                    var mediaEnMinutos = suma / _duration.inMinutes; //horasPorIntervalo
                    var mediaEnHoras = mediaEnMinutos * 60;
                    preciosFranjas.add(mediaEnHoras);
                    // ORDENA LOS PRECIOS
                    var mapPreciosFranjas = preciosFranjas.asMap();
                    var sortedKeys = mapPreciosFranjas.keys.toList(growable: false)
                      ..sort((k1, k2) => mapPreciosFranjas[k1].compareTo(mapPreciosFranjas[k2]));
                    Map<int, double> mapPreciosSorted = Map.fromIterable(
                      sortedKeys,
                      key: (k) => k,
                      value: (k) => mapPreciosFranjas[k],
                    );
                    preciosOrdenados = mapPreciosSorted.values.toList();
                    listaKeys = mapPreciosSorted.keys.toList();
                  }
                  // OBTIENE HORAS Y MINUTOS DE CADA FRANJA
                  int indexFranja;
                  String tituloListTile;
                  if (minutos == 0) {
                    indexFranja = listaKeys[index];
                    tituloListTile = '${indexFranja}h - ${indexFranja + horas}h';
                  } else {
                    int indexFranja = listaKeys[index] ~/ 2;
                    int minFranja = listaKeys[index] % 2 == 0 ? 0 : minutos;
                    Duration hora1 = Duration(hours: indexFranja, minutes: minFranja);
                    Duration hora2 = hora1 + _duration;
                    int horaLapso = hora2.inHours;
                    int minLapso = int.tryParse(hora2.toString().split(':')[1]) ?? 0;
                    tituloListTile = '$indexFranja:${minFranja.toString().padLeft(2, '0')} - '
                        '$horaLapso:${minLapso.toString().padLeft(2, '0')}';
                  }
                  Color _color = Tarifa.getColorFondo(preciosOrdenados[index]);
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 0.8, color: Colors.grey),
                        left: BorderSide(width: 10.0, color: Colors.grey),
                      ),
                      color: _color,
                    ),
                    child: ListTile(
                      leading: Text('${index + 1}'),
                      title: Text(
                        tituloListTile,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Text('${(preciosOrdenados[index]).toStringAsFixed(5)} €/kWh'),
                    ),
                  );
                }),
      ],
    );
  }
}
