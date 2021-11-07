enum Source { api, file }

enum Status {
  none,
  ok,
  error,
  noPublicado,
  noAcceso,
  tiempoExcedido,
  errorToken,
  accessDenied,
  noInternet
}

enum StatusGeneracion { ok, error }

enum Periodo { llano, valle, punta }

extension PeriodoEx on Periodo {
  String get nombre {
    switch (this) {
      case Periodo.llano:
        return 'LLANO';
      case Periodo.valle:
        return 'VALLE';
      case Periodo.punta:
        return 'PUNTA';
      default:
        return 'Error';
    }
  }
}

enum Generacion { renovable, noRenovable }

extension GeneracionExt on Generacion {
  String get texto {
    switch (this) {
      case Generacion.renovable:
        return 'Generación renovable';
      case Generacion.noRenovable:
        return 'Generación no renovable';
      default:
        return 'Error';
    }
  }

  String get tipo {
    switch (this) {
      case Generacion.renovable:
        return 'Renovables';
      case Generacion.noRenovable:
        return 'No renovables';
      default:
        return 'Renovables';
    }
  }
}
