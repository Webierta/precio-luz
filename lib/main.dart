import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/inicio.dart';
import 'services/database.dart';
import 'utils/constantes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white));
  // https://sarunw.com/posts/how-to-change-status-bar-text-color-in-flutter/
  await Hive.initFlutter();
  Hive.registerAdapter(DatabaseAdapter());
  await Hive.openBox<Database>(boxPVPC);
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
        //appBarTheme: AppBarTheme(color: const Color(0xFF1565C0)),
        appBarTheme: AppBarTheme(
          color: const Color(0xFF1565C0),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: Inicio(),
    );
  }
}
