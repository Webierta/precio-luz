//import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/estados.dart';

class DatosGeneracion {
  //String fecha = '';
  StatusGeneracion status;
  Map<String, double> mapRenovables;
  Map<String, double> mapNoRenovables;

  Future<Map<String, double>> getDatosGeneracion(String fecha) async {
    var url =
        'https://apidatos.ree.es/es/datos/balance/balance-electrico?start_date=${fecha}T00:00&end_date=${fecha}T23:59&time_trunc=day';
    //https://apidatos.ree.es/es/datos/balance/balance-electrico?start_date=2021-07-28T00:00&end_date=2021-07-28T23:59&time_trunc=day
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Host': 'apidatos.ree.es',
    };
    var generacion = <String, double>{};
    try {
      var response =
          await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        Map<String, dynamic> objJson = jsonDecode(response.body);
        var renovablesValor = <String, double>{};
        var noRenovablesValor = <String, double>{};
        var included = objJson['included'];
        for (var item in included) {
          if (item['type'] == 'Renovable') {
            var renovables = item['attributes']['content'];
            for (var renovable in renovables) {
              renovablesValor[renovable['type'].toString()] =
                  renovable['attributes']['total'].toDouble();
            }
          }
          if (item['type'] == 'No-Renovable') {
            var noRenovables = item['attributes']['content'];
            for (var noRenovable in noRenovables) {
              noRenovablesValor[noRenovable['type'].toString()] =
                  noRenovable['attributes']['total'].toDouble();
            }
          }
          mapRenovables = Map.from(renovablesValor);
          mapNoRenovables = Map.from(noRenovablesValor);
          status = StatusGeneracion.ok;
          generacion..addAll(renovablesValor)..addAll(noRenovablesValor);
        }
      } else {
        //print(response.statusCode);
        status = StatusGeneracion.error;
      }
    } catch (e) {
      //print(e);
      status = StatusGeneracion.error;
    }
    return generacion;
  }
}
