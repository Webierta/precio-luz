import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:xml/xml.dart';

enum Status {
  none,
  ok,
  error,
  noPublicado,
  noAcceso,
  tiempoExcedido,
  errorToken
}

class Data {
  String tarifa;
  String codeTarifa;
  String fecha = '';
  List<double> preciosHoras = List<double>();
  Status status;

  static List<String> getTarifa() =>
      <String>['General 2.0 A', 'Nocturna 2.0 DHA', 'Supervalle 2.0 DHS'];

  static String getCodeTarifa(tarifaIn) {
    var listaTarifas = getTarifa();
    Map<String, String> codeTarifa = {
      listaTarifas[0]: '1013',
      listaTarifas[1]: '1014',
      listaTarifas[2]: '1015'
    };
    return codeTarifa[tarifaIn];
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
      var response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));
      if (response.body.contains('Access denied')) {
        status = Status.errorToken;
      } else if (response.statusCode == 200) {
        var objetoJson = json.decode(response.body);
        List<double> listaPrecios = List<double>();
        for (var i = 0; i < 24; i++) {
          var valor = objetoJson['indicator']['values'][i]['value'];
          listaPrecios.add(valor / 1000);
        }
        preciosHoras = List.from(listaPrecios);
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

  Future getPreciosHorasFile(String fecha, String code) async {
    var url = 'https://api.esios.ree.es/archives/80/download?date=$fecha}';
    String codeSerie;
    if (code == '1013') {
      codeSerie = 'IST10';
    } else if (code == '1014') {
      codeSerie = 'IST11';
    } else {
      codeSerie = 'IST12';
    }

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
      objetoXml = parse(responseBody);
      strXml = objetoXml.toString();

      var start = '<IdentificacionSeriesTemporales v="$codeSerie"/>';
      const end = '</SeriesTemporales>';
      final startIndex = strXml.indexOf(start);
      final endIndex = strXml.indexOf(end, startIndex);
      var subXml = strXml.substring(startIndex, endIndex);

      List<double> listaPrecios = List<double>();
      for (var i = 1; i < 25; i++) {
        var inicio = '<Pos v="$i"/><Ctd v="';
        const termino = '"/></Intervalo>';
        final indice1 = subXml.indexOf(inicio);
        final indice2 = subXml.indexOf(termino, indice1);
        var subPrecio =
            double.parse(subXml.substring(indice1 + inicio.length, indice2));
        //preciosHoras.clear();
        listaPrecios.add(subPrecio);
      }
      preciosHoras = List.from(listaPrecios);
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
