import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import 'home.dart';
import '../services/shared_prefs.dart';
import '../widgets/fab.dart';
import '../utils/estados.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final _controller = TextEditingController();
  bool _validate = false;
  final SharedPrefs _sharedPrefs = SharedPrefs();
  String _token;
  bool tokenVisible;

  @override
  initState() {
    leerToken();
    tokenVisible = false;
    super.initState();
  }

  leerToken() async {
    await _sharedPrefs.init();
    setState(() => _token = _sharedPrefs.token ?? '');
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
        title: const Text('Acceso PVPC'),
        appBar: AppBar(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: FittedBox(
                  child: Text(
                    'Selecciona el método de descarga de datos:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
              Stack(
                children: const <Widget>[
                  Icon(
                    Icons.power, //wb_incandescent,
                    size: 150,
                    color: Color(0xFFFFB300), // amber[600],
                  ),
                  Positioned(
                    right: 4.0,
                    child: Icon(
                      Icons.power, //wb_incandescent,
                      size: 150,
                      color: Color(0xFFFFC107), // amber,
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
                    _controller.text.trim().isEmpty ? _validate = true : _validate = false;
                  });
                },
                autofocus: false,
                style: TextStyle(fontSize: 16.0),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  labelText: 'Token',
                  errorText: _validate ? 'Introduce tu token personal' : null,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
              BotonSource(source: Source.api, action: actionApi),
              //SizedBox(height: 20.0),
              Divider(color: Colors.blueGrey, indent: 20, endIndent: 20, height: 40.0),
              BotonSource(source: Source.file, action: actionFile),
            ],
          ),
        ),
      ),
      floatingActionButton: keyboardOpen ? const Fab() : null,
    );
  }

  void actionApi() {
    if (_controller.text.trim().isNotEmpty) {
      _token = _controller.text;
      _sharedPrefs.token = _token;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home(source: Source.api)),
      );
    } else {
      setState(() => _validate = true);
    }
  }

  void actionFile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home(source: Source.file)),
    );
  }
}

class BotonSource extends StatelessWidget {
  final Source source;
  final Function action;
  const BotonSource({Key key, this.source, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xFF1565C0),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: action,
        child: Text(
          source == Source.api ? 'API' : 'Archivo',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0).copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
