import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../widgets/confirm_delete.dart';
import '../utils/constantes.dart';
import '../services/database.dart';
import '../services/datos_generacion.dart';
import '../services/datos.dart';
import '../utils/estados.dart';
import '../widgets/appbar.dart';
import 'resultados.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Datos _datos = Datos();
  DateTime hoy = DateTime.now().toLocal();
  String _fechaIn;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dataController;
  bool noPublicado = false;
  bool seguirConsulta = true;
  bool _progressActive = false;
  DatosGeneracion _datosGeneracion = DatosGeneracion();

  String txtProgress = '';
  bool dateStorage = false;
  Box<Database> boxData;

  loadDataBase(Database consulta) {
    DateTime _time = DateFormat('dd/MM/yyyy').parse(consulta.fecha);
    _datos.fecha = DateFormat('yyyy-MM-dd').format(_time);
    _datos.preciosHora = List.from(consulta.preciosHora);
    _datos.status = Status.ok;
    _datosGeneracion.mapRenovables = consulta.mapRenovables;
    _datosGeneracion.mapNoRenovables = consulta.mapNoRenovables;
    _datosGeneracion.generacion = consulta.generacion;
    _datosGeneracion.status = StatusGeneracion.ok;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Resultado(
          fecha: consulta.fecha,
          data: _datos,
          datosGeneracion: _datosGeneracion,
        ),
      ),
    );
  }

  getDataBase(String fecha) {
    Database consulta = boxData.get(fecha) ?? null;
    if (consulta != null) {
      loadDataBase(consulta);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ese archivo ha sido eliminado')));
    }
  }

  saveDataBase({String fecha, Datos data, DatosGeneracion datosGeneracion}) {
    var consulta = Database()
      ..fecha = fecha
      ..preciosHora = data.preciosHora
      ..mapRenovables = datosGeneracion.mapRenovables
      ..mapNoRenovables = datosGeneracion.mapNoRenovables
      ..generacion = datosGeneracion.generacion;
    boxData.put(fecha, consulta);
  }

  checkDateDataBase(String fecha) {
    setState(() => dateStorage = boxData?.containsKey(fecha) ?? false);
  }

  clearBox() {
    boxData.clear();
    setState(() => dateStorage = false);
  }

  @override
  void initState() {
    Intl.defaultLocale = 'es_ES';
    _fechaIn = DateFormat('yyyy-MM-dd').format(hoy);
    _dataController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(hoy));
    boxData = Hive.box<Database>(boxPVPC);
    checkDateDataBase(_dataController.text);
    super.initState();
  }

  @override
  void dispose() {
    _dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Intl.defaultLocale = 'es_ES';
    //DateTime manana = DateTime(hoy.year, hoy.month, hoy.day + 1);
    return (boxData == null || !(boxData.isOpen))
        ? CircularProgressIndicator()
        : Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                colors: [Colors.white, Colors.blue],
                tileMode: TileMode.mirror,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: BaseAppBar(
                title: const Text('Consulta PVPC'),
                appBar: AppBar(),
              ),
              body: SafeArea(
                child: _progressActive == true
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.blue),
                                backgroundColor: Colors.yellow,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(txtProgress),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        //physics: const NeverScrollableScrollPhysics(),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                buildForm(context),
                                const SizedBox(height: 20),
                                const Divider(),
                                ListTile(
                                  title: const Text('Recupera datos archivados'),
                                  subtitle: const Text('No requiere conexión a internet'),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      size: 32,
                                      color: Colors.black45,
                                    ),
                                    onPressed: () async {
                                      if (boxData?.isEmpty ?? true) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('Archivo sin datos. Nada que hacer')));
                                      } else {
                                        bool eliminar = await confirmDelete(context);
                                        if (eliminar == true) {
                                          clearBox();
                                        }
                                      }
                                    },
                                  ),
                                ),
                                Almacen(
                                  datos: _datos,
                                  datosGeneracion: _datosGeneracion,
                                  boxData: boxData,
                                  fechaForm: _dataController.text,
                                  onDismissed: checkDateDataBase,
                                  load: loadDataBase,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          );
  }

  Form buildForm(BuildContext context) {
    DateTime manana = DateTime(hoy.year, hoy.month, hoy.day + 1);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              'Consulta los datos de una fecha:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              //isDense: true,
              labelText: dateStorage ? 'Fecha en archivo' : 'Fecha',
              labelStyle: TextStyle(
                color: dateStorage ? Colors.red : Colors.black45,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: const Icon(
                Icons.calendar_today,
                color: Colors.black45,
              ),
              border: InputBorder.none,
              //contentPadding: const EdgeInsets.only(right: 30.0),
              suffixIcon: dateStorage
                  ? Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: InkWell(
                        child: Icon(
                          Icons.storage, //restore_page,
                          color: Color(0xFF1565C0),
                          size: 32,
                        ),
                        onTap: () => getDataBase(_dataController.text),
                      ),
                    )
                  : null,
            ),
            style: const TextStyle(
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
                checkDateDataBase(_dataController.text);
                setState(() {
                  _fechaIn = DateFormat('yyyy-MM-dd').format(picked);
                  _datos.fecha = _fechaIn;
                });
                noPublicado = picked == manana && hoy.hour < 20 ? true : false;
              }
            },
          ),
          MaterialButton(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            color: const Color(0xFF1565C0),
            minWidth: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: const Text(
              'CONSULTAR',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
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
        ],
      ),
    );
  }

  dialogoNoPublicado() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aviso'),
          content: const Text('En torno a las 20:15h de cada día, la REE publica los precios '
              'de la electricidad que se aplicarán al día siguiente, por lo que '
              'es posible que los datos todavía no estén publicados.'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                seguirConsulta = false;
                _progressActive = false;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Consultar'),
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
    setState(() => txtProgress = 'Iniciando consulta...');
    _formKey.currentState.save();
    _datos.fecha = _fechaIn;
    _datos.preciosHora.clear();
    //_datosHoy.preciosHora.clear(); // ????

    /*widget.source == 'API'
        ? await _datos.getPreciosHoras(_datos.fecha)
        : await _datos.getPreciosHorasFile(_datos.fecha);*/
    await _datos.getPreciosHoras(_datos.fecha);
    //if (_datos.status == Status.accessDenied) {
    if (_datos.status != Status.ok) {
      setState(() => txtProgress = 'Consultando archivo...');
      await _datos.getPreciosHorasFile(_datos.fecha);
    }
    //var _hoyDate = DateFormat('yyyy-MM-dd').format(hoy);
    if (_datos.status == Status.tiempoExcedido) {
      checkStatus(Status.tiempoExcedido);
    } else if (_datos.status == Status.noInternet) {
      checkStatus(Status.noInternet);
    } else if (noPublicado == true && _datos.status == Status.error) {
      checkStatus(Status.noPublicado);
    } else if (_datos.status != Status.ok) {
      checkStatus(_datos.status);
    } else {
      var fecha = _datos.fecha.toString();
      //consultarDataBase(fecha);
      setState(() {
        dateStorage = true;
        txtProgress = 'Consultando datos generación...';
      });
      await _datosGeneracion.getDatosGeneracion(fecha);
      saveDataBase(fecha: _dataController.text, data: _datos, datosGeneracion: _datosGeneracion);
      /*var consulta = Database()
        ..fecha = fecha
        ..preciosHora = _datos.preciosHora
        ..mapRenovables = _datosGeneracion.mapRenovables
        ..mapNoRenovables = _datosGeneracion.mapNoRenovables
        ..generacion = _datosGeneracion.generacion;
      dataBox.saveDataBase(consulta);*/

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Resultado(
            fecha: _dataController.text,
            data: _datos,
            datosGeneracion: _datosGeneracion,
          ),
        ),
      ).then(
        (value) => setState(() {
          txtProgress = '';
          _progressActive = false;
        }),
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
      case Status.noInternet:
        _showError(
          titulo: 'Error',
          msg: 'Comprueba tu conexión a internet.',
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

class Almacen extends StatelessWidget {
  final Datos datos;
  final DatosGeneracion datosGeneracion;
  final Box<Database> boxData;
  final String fechaForm;
  final Function(String) onDismissed;
  final Function(Database) load;

  const Almacen({
    Key key,
    this.datos,
    this.datosGeneracion,
    this.boxData,
    this.fechaForm,
    this.onDismissed,
    this.load,
  }) : super(key: key);

  List<Database> ordenarBox(List<Database> consultas) {
    List<DateTime> dateOrdenadas = [];
    DateFormat format = DateFormat("dd/MM/yyyy");
    for (int i = 0; i < consultas.length; i++) {
      dateOrdenadas.add(format.parse(consultas[i].fecha));
    }
    dateOrdenadas.sort((a, b) => a.compareTo(b));
    List<String> fechasOrdenadas = [];
    for (DateTime date in dateOrdenadas) {
      fechasOrdenadas.add(DateFormat('dd/MM/yyyy').format(date));
    }
    List<Database> consultasOrdenadas = [];
    for (var i = 0; i < fechasOrdenadas.length; i++) {
      var fecha = fechasOrdenadas[i];
      for (var j = 0; j < consultas.length; j++) {
        var consulta = consultas[j];
        if (consulta.fecha == fecha) {
          consultasOrdenadas.insert(i, consulta);
        }
      }
    }
    return List.from(consultasOrdenadas.reversed);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ValueListenableBuilder(
        valueListenable: boxData.listenable(),
        builder: (context, Box<Database> box, _) {
          if (box.isEmpty || !(box.isOpen)) {
            return Center(child: Text('Archivo vacío'));
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: box.values.length,
              itemBuilder: (BuildContext context, int index) {
                Database consulta;
                if (box.values.toList().length > 1) {
                  List<Database> valoresSorted = List.from(ordenarBox(box.values.toList()));
                  consulta = valoresSorted[index];
                } else if (box.values.toList().length == 1) {
                  //consulta = box.getAt(index);
                  consulta = box.values.toList().first;
                } else {
                  return Center(child: Text('Archivo vacío'));
                }
                //final Database consulta = box.getAt(index);
                return Dismissible(
                  direction: DismissDirection.startToEnd,
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    box.delete(consulta.fecha); //box.deleteAt(index);
                    ////checkDateDataBase(fecha_control); // consulta.fecha
                    //Function(String) f = onDismissed;
                    //f(fechaForm);
                    onDismissed(fechaForm);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Datos eliminados del ${consulta.fecha}')),
                    );
                  },
                  background: Container(
                    alignment: AlignmentDirectional.centerStart,
                    color: const Color(0xFFF44336),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: Card(
                    color: const Color(0xFF1565C0),
                    child: ListTile(
                      title: Text(
                        consulta.fecha,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => load(consulta),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
