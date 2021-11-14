import 'package:flutter/material.dart';

import '../widgets/appbar.dart';
import 'home.dart';
import '../services/shared_prefs.dart';
import '../widgets/fab.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final _controller = TextEditingController();
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
    final bool keyboardClose = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Container(
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
          title: const Text('Acceso PVPC'),
          appBar: AppBar(),
        ),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'assets/images/ic_launcher.png',
                    scale: keyboardClose ? 1 : 2,
                  ),
                  SizedBox(height: 10),
                  FractionallySizedBox(
                    widthFactor: 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _controller,
                          obscureText: !tokenVisible,
                          autofocus: false,
                          style: const TextStyle(fontSize: 16.0),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            labelText: 'Token',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.0)),
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
                        MaterialButton(
                          minWidth: double.infinity,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          color: const Color(0xFF1565C0),
                          padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: actionApi,
                          child: Text(
                            'INICIO',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0).copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: keyboardClose ? const Fab() : null,
      ),
    );
  }

  void actionApi() {
    if (_controller.text.trim().isEmpty) {
      _token = '';
    } else {
      _token = _controller.text;
    }
    _sharedPrefs.token = _token;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }
}
