import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/*class PVPC {
  // String dia;
  // String hora;
  // String precio;
  //PVPC({this.dia, this.hora, this.precio});
  */ /*factory PVPC.fromJson(Map<String, dynamic> parsedJson) {
    var jsonPVPC = parsedJson['PVPC'];
    return PVPC(
      dia: jsonPVPC['Dia'],
      hora: jsonPVPC['Hora'],
      precio: jsonPVPC['PCB'],
    );
  }*/ /*
  //PVPC.fromJson(Map<String, dynamic> json) : PCB = json['PVPC']['PCB'];

  String jsonPVPC;
  PVPC({this.jsonPVPC});
  factory PVPC.fromJson(Map<String, dynamic> json) {
    return PVPC(jsonPVPC: json['PVPC']);
  }
}*/

enum Status { none, ok, error, noPublicado, noAcceso, tiempoExcedido, errorToken }

class Datos {
  String fecha = '';
  List<String> horas = <String>[];
  List<double> preciosHora = <double>[];
  Status status;

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  Future getPreciosHoras(String url) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    Map<String, String> headers = {
      'Accept': 'application/json; application/vnd.esios-api-v1+json',
      'Host': 'api.esios.ree.es',
      'Authorization': 'Token token="$token"',
      'Cookie': '',
    };
    try {
      var response =
          await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10));
      if (response.body.contains('Access denied')) {
        status = Status.errorToken;
      } else if (response.statusCode == 200) {
        print('RESPONSE 200');
        Map<String, dynamic> objJson = jsonDecode(response.body);
        var jsonPVPC = objJson['PVPC'];
        List<String> listaDias = <String>[];
        List<String> listaHoras = <String>[];
        List<String> listaPrecios = <String>[];
        for (var obj in jsonPVPC) {
          var dia = obj['Dia'];
          var hora = obj['Hora'];
          var precio = obj['PCB'];
          listaDias.add(dia);
          listaHoras.add(hora);
          listaPrecios.add(precio);
        }
        fecha = listaDias.first;
        horas = List.from(listaHoras);
        for (var precio in listaPrecios) {
          var precioDouble = roundDouble((double.tryParse(precio.replaceAll(',', '.')) / 1000), 5);
          preciosHora.add(precioDouble);
        }
        status = Status.ok;
      } else {
        status = Status.noAcceso;
      }
    } on TimeoutException {
      status = Status.tiempoExcedido;
    } on Error {
      status = Status.error;
    }
  }

  Future getPreciosHorasFile(String fecha) async {
    var url = 'https://api.esios.ree.es/archives/80/download?date=$fecha}';
    HttpClientRequest request;
    HttpClientResponse response;
    String responseBody;
    XmlDocument objetoXml;
    String strXml;
    try {
      HttpClient http = HttpClient();
      request = await http.getUrl(Uri.parse(url));
      response = await request.close();
      responseBody = await response.transform(utf8.decoder).join();
      //objetoXml = parse(responseBody);
      objetoXml = XmlDocument.parse(responseBody);
      strXml = objetoXml.toString();

      var start = '<IdentificacionSeriesTemporales v="IST10"/>';
      const end = '</SeriesTemporales>';
      final startIndex = strXml.indexOf(start);
      final endIndex = strXml.indexOf(end, startIndex);
      var subXml = strXml.substring(startIndex, endIndex);

      List<double> listaPrecios = <double>[];
      for (var i = 1; i < 25; i++) {
        var inicio = '<Pos v="$i"/><Ctd v="';
        const termino = '"/></Intervalo>';
        final indice1 = subXml.indexOf(inicio);
        final indice2 = subXml.indexOf(termino, indice1);
        var subPrecio = double.parse(subXml.substring(indice1 + inicio.length, indice2));
        //preciosHoras.clear();
        listaPrecios.add(subPrecio);
      }
      preciosHora = List.from(listaPrecios);
      status = Status.ok;
    } on Error {
      status = Status.error;
    } finally {
      request = null;
      response = null;
      responseBody = null;
      objetoXml = null;
      strXml = null;
    }
  }

  double calcularPrecioMedio(List<double> precios) {
    return precios.reduce((a, b) => a + b) / precios.length;
  }

  double precioMin(List<double> precios) {
    return precios.reduce((curr, next) => curr < next ? curr : next);
  }

  double precioMax(List<double> precios) {
    return precios.reduce((curr, next) => curr > next ? curr : next);
  }

  String getHora(List<double> precios, double precio) {
    var pos = precios.indexOf(precio);
    return '${pos}h - ${pos + 1}h';
  }

  double getPrecio(List<double> precios, int hora) {
    return precios[hora];
  }
}
