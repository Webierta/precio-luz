import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/tab_page_range.dart';
import '../widgets/tab_page.dart';
import '../widgets/texto_rich.dart';
import '../utils/tarifa.dart';
import '../services/datos.dart';
import 'leyenda.dart';

class Resultado extends StatefulWidget {
  final Datos data;
  final String fecha;
  final Datos dataHoy;
  const Resultado({Key key, this.data, this.fecha, this.dataHoy}) : super(key: key);
  @override
  _ResultadoState createState() => _ResultadoState();
}

class _ResultadoState extends State<Resultado> {
  var _currentPage = 0;
  Datos _data;
  Datos _dataHoy;
  String _fecha;

  @override
  void initState() {
    _data = widget.data;
    _dataHoy = widget.dataHoy;
    _fecha = widget.fecha;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime hoy = DateTime.now().toLocal();
    int hora = hoy.hour;
    String horaMin = DateFormat('HH:mm').format(hoy);
    double precioHoy = _dataHoy.getPrecio(_dataHoy.preciosHora, hora);

    var periodoAhora = Tarifa.getPeriodo(DateTime.now().toLocal());
    var periodoMin = Tarifa.getPeriodo(_data.getDataTime(
        _data.fecha, _data.getHour(_data.preciosHora, _data.precioMin(_data.preciosHora))));
    var periodoMax = Tarifa.getPeriodo(_data.getDataTime(
        _data.fecha, _data.getHour(_data.preciosHora, _data.precioMax(_data.preciosHora))));
    var desviacionHoy =
        _dataHoy.preciosHora[hora] - _dataHoy.calcularPrecioMedio(_dataHoy.preciosHora);
    var desviacionMin =
        _data.precioMin(_data.preciosHora) - _data.calcularPrecioMedio(_data.preciosHora);
    var desviacionMax =
        _data.precioMax(_data.preciosHora) - _data.calcularPrecioMedio(_data.preciosHora);

    List<Widget> _pages = [
      Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Tarifa 2.0 TD', style: Theme.of(context).textTheme.headline6),
            ],
          ),
          Card(
            color: Tarifa.getColorFondo(precioHoy), //Colors.blue[100],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text('PRECIO AHORA', style: Theme.of(context).textTheme.bodyText2),
                  ListTile(
                    leading: Tarifa.getIconCara(_dataHoy.preciosHora, _dataHoy.preciosHora[hora]),
                    title: FittedBox(
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${precioHoy.toStringAsFixed(5)} €/kWh',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hoy a las $horaMin'),
                        Row(
                          children: [
                            Tarifa.getIconPeriodo(periodoAhora),
                            SizedBox(width: 10.0),
                            Text('${describeEnum(periodoAhora).toUpperCase()}'),
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        Flexible(
                          child: Icon(
                            desviacionHoy > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            size: 45,
                            color: desviacionHoy > 0 ? Colors.red : Colors.green,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '${desviacionHoy.toStringAsFixed(4)} €',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.blue[100],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text('$_fecha', style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Hora más barata del día:',
                      style: Theme.of(context).textTheme.overline,
                    ),
                  ),
                  ListTile(
                    leading: Column(
                      children: [
                        Tarifa.getIconPeriodo(periodoMin),
                        Text(
                          '${describeEnum(periodoMin).toUpperCase()}',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    subtitle:
                        Text('${(_data.precioMin(_data.preciosHora)).toStringAsFixed(5)} €/kWh'),
                    title: TextoRich(
                      texto:
                          '${_data.getHora(_data.preciosHora, _data.precioMin(_data.preciosHora))}',
                      color: Colors.green[300],
                    ),
                    trailing: Column(
                      children: [
                        Flexible(
                          child: Icon(
                            desviacionMin > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            size: 45,
                            color: desviacionMin > 0 ? Colors.red : Colors.green,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '${desviacionMin.toStringAsFixed(4)} €',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Hora más cara del día:',
                      style: Theme.of(context).textTheme.overline,
                    ),
                  ),
                  ListTile(
                    leading: Column(
                      children: [
                        Tarifa.getIconPeriodo(periodoMax),
                        Text(
                          '${describeEnum(periodoMax).toUpperCase()}',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    subtitle:
                        Text('${(_data.precioMax(_data.preciosHora)).toStringAsFixed(5)} €/kWh'),
                    title: TextoRich(
                      texto:
                          '${_data.getHora(_data.preciosHora, _data.precioMax(_data.preciosHora))}',
                      color: Colors.red[300],
                    ),
                    trailing: Column(
                      children: [
                        Flexible(
                          child: Icon(
                            desviacionMax > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            size: 45,
                            color: desviacionMax > 0 ? Colors.red : Colors.green,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '${desviacionMax.toStringAsFixed(4)} €',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                      'Precio Medio: ${(_data.calcularPrecioMedio(_data.preciosHora)).toStringAsFixed(5)} €/kWh'),
                ],
              ),
            ),
          ),
          Divider(color: Colors.blueGrey),
          Text('Fuente: REE y elaboración propia'),
          Divider(color: Colors.blueGrey),
        ],
      ),
      TabPage(page: 2, fecha: _fecha, titulo: 'Evolución del Precio en el día', data: _data),
      TabPage(page: 3, fecha: _fecha, titulo: 'Horas por Precio ascendente', data: _data),
      TabPageRange(fecha: _fecha, data: _data),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Precios por Horas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help, color: Colors.white),
            onPressed: () {
              return Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Leyenda()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(child: _pages.elementAt(_currentPage)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'PVPC',
            backgroundColor: Color(0xFF0D47A1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.euro_symbol),
            label: 'PRECIO',
            backgroundColor: Color(0xFF0D47A1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'HORAS',
            backgroundColor: Color(0xFF0D47A1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timelapse),
            label: 'FRANJAS',
            backgroundColor: Color(0xFF0D47A1),
          ),
        ],
        currentIndex: _currentPage,
        //type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white, //fixedColor: Colors.white,
        //backgroundColor: Color(0xFF0D47A1),
        unselectedItemColor: Colors.white60,
        onTap: (int inIndex) {
          setState(() => _currentPage = inIndex);
        },
      ),
    );
  }
}
