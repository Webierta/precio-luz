import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/read_file.dart';
import '../widgets/head.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _showMaterialDialog() {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                backgroundColor: Color(0xFF1565C0),
                title: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Fórmula PVPC', style: TextStyle(color: Colors.white)),
                  ],
                ),
                content: Formula(),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, true), // passing true
                    child: Text('Volver'),
                  ),
                ],
              ));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Info')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Head(),
                const Icon(Icons.info_outline, size: 60, color: Color(0xFF1565C0)),
                const Divider(),
                const SizedBox(height: 10.0),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 20, color: Colors.black87),
                    children: [
                      const TextSpan(
                        text:
                            'Esta App ofrece información general y detallada sobre la tarifa eléctrica regulada, el denominado ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline,
                        ),
                        text: 'Precio Voluntario para el Pequeño Consumidor (PVPC)',
                        recognizer: TapGestureRecognizer()..onTap = () => _showMaterialDialog(),
                      ),
                      const TextSpan(
                        text: ', con las horas más baratas y más caras a lo largo de un día para '
                            'facilitar el ajuste de los hábitos de consumo buscando el ahorro en la '
                            'factura de la luz. En definitiva, esta App trata de ayudar a gestionar '
                            'el consumo eléctrico de forma más eficiente.',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                //_textoABout(context),
                const ReadFile(archivo: 'assets/files/info.txt'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Formula extends StatefulWidget {
  const Formula({Key key}) : super(key: key);
  @override
  _FormulaState createState() => _FormulaState();
}

class _FormulaState extends State<Formula> {
  bool visiblePoliticos = false;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('Producción (OMIE)  +', style: TextStyle(color: Colors.white)),
          const Text('Distribución (REE)  +', style: TextStyle(color: Colors.white)),
          const Text('Impuestos (IVA)  +', style: TextStyle(color: Colors.white)),
          const FittedBox(
            child: Text('Otros costes regulados  +', style: TextStyle(color: Colors.white)),
          ),
          InkWell(
            onTap: () => setState(() {
              visiblePoliticos = !visiblePoliticos;
              if (visiblePoliticos) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _controller.animateTo(
                    _controller.position.maxScrollExtent,
                    duration: Duration(seconds: 1),
                    curve: Curves.ease,
                  );
                });
              } else {
                _controller.animateTo(_controller.position.minScrollExtent,
                    duration: Duration(seconds: 1), curve: Curves.ease);
              }
            }),
            child: const FittedBox(
              child: Text('Otros costes no regulados*  +', style: TextStyle(color: Colors.white)),
            ),
          ),
          const Divider(color: Colors.white70),
          const Text('= PVPC', style: TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          Opacity(
            opacity: visiblePoliticos ? 1.0 : 0.0,
            child: const Text(
              '* Prácticas comerciales oligopolistas en un sistema opaco y sin libre competencia '
              'permitido por la Comisión Nacional de la Competencia y los políticos, '
              'habituales de las puertas giratorias.',
              textScaleFactor: 1,
              style: TextStyle(color: Colors.white70),
            ),
          )
        ],
      ),
    );
  }
}
