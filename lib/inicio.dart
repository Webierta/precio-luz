import 'package:flutter/material.dart';
import 'package:precio_luz/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'head.dart';
import 'home.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final _controller = TextEditingController();
  bool _validate = false;
  SharedPreferences prefs;
  String _token;
  bool tokenVisible;

  @override
  initState() {
    leerToken();
    tokenVisible = false;
    super.initState();
  }

  leerToken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() => _token = prefs.getString('token') ?? '');
    _controller.text = _token;
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      appBar: BaseAppBar(
        title: Text('App PVPC'),
        appBar: AppBar(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Icon(
                    Icons.power, //wb_incandescent,
                    size: 150,
                    color: Colors.amber[600],
                  ),
                  Positioned(
                    right: 4.0,
                    child: Icon(
                      Icons.power, //wb_incandescent,
                      size: 150,
                      color: Colors.amber,
                    ),
                  ),
                  Positioned.fill(
                    right: 4.0,
                    child: Icon(
                      Icons.schedule,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _controller,
                obscureText: !tokenVisible,
                onChanged: (_) {
                  setState(() {
                    _controller.text.trim().isEmpty
                        ? _validate = true
                        : _validate = false;
                  });
                },
                autofocus: false,
                style: TextStyle(fontSize: 16.0),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  labelText: 'Token',
                  errorText: _validate ? 'Introduce tu token personal' : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      tokenVisible ? Icons.visibility_off : Icons.visibility,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    onPressed: () {
                      if (tokenVisible) {
                        FocusScope.of(context).unfocus();
                      }
                      setState(() => tokenVisible = !tokenVisible);
                    },
                  ),
                ),
              ),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: Color(0xff01A0C7),
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () async {
                    if (_controller.text.trim().isNotEmpty) {
                      _token = _controller.text;
                      await prefs.setString('token', _token);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(source: 'API'),
                        ),
                      );
                    } else {
                      setState(() => _validate = true);
                    }
                  },
                  child: Text(
                    "API",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0).copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30.0),
                color: const Color(0xff01A0C7),
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(source: 'FILE'),
                      ),
                    );
                  },
                  child: Text(
                    "Archivo",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0).copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Selecciona el método de descarga de datos',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: keyboardOpen ? const Fab() : null,
    );
  }
}

class Fab extends StatelessWidget {
  const Fab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    openDialog() {
      Navigator.of(context).push(
        MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(title: const Text('Ayuda')),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        const Head(),
                        Icon(
                          Icons.help_outline, //wb_incandescent,
                          size: 60,
                          color: Colors.cyan[700],
                        ),
                        Divider(),
                        SizedBox(height: 10.0),
                        Text(
                            'La aplicación admite dos métodos para la obtención de los datos: '
                            'con la API oficial (recomendado) y desde un archivo.'),
                        SizedBox(height: 10.0),
                        Text(
                            'Para utilizar la API se necesita autentificarse con un código de acceso personal '
                            '(token) que se obtiene gratuitamente solicitándolo por email a consultasios@ree.es'),
                        SizedBox(height: 10.0),
                        Text(
                            'Solo es necesario introducir el token personal la primera vez '
                            'puesto que queda almacenado en los ajustes de la aplicación.'),
                        SizedBox(height: 10.0),
                        Text(
                            'El segundo método, la extracción de datos desde un archivo, es un proceso más lento, '
                            'menos eficiente y más propenso a errores.'),
                      ],
                    ),
                  ),
                ),
              );
            },
            fullscreenDialog: true),
      );
    }

    return FloatingActionButton.extended(
      onPressed: () => openDialog(),
      icon: Icon(Icons.help_outline),
      label: Text('Ayuda'),
      backgroundColor: Colors.pink,
    );
  }
}
