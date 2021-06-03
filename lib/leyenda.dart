import 'package:flutter/material.dart';

class Leyenda extends StatelessWidget {
  const Leyenda({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iconografía'),
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
                      'Respecto al precio medio del día:',
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
                              title: Text('Inferior al precio medio'),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.arrow_drop_up,
                                size: 50,
                                color: Colors.red,
                              ),
                              title: Text('Superior al precio medio'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
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
                              title: Text('Las 8 horas más baratas'),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.sentiment_neutral,
                                size: 30,
                                color: Colors.amber[700],
                              ),
                              title: Text('Las 8 horas intermedias'),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.sentiment_very_dissatisfied,
                                size: 30,
                                color: Colors.deepOrange[700],
                              ),
                              title: Text('Las 8 horas más caras'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
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
                                color: Colors.lightGreen[50],
                                child: Text('< 0,10', textAlign: TextAlign.center),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                color: Colors.yellow[50],
                                child: Text('Intermedio', textAlign: TextAlign.center),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                color: Colors.red[50],
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
