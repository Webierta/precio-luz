import 'package:hive/hive.dart';

part 'database.g.dart';

@HiveType(typeId: 1)
class Database {
  @HiveField(0)
  String fecha;
  @HiveField(1)
  List<double> preciosHora;
  @HiveField(2)
  Map<String, double> mapRenovables;
  @HiveField(3)
  Map<String, double> mapNoRenovables;
  @HiveField(4)
  Map<String, double> generacion;

  Database(
      {this.fecha,
      this.preciosHora,
      this.mapRenovables,
      this.mapNoRenovables,
      this.generacion});
}
