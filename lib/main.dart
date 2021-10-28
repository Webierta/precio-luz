import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/inicio.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white));
  runApp(PrecioLuz());
}

class PrecioLuz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PrecioLuz',
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [const Locale('es', 'ES')],
      theme: ThemeData(
        //primaryColor: Color(0xFF151026),
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(color: const Color(0xFF1565C0)),
      ),
      home: Inicio(),
    );
  }
}
