import 'package:flutter/material.dart';

class Head extends StatelessWidget {
  const Head({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: FittedBox(
              child: Text('App PVPC'),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: FittedBox(
              child: Text('Precio de la luz por horas'),
            ),
          ),
        ],
      ),
    );
  }
}
