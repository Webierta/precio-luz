import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'appbar.dart';
import 'datosConsulta.dart';
import 'resultados.dart';

class Home extends StatefulWidget {
  final String source;
  Home({Key key, this.source}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Data _data = Data();
  Data _dataHoy = Data();
  DateTime hoy = DateTime.now().toLocal();
  String _tarifaIn;
  String _fechaIn;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dataController;
  bool noPublicado = false;
  bool seguirConsulta = true;
  bool _progressActive = false;

  @override
  void initState() {
    super.initState();
    _tarifaIn = Data.getTarifa()[0];
    _fechaIn = DateFormat('yyyy-MM-dd').format(hoy);
    _dataController =
        TextEditingController(text: DateFormat('dd/MM/yyyy').format(hoy));
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = 'es_ES';
    DateTime manana = DateTime(hoy.year, hoy.month, hoy.day + 1);

    return Scaffold(
      appBar: BaseAppBar(
        title: Text('App PVPC'),
        appBar: AppBar(),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Elige tu tarifa y el día que quieres consultar:',
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        DropdownButtonFormField(
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'Tarifa',
                            labelStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                              //height: 2.0,
                            ),
                            prefixIcon: Icon(
                              Icons.euro_symbol,
                              color: Colors.black45,
                            ),
                          ),
                          value: _tarifaIn,
                          items: Data.getTarifa().map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  height: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _tarifaIn = value);
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Fecha',
                            labelStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: Colors.black45,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 30.0),
                          ),
                          style: TextStyle(
                            //height: 0.0,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          validator: (value) =>
                              value.trim().isEmpty ? 'Fecha requerida' : null,
                          controller: _dataController,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime picked = await showDatePicker(
                              context: context,
                              locale: const Locale('es', 'ES'),
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2015),
                              lastDate: manana,
                            );
                            if (picked != null) {
                              //if (picked != _fechaIn) { RESET?? //}
                              _dataController.text =
                                  DateFormat('dd/MM/yyyy').format(picked);
                              setState(() {
                                _fechaIn =
                                    DateFormat('yyyy-MM-dd').format(picked);
                                _data.fecha = _fechaIn;
                              });
                              noPublicado = picked == manana && hoy.hour < 20
                                  ? true
                                  : false;
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xff01A0C7),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            child: Text(
                              "Consultar",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20.0).copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              setState(() => _progressActive = true);
                              seguirConsulta = true;
                              if (noPublicado == true) {
                                await dialogoNoPublicado();
                              }
                              if (_formKey.currentState.validate() &&
                                  seguirConsulta == true) {
                                await consultar();
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 20.0),
                        SizedBox(
                          height: 2.0,
                          child: _progressActive == true
                              ? LinearProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.blue),
                                  backgroundColor: Colors.yellow,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  dialogoNoPublicado() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aviso'),
          content: Text(
              'En torno a las 20:15h de cada día, la REE publica los precios '
              'de la electricidad que se aplicarán al día siguiente, por lo que '
              'es posible que los datos todavía no estén publicados.'),
          actions: [
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                seguirConsulta = false;
                _progressActive = false;
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Consultar'),
              onPressed: () {
                seguirConsulta = true;
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  consultar() async {
    _formKey.currentState.save();
    _data.tarifa = _tarifaIn;
    _data.codeTarifa = Data.getCodeTarifa(_tarifaIn);
    _data.fecha = _fechaIn;
    _data.preciosHoras.clear();
    _dataHoy.preciosHoras.clear(); // ????

    widget.source == 'API'
        ? await _data.getPreciosHoras(getUrl(_data.fecha, _data.codeTarifa))
        : await _data.getPreciosHorasFile(_data.fecha, _data.codeTarifa);

    var _hoyDate = DateFormat('yyyy-MM-dd').format(hoy);
    if (noPublicado == true && _data.status == Status.error) {
      checkStatus(Status.noPublicado);
    } else if (_data.status != Status.ok) {
      checkStatus(_data.status);
    } else if (_data.fecha != _hoyDate) {
      widget.source == 'API'
          ? await _dataHoy.getPreciosHoras(getUrl(_hoyDate, _data.codeTarifa))
          : await _dataHoy.getPreciosHorasFile(_hoyDate, _data.codeTarifa);
    } else if (_data.status == Status.ok) {
      //_dataHoy = _data;
      _dataHoy.preciosHoras = List.from(_data.preciosHoras);
      _dataHoy.status = _data.status;
    }

    if (_data.status == Status.ok && _dataHoy.status != Status.ok) {
      checkStatus(_dataHoy.status);
    } else if (_data.status == Status.ok && _dataHoy.status == Status.ok) {
      setState(() => _progressActive = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Resultado(
            data: _data,
            fecha: _dataController.text,
            dataHoy: _dataHoy,
          ),
        ),
      );
    }
  }

  String getUrl(String date, String code) {
    return 'https://api.esios.ree.es/indicators/'
        '$code?'
        'start_date=${date}T00:00:00'
        '&end_date=${date}T23:50:00';
  }

  /* String getUrlFile(String date) {  // NECESARIO ??
    return 'https://api.esios.ree.es/archives/80/download?date=$date}';
  } */

  _showError({String titulo, String msg}) {
    setState(() => _progressActive = false);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(msg),
          actions: [
            FlatButton(
              child: Text('Volver'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  checkStatus(Status status) {
    switch (status) {
      case Status.errorToken:
        _showError(
          titulo: 'Error Token',
          msg: 'Acceso denegado.\nComprueba tu token personal.',
        );
        break;
      case Status.noAcceso:
        _showError(
          titulo: 'Error',
          msg: 'Error en la respuesta a la petición web',
        );
        break;
      case Status.tiempoExcedido:
        _showError(
          titulo: 'Error',
          msg: 'Tiempo de conexión excedido sin respuesta del servidor.',
        );
        break;
      case Status.noPublicado:
        _showError(
          titulo: 'Error',
          msg:
              'Es posible que los datos de mañana todavía no estén publicados.\n'
              'Vuelve a intentarlo más tarde.',
        );
        break;
      default:
        _showError(
          titulo: 'Error',
          msg: 'Error obteniendo los datos.\n'
              'Comprueba tu conexión o vuelve a intentarlo pasados unos minutos.',
        );
    }
  }
}
