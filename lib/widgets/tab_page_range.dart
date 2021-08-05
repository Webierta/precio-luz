import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'container_time.dart';
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
  int franjas = 0;
  Map<Duration, double> mapPreciosSorted = {};
  bool _calculando = false;

  int getFranjas({int duracion, int step}) {
    // franjas o intervalos = (((total - (duration - step)) / 60)) * ((60 / step))).truncate()
    const total = 1440; // 24 horas en minutos
    var paso = step == 0 ? 60 : step;
    return (((total - (duracion - paso)) / 60) * ((60 / paso))).truncate();
  }

  void getPreciosFranjas() {
    Map<Duration, double> mapInicioPrecios = {};
    List<double> preciosFranjas = [];
    List<double> preciosHora = widget.data.preciosHora;
    var startList = List<Duration>.generate(
        franjas, (int index) => Duration(minutes: index * (minutos == 0 ? 60 : minutos)));

    for (var i = 0; i < franjas; i++) {
      // PUNTOS DE INICIO Y FIN DE CADA INTERVALO
      var start = startList[i];
      var stop = start + _duration;
      // HORAS Y MINUTOS PARA CALCULAR EL PRECIO DE CADA INTERVALO
      var horasFranja = [];
      var minStop = int.tryParse(stop.toString().split(':')[1]) ?? 0;
      var horaLimite = minStop == 0 ? stop.inHours - 1 : stop.inHours;
      for (var i = start.inHours; i <= horaLimite; i++) {
        horasFranja.add(i);
      }
      var minFranja = List<int>.generate(horasFranja.length, (int index) => 60);
      minFranja.first = 60 - (int.tryParse(start.toString().split(':')[1]) ?? 0);
      minFranja.last = int.tryParse(stop.toString().split(':')[1]) ?? 0;
      // PRECIO * MINUTOS DE CADA INTERVALO
      var preciosRango = [];
      for (var i = 0; i < horasFranja.length; i++) {
        var minutosFranja = minFranja[i] == 0 ? 60 : minFranja[i];
        preciosRango.add(preciosHora[horasFranja[i]] * minutosFranja);
      }
      // PRECIOS MEDIOS
      var media = preciosRango.reduce((a, b) => a + b) / _duration.inMinutes;
      preciosFranjas.add(media);
      mapInicioPrecios[startList[i]] = preciosFranjas[i];
    }
    // ORDENA LOS PRECIOS
    var sortedKeys = mapInicioPrecios.keys.toList(growable: false)
      ..sort((k1, k2) => mapInicioPrecios[k1].compareTo(mapInicioPrecios[k2]));
    Map<Duration, double> mapPrecios = Map.fromIterable(
      sortedKeys,
      key: (k) => k,
      value: (k) => mapInicioPrecios[k],
    );
    if (mounted) {
      setState(() => mapPreciosSorted = Map.from(mapPrecios));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeadTab(fecha: widget.fecha, titulo: 'Franjas horarias más baratas'),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Selecciona la duración (máximo 24:00):'),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () async {
              Duration resultingDuration = await showDurationPicker(
                context: context,
                initialTime: _duration,
                snapToMins: 10,
              );
              if (resultingDuration != null) {
                if (mounted) {
                  setState(() {
                    _calculando = true;
                    _duration = resultingDuration ?? _duration;
                    horas = _duration.inHours; // > 5 ? 6 : _duration.inHours;
                    minutos = int.tryParse(_duration.toString().split(':')[1]) ?? 0;
                    _duration = Duration(hours: horas, minutes: minutos);
                    if (_duration.inMinutes > 1440) {
                      _duration = Duration(hours: 24, minutes: 0);
                      horas = 24;
                      minutos = 0;
                    }
                    franjas = getFranjas(duracion: _duration.inMinutes, step: minutos);
                  });
                }
                getPreciosFranjas();
                await Future.delayed(Duration(milliseconds: franjas * 10)); // franjas * 25
                if (mounted) {
                  setState(() => _calculando = false);
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContainerTime(numero: '${_duration.toString().split(':').first}'),
                const Text(' : ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                ContainerTime(numero: '${_duration.toString().split(':')[1]}'),
              ],
            ),
          ),
          const Divider(),
          if (_duration.inMinutes <= 60)
            const Text(
                'La duración no supera una hora: puedes comprobar la hora más barata en la pestaña Horas.'),
          if (_duration.inMinutes > 60 && _calculando == true) const Loading(),
          if (_duration.inMinutes > 60 &&
              _calculando == false &&
              franjas != 0 &&
              mapPreciosSorted.isNotEmpty)
            ContainerListView(
              duration: _duration,
              franjas: franjas,
              mapPreciosSorted: mapPreciosSorted,
            ),
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            Text('Calculando...'),
            LinearProgressIndicator(
              minHeight: 2.0,
              valueColor: AlwaysStoppedAnimation(Colors.blue),
              backgroundColor: Colors.yellow,
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerListView extends StatelessWidget {
  final Duration duration;
  final int franjas;
  final Map<Duration, double> mapPreciosSorted;
  const ContainerListView({Key key, this.duration, this.franjas, this.mapPreciosSorted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<double> preciosOrdenados = mapPreciosSorted?.values?.toList();
    List<Duration> listaKeys = mapPreciosSorted?.keys?.toList();
    return Container(
      constraints: BoxConstraints(maxHeight: 100.0 * franjas),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          //cacheExtent: 10000.0 * franjas.value,
          shrinkWrap: true,
          itemCount: franjas,
          itemBuilder: (context, index) {
            //List<double> preciosOrdenados = mapPreciosSorted?.values?.toList();
            var precioOrdenado = preciosOrdenados[index];
            //List<Duration> listaKeys = mapPreciosSorted?.keys?.toList();
            // TITULO CON HORAS Y MINUTOS DE CADA FRANJA
            var timeFranja = listaKeys[index];
            var horaInicioFranja = timeFranja.inHours;
            var minInicioFranja = int.tryParse(timeFranja.toString().split(':')[1]) ?? 0;
            var hora2 = timeFranja + duration;
            var horaLapso = hora2.inHours;
            var minLapso = int.tryParse(hora2.toString().split(':')[1]) ?? 0;
            var _color = Tarifa.getColorFondo(precioOrdenado);
            return Container(
              decoration: BoxDecoration(
                border: const Border(
                  bottom: BorderSide(width: 0.8, color: Colors.grey),
                  left: BorderSide(width: 10.0, color: Colors.grey),
                ),
                color: _color,
              ),
              child: ListTile(
                leading: Text('${index + 1}'),
                title: Text(
                  '$horaInicioFranja:${minInicioFranja.toString().padLeft(2, '0')} - '
                  '$horaLapso:${minLapso.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text('${(precioOrdenado.toStringAsFixed(5))} €/kWh'),
              ),
            );
          }),
    );
  }
}
