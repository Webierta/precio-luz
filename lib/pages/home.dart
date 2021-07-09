import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/estados.dart';
import '../widgets/appbar.dart';
import '../services/datos.dart';
import 'resultados.dart';

class Home extends StatefulWidget {
  final Source source;
  Home({Key key, this.source}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Datos _datos = Datos();
  Datos _datosHoy = Datos();
  DateTime hoy = DateTime.now().toLocal();
  String _fechaIn;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dataController;
  bool noPublicado = false;
  bool seguirConsulta = true;
  bool _progressActive = false;

  @override
  void initState() {
    super.initState();
    _fechaIn = DateFormat('yyyy-MM-dd').format(hoy);
    _dataController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(hoy));
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
                  FittedBox(
                    child: Text(
                      'Selecciona el día que quieres consultar:',
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
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
                            contentPadding: const EdgeInsets.symmetric(vertical: 30.0),
                          ),
                          style: TextStyle(
                            //height: 0.0,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          validator: (value) => value.trim().isEmpty ? 'Fecha requerida' : null,
                          controller: _dataController,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            DateTime picked = await showDatePicker(
                              context: context,
                              locale: const Locale('es', 'ES'),
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2021, 6),
                              lastDate: manana,
                            );
                            if (picked != null) {
                              //if (picked != _fechaIn) { RESET?? //}
                              _dataController.text = DateFormat('dd/MM/yyyy').format(picked);
                              setState(() {
                                _fechaIn = DateFormat('yyyy-MM-dd').format(picked);
                                _datos.fecha = _fechaIn;
                              });
                              noPublicado = picked == manana && hoy.hour < 20 ? true : false;
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
                            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            child: Text(
                              "Consultar",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16.0)
                                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              setState(() => _progressActive = true);
                              seguirConsulta = true;
                              if (noPublicado == true) {
                                await dialogoNoPublicado();
                              }
                              if (_formKey.currentState.validate() && seguirConsulta == true) {
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
                                  valueColor: AlwaysStoppedAnimation(Colors.blue),
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
          content: Text('En torno a las 20:15h de cada día, la REE publica los precios '
              'de la electricidad que se aplicarán al día siguiente, por lo que '
              'es posible que los datos todavía no estén publicados.'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                seguirConsulta = false;
                _progressActive = false;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
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
    _datos.fecha = _fechaIn;
    _datos.preciosHora.clear();
    _datosHoy.preciosHora.clear(); // ????

    /*widget.source == 'API'
        ? await _datos.getPreciosHoras(_datos.fecha)
        : await _datos.getPreciosHorasFile(_datos.fecha);*/
    await _datos.getPreciosHoras(_datos.fecha, widget.source);
    if (_datos.status == Status.accessDenied) {
      await _datos.getPreciosHorasFile(_datos.fecha);
    }
    //await _datos.getPreciosHorasFile(_datos.fecha);

    var _hoyDate = DateFormat('yyyy-MM-dd').format(hoy);
    if (noPublicado == true && _datos.status == Status.error) {
      checkStatus(Status.noPublicado);
    } else if (_datos.status != Status.ok) {
      checkStatus(_datos.status);
    } else if (_datos.fecha != _hoyDate) {
      /*widget.source == 'API'
          ? await _datosHoy.getPreciosHoras(_hoyDate)
          : await _datosHoy.getPreciosHorasFile(_hoyDate);*/
      await _datosHoy.getPreciosHoras(_hoyDate, widget.source);
      if (_datosHoy.status == Status.accessDenied) {
        await _datosHoy.getPreciosHorasFile(_hoyDate);
      }
    } else if (_datos.status == Status.ok) {
      //_dataHoy = _data;
      _datosHoy.preciosHora = List.from(_datos.preciosHora);
      _datosHoy.status = _datos.status;
    }

    if (_datos.status == Status.ok && _datosHoy.status != Status.ok) {
      checkStatus(_datosHoy.status);
    } else if (_datos.status == Status.ok && _datosHoy.status == Status.ok) {
      setState(() => _progressActive = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Resultado(
            data: _datos,
            fecha: _dataController.text,
            dataHoy: _datosHoy,
          ),
        ),
      );
    }
  }

  /*String getUrl(String date, String code) {
    return 'https://api.esios.ree.es/indicators/'
        '$code?'
        'start_date=${date}T00:00:00'
        '&end_date=${date}T23:50:00';
  }*/

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
            TextButton(
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
          msg: 'Es posible que los datos de mañana todavía no estén publicados.\n'
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
