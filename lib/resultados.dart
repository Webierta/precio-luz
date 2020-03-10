import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'datosConsulta.dart';
import 'leyenda.dart';

class Resultado extends StatefulWidget {
  final Data data;
  final String fecha;
  final Data dataHoy;

  const Resultado({Key key, this.data, this.fecha, this.dataHoy})
      : super(key: key);

  @override
  _ResultadoState createState() => _ResultadoState();
}

class _ResultadoState extends State<Resultado> {
  var _currentPage = 0;
  ScrollController _controller = ScrollController();
  Data _data;
  Data _dataHoy;
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
    int hora = hoy.hour; // DateFormat('kk:mm').format(hoy);
    //int min = hoy.minute; // int.parse(hora.substring(0, 2));
    //String hora = DateFormat('kk: mm').format(hoy);
    String horaMin = DateFormat('kk:mm').format(hoy);

    Icon icono;
    switch (_data.codeTarifa) {
      case '1013':
        icono = Icon(
          Icons.offline_bolt,
          size: 30,
          color: Colors.blueAccent,
        );
        break;
      case '1014':
        icono = Icon(
          Icons.brightness_medium,
          size: 30,
          color: Colors.blueAccent,
        );
        break;
      case '1015':
        icono = Icon(
          Icons.ev_station,
          size: 30,
          color: Colors.blueAccent,
        );
        break;
      default:
        icono = Icon(
          Icons.wb_incandescent,
          size: 40,
          color: Colors.yellowAccent,
        );
    }

    Color getColor(double precio) {
      if (precio < 0.10) {
        return Colors.lightGreen[50];
      } else if (precio < 0.15) {
        return Colors.yellow[50];
      } else {
        return Colors.red[50];
      }
    }

    Icon getBaratos(List<double> preciosHoras, double valor) {
      List<double> preciosAs = List.from(preciosHoras);
      preciosAs.sort();
      if (preciosAs.indexWhere((v) => v == valor) < 8) {
        return Icon(
          Icons.sentiment_very_satisfied, //stars, // grade, //flash_on,
          size: 30,
          color: Colors.green[700],
        );
      } else if (preciosAs.indexWhere((v) => v == valor) > 15) {
        return Icon(
          Icons.sentiment_very_dissatisfied, //warning,
          size: 30,
          color: Colors.deepOrange[700],
        );
      } else {
        return Icon(
          Icons.sentiment_neutral,
          size: 30,
          color: Colors.amber[700],
        );
      }
    }

    var _pages = [
      Column(
        // PAGE 1
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icono,
              Text(
                'Tarifa ${_data.tarifa}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          Card(
            color: Colors.blue[100],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'PRECIO AHORA',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  ListTile(
                    leading: getBaratos(
                        _dataHoy.preciosHoras, _dataHoy.preciosHoras[hora]),
                    title: FittedBox(
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${_dataHoy.getPrecio(_dataHoy.preciosHoras, hora).toStringAsFixed(5)} €/kWh',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Text('Hoy a las $horaMin'),
                    trailing: _dataHoy.preciosHoras[hora] >=
                            _dataHoy.calcularPrecioMedio(_dataHoy.preciosHoras)
                        ? Icon(
                            Icons.arrow_drop_up,
                            size: 45,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.arrow_drop_down,
                            size: 45,
                            color: Colors.green,
                          ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.blue[100],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    '$_fecha',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Hora más barata del día:',
                      style: Theme.of(context).textTheme.overline,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.star, //flash_on,
                      size: 30,
                      color: Colors.yellow,
                    ),
                    subtitle: Text(
                        '${(_data.precioMin(_data.preciosHoras)).toStringAsFixed(5)} €/kWh'),
                    title: Text(
                      '${_data.getHora(_data.preciosHoras, _data.precioMin(_data.preciosHoras))}',
                      style: Theme.of(context).textTheme.headline6,
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
                    leading: Icon(
                      Icons.warning, //not_interested,  //warning,  //flash_off,
                      size: 25,
                      color: Colors.deepOrange[700],
                    ),
                    subtitle: Text(
                        '${(_data.precioMax(_data.preciosHoras)).toStringAsFixed(5)} €/kWh'),
                    title: Text(
                      '${_data.getHora(_data.preciosHoras, _data.precioMax(_data.preciosHoras))}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Text(
                      'Precio Medio: ${(_data.calcularPrecioMedio(_data.preciosHoras)).toStringAsFixed(5)} €/kWh'),
                ],
              ),
            ),
          ),
          Divider(color: Colors.blueGrey),
          Text('Fuente: REE y elaboración propia'),
          Divider(color: Colors.blueGrey),
        ],
      ),
      Column(
        // PAGE 2
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icono,
              Text(
                'Tarifa ${_data.tarifa}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          Text(
            '$_fecha',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            'Evolución del Precio en el día',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _data.preciosHoras.length,
            itemBuilder: (context, index) {
              Color _color = getColor(_data.preciosHoras[index]);
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.8, color: Colors.grey),
                  ),
                  color: _color,
                ),
                //height: 55.0,
                child: ListTile(
                  trailing: _data.preciosHoras[index] >=
                          _data.calcularPrecioMedio(_data.preciosHoras)
                      ? Icon(
                          Icons.arrow_drop_up,
                          size: 45,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.arrow_drop_down,
                          size: 45,
                          color: Colors.green,
                        ),
                  title: Text(
                      '${(_data.preciosHoras[index]).toStringAsFixed(5)} €/kWh'),
                  subtitle: Text('${index}h - ${index + 1}h'),
                  leading:
                      getBaratos(_data.preciosHoras, _data.preciosHoras[index]),
                ),
              );
            },
          ),
        ],
      ),
      Column(
        // PAGE 3
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icono,
              Text(
                'Tarifa ${_data.tarifa}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          Text(
            '$_fecha',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            'Horas por Precio ascendente',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _data.preciosHoras.length,
            itemBuilder: (context, index) {
              List<double> preciosAs = List.from(_data.preciosHoras);
              preciosAs.sort();
              var _color = getColor(preciosAs[index]);
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.8, color: Colors.grey),
                  ),
                  color: _color,
                ),
                child: ListTile(
                  trailing: preciosAs[index] >=
                          _data.calcularPrecioMedio(_data.preciosHoras)
                      ? Icon(
                          Icons.arrow_drop_up,
                          size: 45,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.arrow_drop_down,
                          size: 45,
                          color: Colors.green,
                        ),
                  title: Text(
                    '${_data.getHora(_data.preciosHoras, preciosAs[index])}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle:
                      Text('${preciosAs[index].toStringAsFixed(5)} €/kWh'),
                  leading: Text('${index + 1}'),
                ),
              );
            },
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Precios por Horas'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.help,
              color: Colors.white,
            ),
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
          padding: const EdgeInsets.all(20.0),
          controller: _controller,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(child: _pages.elementAt(_currentPage)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            title: Text("PVPC"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.euro_symbol),
            title: Text("PRECIO"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            title: Text("HORAS"),
          ),
        ],
        currentIndex: _currentPage,
        fixedColor: Colors.white,
        backgroundColor: Colors.blue[900],
        unselectedItemColor: Colors.white60,
        onTap: (int inIndex) {
          _controller.animateTo(_controller.position.minScrollExtent,
              duration: Duration(milliseconds: 100), curve: Curves.easeIn);
          setState(() => _currentPage = inIndex);
        },
      ),
    );
  }
}
