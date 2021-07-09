class DatosPVPC {
  //String dia;
  //String hora;
  String precio;
  //DatosPVPC({this.dia, this.hora, this.precio});
  DatosPVPC({this.precio});

  factory DatosPVPC.fromJson(Map<String, dynamic> json) {
    return DatosPVPC(
      //dia: json['Dia'],
      //hora: json['Hora'],
      precio: json['PCB'],
    );
  }
}

class DatosJson {
  final List<DatosPVPC> datosPVPC;
  DatosJson({this.datosPVPC});

  factory DatosJson.fromJson(Map<String, dynamic> json) {
    List<dynamic> listaObj = json['PVPC'];
    List<DatosPVPC> listaPVPC = listaObj.map((obj) => DatosPVPC.fromJson(obj)).toList();
    return DatosJson(datosPVPC: listaPVPC);
  }
}
