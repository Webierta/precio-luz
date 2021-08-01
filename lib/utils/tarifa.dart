import 'package:flutter/material.dart';

import 'estados.dart';

class Tarifa {
  static Color getColorFondo(double precio) {
    if (precio < 0.10) {
      return Colors.lightGreen[100];
    } else if (precio < 0.15) {
      return Colors.yellow[50];
    } else {
      return Colors.red[100];
    }
  }

  static Color getColorBorder(double precio) {
    if (precio < 0.10) {
      return Colors.lightGreen;
    } else if (precio < 0.15) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  static Color getColorCara(List<double> preciosHoras, double valor) {
    List<double> preciosAs = List.from(preciosHoras);
    preciosAs.sort();
    if (preciosAs.indexWhere((v) => v == valor) < 8) {
      return Colors.green[700];
    } else if (preciosAs.indexWhere((v) => v == valor) > 15) {
      return Colors.deepOrange[700];
    } else {
      return Colors.amber[700];
    }
  }

  static Icon getIconCara(List<double> preciosHoras, double valor, {double size = 40.0}) {
    List<double> preciosAs = List.from(preciosHoras);
    preciosAs.sort();
    if (preciosAs.indexWhere((v) => v == valor) < 8) {
      return Icon(
        Icons.sentiment_very_satisfied, //stars, // grade, //flash_on,
        size: size,
        color: Colors.green[700],
      );
    } else if (preciosAs.indexWhere((v) => v == valor) > 15) {
      return Icon(
        Icons.sentiment_very_dissatisfied, //warning,
        size: size,
        color: Colors.deepOrange[700],
      );
    } else {
      return Icon(
        Icons.sentiment_neutral,
        size: size,
        color: Colors.amber[700],
      );
    }
  }

  static Periodo getPeriodo(DateTime fecha) {
    if (fecha.weekday > 5) {
      return Periodo.valle;
    }
    if ((fecha.month == 1 && fecha.day == 1) ||
        (fecha.month == 1 && fecha.day == 6) ||
        (fecha.month == 5 && fecha.day == 1) ||
        (fecha.month == 10 && fecha.day == 12) ||
        (fecha.month == 11 && fecha.day == 1) ||
        (fecha.month == 12 && fecha.day == 6) ||
        (fecha.month == 12 && fecha.day == 8) ||
        (fecha.month == 12 && fecha.day == 25)) {
      return Periodo.valle;
    }
    var hora = fecha.hour;
    if (hora < 8) {
      return Periodo.valle;
    } else if ((hora > 9 && hora < 14) || (hora > 17 && hora < 22)) {
      return Periodo.punta;
    } else {
      return Periodo.llano;
    }
    /* Periodo punta: De lunes a viernes de 10 a 14 h y de 18 a 22 h.
    Periodo llano: De lunes a viernes de 8 a 10 h., de 14 a 18 h. y de 22 a 24 h.
    Periodo valle: De lunes a viernes de 24 h. a 8 h. y todas las horas de fines de semana y festivos nacionales de fecha fija yel 6 de enero).
       */
  }

  static Color getColorPeriodo(Periodo periodo) {
    if (periodo == Periodo.valle) {
      return Colors.green[300];
    } else if (periodo == Periodo.punta) {
      return Colors.red[300];
    } else {
      return Colors.amberAccent;
    }
  }

  static Icon getIconPeriodo(Periodo periodo, {double size = 30.0}) {
    var _icono;
    var _color;
    if (periodo == Periodo.valle) {
      _icono = Icons.trending_down;
      _color = Colors.green;
    } else if (periodo == Periodo.punta) {
      _icono = Icons.trending_up;
      _color = Colors.red;
    } else {
      _icono = Icons.trending_neutral;
      _color = Colors.yellow;
    }
    return Icon(_icono, size: size, color: _color);
  }
}
