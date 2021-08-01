import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import '../utils/estados.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'datos_json.dart';

class Datos {
  String fecha = '';
  //List<String> horas = <String>[];
  List<double> preciosHora = <double>[];
  Status status;

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  Future getPreciosHoras(String fecha, Source source) async {
    var url = 'https://api.esios.ree.es/archives/70/download_json?date=$fecha';
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
        if (source == Source.api) {
          status = Status.errorToken;
        } else {
          status = Status.accessDenied;
        }
      } else if (response.statusCode == 200) {
        Map<String, dynamic> objJson = jsonDecode(response.body);
        var datosJson = DatosJson.fromJson(objJson);
        //List<String> listaDias = <String>[];
        //List<String> listaHoras = <String>[];
        List<String> listaPrecios = <String>[];
        for (var obj in datosJson.datosPVPC) {
          //listaDias.add(obj.dia);
          //listaHoras.add(obj.hora);
          listaPrecios.add(obj.precio);
        }
        //fecha = listaDias.first;
        //horas = List.from(listaHoras);
        for (var precio in listaPrecios) {
          var precioDouble = roundDouble((double.tryParse(precio.replaceAll(',', '.')) / 1000), 5);
          preciosHora.add(precioDouble);
        }
        /*if (preciosHora.length == 24) {
          status = Status.ok;
        } else {
          status = Status.error;
        }*/
        status = preciosHora.length == 24 ? Status.ok : Status.error;
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
    var url = 'https://api.esios.ree.es/archives/80/download?date=$fecha';
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
    int pos = precios.indexOf(precio);
    return '${pos}h - ${pos + 1}h';
  }

  int getHour(List<double> precios, double precio, [start = 0]) {
    return precios.indexOf(precio, start);
  }

  DateTime getDataTime(String fecha, int hora) {
    //var hora = getHour(precios, precio);
    var fechaString = '$fecha $hora';
    DateTime date = DateFormat('yyyy-MM-dd H').parse(fechaString);
    return date;
  }

  double getPrecio(List<double> precios, int hora) {
    return precios[hora];
  }

  Map<int, double> ordenarPrecios(List<double> listaPrecios) {
    var mapPrecios = listaPrecios.asMap();
    var sortedKeys = mapPrecios.keys.toList(growable: false)
      ..sort((k1, k2) => mapPrecios[k1].compareTo(mapPrecios[k2]));
    Map<int, double> mapPreciosSorted = Map.fromIterable(
      sortedKeys,
      key: (k) => k,
      value: (k) => mapPrecios[k],
    );
    return mapPreciosSorted;
  }
}
