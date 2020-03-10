import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:precio_luz/inicio.dart';
import 'inicio.dart';

void main() => runApp(PrecioLuz());

class PrecioLuz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PrecioLuz',
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [const Locale('es', 'ES')],
      //theme: ThemeData(primarySwatch: Colors.cyan),
      theme: ThemeData(primaryColor: Color(0xff01A0C7)),
      home: Inicio(),
    );
  }
}
