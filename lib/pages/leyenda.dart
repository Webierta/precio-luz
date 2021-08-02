import 'package:flutter/material.dart';

class Leyenda extends StatelessWidget {
  const Leyenda({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iconografía'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Periodos horarios:',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Card(
                      elevation: 4.0,
                      color: Colors.blue[50],
                      child: Container(
                        child: ListView(
                          shrinkWrap: true,
                          children: const [
                            ContainerPeriodo(
                              texto: 'Periodo Punta',
                              color: Color(0xFFe57373),
                              icono: Icons.trending_up,
                              colorIcono: Colors.red,
                            ),
                            ContainerPeriodo(
                              texto: 'Periodo Llano',
                              color: Colors.amberAccent,
                              icono: Icons.trending_neutral,
                              colorIcono: Colors.amber,
                            ),
                            ContainerPeriodo(
                              texto: 'Periodo Valle',
                              color: Color(0xFF81C784),
                              icono: Icons.trending_down,
                              colorIcono: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Diferencia respecto al precio medio del día:',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Card(
                      elevation: 4.0,
                      color: Colors.blue[50],
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.arrow_drop_down,
                                size: 50,
                                color: Colors.green,
                              ),
                              title: Text('Inferior'),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.arrow_drop_up,
                                size: 50,
                                color: Colors.red,
                              ),
                              title: Text('Superior'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Rangos de horas:',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Card(
                      elevation: 4.0,
                      color: Colors.blue[50],
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.sentiment_very_satisfied,
                                size: 30,
                                color: Colors.green[700],
                              ),
                              title: Text('8 horas más baratas'),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.sentiment_neutral,
                                size: 30,
                                color: Colors.amber[700],
                              ),
                              title: Text('8 horas intermedias'),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.sentiment_very_dissatisfied,
                                size: 30,
                                color: Colors.deepOrange[700],
                              ),
                              title: Text('8 horas más caras'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      'Rangos de precios (€/kWh):',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Card(
                      elevation: 4.0,
                      color: Colors.blue[50],
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                color: Colors.lightGreen[100],
                                child: Text('< 0,10', textAlign: TextAlign.center),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                color: Colors.yellow[50],
                                child: FittedBox(
                                    child: Text('Intermedio', textAlign: TextAlign.center)),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                color: Colors.red[100],
                                child: Text('> 0,15', textAlign: TextAlign.center),
                              ),
                            ),
                          ],
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
    );
  }
}

class ContainerPeriodo extends StatelessWidget {
  final String texto;
  final Color color;
  final IconData icono;
  final Color colorIcono;
  const ContainerPeriodo({Key key, this.texto, this.color, this.icono, this.colorIcono})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.8, color: Colors.grey),
          left: BorderSide(width: 10.0, color: color),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(texto),
            const SizedBox(width: 10),
            Icon(icono, color: colorIcono, size: 40),
          ],
        ),
      ),
    );
  }
}
