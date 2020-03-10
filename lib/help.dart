import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  static const String id = 'help';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
